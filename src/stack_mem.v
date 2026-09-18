`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2026 03:06:29 PM
// Design Name: 
// Module Name: stack_mem
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


module stack_mem(
    input clk,
    input rst,
    input [3:0] stack_in,
    input [2:0] stack_top,
    input stack_mem_read,
    input stack_result_read,
    input stack_mem_write,
    output reg [3:0] stack_out
    );
    
reg [3:0] _stack_mem [7:0];

//integer i;

always@(posedge clk) begin
    if(rst) begin
        //for (i = 0; i < 8; i = i + 1)
        //_stack_mem[i] <= 4'b0;
        stack_out <= 4'b0;
    end
    else begin
        if(stack_mem_read || stack_result_read)begin
            stack_out <= _stack_mem[stack_top-1];
        end else if (stack_mem_write) begin
            _stack_mem[stack_top] <= stack_in;             
        end
            
    end
end
endmodule
