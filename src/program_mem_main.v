`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 03:59:55 PM
// Design Name: 
// Module Name: program_mem_main
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


module program_mem_main(
    input clk,
    input rst,
    input [7:0] program_in,
    input [3:0] program_write_counter,
    input [3:0] program_read_counter,
    input program_mem_read,
    input program_mem_write,
    output reg [7:0] program_out
    );

reg [7:0] _program_mem [15:0];

//integer i;

always@(posedge clk) begin    
    if(rst) begin
        //for (i = 0; i < 32; i = i + 1)
        // _program_mem[i] <= 8'b0;
        program_out <= 8'b0;
    end 
    else begin
        if(program_mem_read)begin
            program_out <= _program_mem[program_read_counter];
        end 
        else if(program_mem_write)begin
            _program_mem[program_write_counter] <= program_in;
        end
    end
end

endmodule
