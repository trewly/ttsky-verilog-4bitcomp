`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2026 01:54:06 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input  [3:0] op_code,
    output reg [1:0] op_sel
);

localparam NAND = 4'b1000;
localparam NOR  = 4'b1001;
localparam XOR  = 4'b1010;
localparam ADD  = 4'b1011;

always @(*) begin
    // Default values
    op_sel = 2'b00;

    case (op_code)
        NAND: begin
            op_sel = 2'b00;   // NAND
        end

        NOR: begin
            op_sel = 2'b01;   // NOR
        end

        XOR: begin
            op_sel = 2'b10;   // XOR
        end

        ADD: begin
            op_sel = 2'b11;   // ADD
        end

        default: begin
            op_sel = 2'b00;
        end
    endcase
end

endmodule