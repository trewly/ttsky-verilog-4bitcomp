/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_trewlyvuive_4bitcomp#( 
    parameter IS_TEST = 0	
)(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

wire rst = !rst_n;

assign uio_oe = 8'b0000_0000;
assign uio_out = 8'b0000_0000;

top_comp #(
    .IS_TEST(IS_TEST)
) top_comp_inst(
   .program_in(ui_in[7:0]),//8 input
   .clk(clk), //clk
   .rst(rst), //rst
   .read_result_button(uio_in[0]), // 1 io
   .start_button(uio_in[1]), // 1 io
   .program_mem_write_button(uio_in[2]),// 1 io
   .after_compute(uo_out[3:0]), // 4 output
   .program_stack(uo_out[7:4]) // 4 output
);

 
endmodule
