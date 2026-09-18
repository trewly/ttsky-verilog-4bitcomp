`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2026 02:00:58 PM
// Design Name: 
// Module Name: top_comp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_comp#(
    parameter IS_TEST=0
)(
    input [7:0] program_in, //8 input
    input clk, 
    input rst, // 1 io
    input read_result_button, // 1 io
    input start_button, // 1 io
    input program_mem_write_button,// 1 io
    output [3:0] after_compute, // 4 io
    output [3:0] program_stack // 5 output
    );

//else
wire start_signal;
wire read_signal;
reg stop_signal;
wire stack_result_read;

//parameter
localparam EDGE_CLK_FREQ    = IS_TEST ? 1000       : 20_000_000;
localparam EDGE_DEBOUNCE_MS = IS_TEST ? 2          : 10;

//variable
wire [3:0] op_code;
wire [3:0] alu_out;
wire [3:0] in_2;
wire [3:0] in_1;
reg [3:0] alu_result_reg;

//control unit output signal
wire alu_en;
wire [1:0] op_sel;
wire stack_mem_read;
wire stack_mem_write;
wire choose_push_datain;
wire sp_inc;
wire sp_dec;
wire allow_program_mem_write;
wire allow_program_mem_read;
wire push_comp_value;
wire update_cond_flag;
wire lets_jump;
wire allow_result_read;

//program memory
//wire [7:0] program_in;
//wire program_mem_read;
wire program_mem_write;
reg [3:0] program_read_counter;
reg [3:0] program_write_counter;

wire [7:0] instruction;

//stack memory
reg [2:0] stack_top;
reg [3:0] stack_in;

//jump flag 
reg cond_flag;
reg [3:0] comp_value;

/******************************
DATA PATH LOGIC CONFIGURATION
*******************************/
//add value to comp_value
always @(posedge clk) begin
    if(rst)
        comp_value <= 4'b0000;
    else if (push_comp_value)
        comp_value <= in_2;
end

always@(posedge clk)begin
    if(rst)
        cond_flag<=0;
    else if(update_cond_flag)
        cond_flag <= ~(comp_value == alu_result_reg);
end

//save alu_out to alu_reg
always @(posedge clk) begin
    if (rst)
        alu_result_reg <= 4'b0000;

    else if (alu_en)
        alu_result_reg <= alu_out;
end

//in2 and opcode
assign in_2 = instruction[3:0];
assign op_code = instruction[7:4];

//stack memory - top address
always@(posedge clk) begin
    if(rst)
        stack_top<=0;
    else begin
        if(sp_inc)       
            stack_top <= stack_top+1'b1;
        else if(sp_dec)
            stack_top <= stack_top-1'b1;
    end 
end

//stack memory - stack_in
always @(*) begin
    if (choose_push_datain)
        stack_in = in_2;
    else
        stack_in = alu_result_reg;
end

//program memory - program_in
always@(posedge clk) begin
    if(rst) begin
        program_write_counter <= 0;
    end else begin
        if(allow_program_mem_write && program_mem_write) begin
            program_write_counter <= program_write_counter + 1;
        end
    end  
end

//program memory - program_read
always@(posedge clk) begin
    if(rst) begin
        program_read_counter <= 0;
    end else begin
        if(allow_program_mem_read) begin
             program_read_counter <= program_read_counter + 1;           
        end else if (lets_jump)
            program_read_counter <= in_2;
    end  
end

//check stop signal
always@(*) begin
    if(program_read_counter == program_write_counter+1)
        stop_signal = 1;
    else
    	stop_signal = 0;
end

//display program stack
assign program_stack = program_write_counter;
//check if can read the result
assign stack_result_read = allow_result_read & read_signal;
assign  after_compute = in_1;

/******************************
COMPUTER'S PERIPHERAL MODULE
*******************************/
edge_detect#(
    .CLK_FREQ(EDGE_CLK_FREQ),
    .DEBOUNCE_MS(EDGE_DEBOUNCE_MS)
) program_inst(
    .clk(clk),
    .rst(rst),
    .signal(program_mem_write_button),
    .signal_rising_edge(program_mem_write)
);

edge_detect#(
    .CLK_FREQ(EDGE_CLK_FREQ),
    .DEBOUNCE_MS(EDGE_DEBOUNCE_MS)
) start_inst(
    .clk(clk),
    .rst(rst),
    .signal(start_button),
    .signal_rising_edge(start_signal)
);

edge_detect#(
    .CLK_FREQ(EDGE_CLK_FREQ),
    .DEBOUNCE_MS(EDGE_DEBOUNCE_MS)
) read_inst(
    .clk(clk),
    .rst(rst),
    .signal(read_result_button),
    .signal_rising_edge(read_signal)
);
/******************************
COMPUTER'S MODULE INTITIATION 
*******************************/
//program memory
program_mem_main program_mem_main_inst(
    .clk(clk),
    .rst(rst),
    .program_in(program_in),
    .program_write_counter(program_write_counter),
    .program_read_counter(program_read_counter),
    .program_mem_read(allow_program_mem_read),
    .program_mem_write(program_mem_write),
    .program_out(instruction)
);

//stack memory
stack_mem stack_mem_inst(
    .clk(clk),
    .rst(rst),
    .stack_top(stack_top),
    .stack_in(stack_in),
    .stack_out(in_1),
    .stack_mem_read(stack_mem_read),
    .stack_result_read(stack_result_read),
    .stack_mem_write(stack_mem_write)
);


// Control unit
control_unit control_unit_inst(
    .clk(clk),
    .op_code(op_code),
    .rst(rst),
    .start_en(start_signal),
    .stop_signal(stop_signal),
    .op_sel(op_sel),
    .cond_flag(cond_flag),
    .alu_en(alu_en),
    .stack_mem_read(stack_mem_read),
    .stack_mem_write(stack_mem_write),
    .choose_push_datain(choose_push_datain),
    .allow_program_mem_write(allow_program_mem_write),
    .allow_program_mem_read(allow_program_mem_read),
    .sp_inc(sp_inc),
    .sp_dec(sp_dec),
    .push_comp_value(push_comp_value),
    .update_cond_flag(update_cond_flag),
    .lets_jump(lets_jump),
    .allow_result_read(allow_result_read)
    );

// ALU
alu alu_inst(
    .in_1(in_1),
    .in_2(in_2),
    .alu_en(alu_en),
    .op_sel(op_sel),
    .alu_out(alu_out)
);

endmodule
    
