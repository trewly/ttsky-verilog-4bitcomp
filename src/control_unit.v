`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2026 10:13:59 AM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input clk,
    input [3:0] op_code,
    input rst,
    input start_en,
    input stop_signal,
    output [1:0] op_sel,
    input cond_flag,
    output reg alu_en,
    output reg stack_mem_read,
    output reg stack_mem_write,
    output reg choose_push_datain,
    output reg allow_program_mem_write,
    output reg allow_program_mem_read,
    output reg sp_inc,
    output reg sp_dec,
    output reg push_comp_value,
    output reg update_cond_flag,
    output reg lets_jump,
    output reg allow_result_read
    );
    
decoder decoder_inst(
    .op_code(op_code),
    .op_sel(op_sel)
);

//opcode var
localparam NAND = 4'b1000;
localparam NOR = 4'b1001;
localparam XOR = 4'b1010;
localparam ADD = 4'b1011;

localparam ALU_OPERATION = 2'b10;

localparam PUSH = 4'b1110;
localparam PUSH_COMP = 4'b1101;

localparam JMPC= 4'b0010;

//fsm machine var
localparam FETCH     = 3'b000;
localparam DECODE    = 3'b001;
localparam EXECUTE   = 3'b010;
localparam WRITEBACK = 3'b011;
localparam UPDATE = 3'b100;
localparam IDLE = 3'b101;

reg [2:0] fsm_state;
reg [2:0] next_state;

//FSM Transition
always @(posedge clk) begin
    if(rst)
        fsm_state <= IDLE;
     else
        fsm_state <= next_state;
end

//FSM next stage
always @(*) begin
    case(fsm_state)
        IDLE:
            if(start_en)
                next_state=FETCH;
            else
            	next_state=IDLE;
        FETCH:
            next_state=DECODE;
        DECODE:
            next_state=EXECUTE;
        EXECUTE:
            next_state=WRITEBACK;
        WRITEBACK:
            next_state= UPDATE;       
        UPDATE:  
            if(stop_signal)
                next_state=IDLE;
            else
                next_state=FETCH;   
        default: 
            next_state=IDLE;
     endcase
end

//FSM signal
always @(*) begin
    //default value
    alu_en = 1'b0;
    stack_mem_read=1'b0;
    stack_mem_write=1'b0;
    choose_push_datain=1'b0;
    allow_program_mem_write = 1'b0;
    allow_program_mem_read = 1'b0;
    sp_inc=1'b0;
    sp_dec=1'b0;
    push_comp_value=1'b0;
    update_cond_flag=1'b0;
    lets_jump=1'b0;
    allow_result_read=1'b0;
    case(fsm_state)
        IDLE:begin
            allow_program_mem_write = 1'b1;
            allow_result_read = 1'b1;
        end
        
        FETCH:begin
            allow_program_mem_read = 1'b1;
        end
        
        DECODE:begin
            if(op_code[3:2]==ALU_OPERATION)begin
                stack_mem_read=1'b1;
                sp_dec=1'b1;
            end 
        end
        
        EXECUTE: begin
            if(op_code[3:2]==ALU_OPERATION)begin
                alu_en = 1'b1;
            end 
        end
        
        WRITEBACK:begin
            if(op_code[3:2]==ALU_OPERATION || op_code==PUSH)
                stack_mem_write = 1'b1;
            if(op_code==PUSH) begin
                choose_push_datain = 1'b1;
                //sp_inc = 1'b1;
            end else if (op_code==PUSH_COMP) begin
                push_comp_value = 1'b1;
            end else if (op_code==JMPC && cond_flag)
                lets_jump = 1'b1;
        end
        
        UPDATE:begin
              if(op_code[3:2]==ALU_OPERATION || op_code==PUSH) begin
                sp_inc = 1'b1;
                update_cond_flag = 1'b1;
              end else if (op_code==PUSH_COMP)
                update_cond_flag = 1'b1;
        end
        
        default: begin
        
        end                
     endcase
end

endmodule
