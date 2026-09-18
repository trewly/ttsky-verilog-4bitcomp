`default_nettype none

module alu(
    input  [3:0] in_1,
    input  [3:0] in_2,
    input        alu_en,
    input  [1:0] op_sel,
    output reg [3:0] alu_out
    );
    
always @(*) begin
    if (alu_en) begin
        case (op_sel)
            2'b00: alu_out = ~(in_1 & in_2);  // NAND
            2'b01: alu_out = ~(in_1 | in_2);  // NOR
            2'b10: alu_out =  (in_1 ^ in_2);  // XOR
            2'b11: alu_out =  in_1 + in_2;    // ADD
            default: alu_out = 4'b0000;
        endcase
    end
    else begin
        alu_out = 4'b0000;
    end
end

endmodule
