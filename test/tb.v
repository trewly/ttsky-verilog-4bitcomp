`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  //signal test
  reg [7:0] program_in;
  reg clk;
  reg start_button;
  reg program_mem_write_button;
  reg read_result_button;
  wire [3:0] after_compute;
  wire [3:0] program_stack;
 
  assign after_compute = uo_out[3:0];
  assign program_stack = uo_out[7:4];

  // Replace tt_um_example with your module name:
  tt_um_trewlyvuive_4bitcomp#(
     .IS_TEST(1)
   )
  tt_um_trewlyvuive_4bitcomp_inst (
      .ui_in  (program_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in ({5'b0_0000,program_mem_write_button,start_button,read_result_button}),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule
