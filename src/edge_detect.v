`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2026 11:35:13 AM
// Design Name: 
// Module Name: edge_detect
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


module edge_detect#(
    parameter CLK_FREQ=20_000_000,
    parameter DEBOUNCE_MS=10
)(
    input clk,
    input rst,
    input signal,
    output signal_rising_edge
    );

reg sync_1;
reg sync_2;

reg button_state;
reg button_state_d;

//avoid metastable
always@ (posedge clk) begin
   if(rst) begin
      sync_1 <= 0;
      sync_2 <= 0;
   end else begin   
       sync_1 <= signal;
       sync_2 <= sync_1;
   end
end    

//setup counter variable 
localparam MAX_COUNT = (CLK_FREQ/1000)*DEBOUNCE_MS;
localparam COUNTER_WIDTH = $clog2(MAX_COUNT);
reg [COUNTER_WIDTH-1:0] counter;

//detect right signal
always@(posedge clk) begin
    if(rst) begin
        button_state <= 0;
        counter <= 0;
    end
    else begin
        if(sync_2 != button_state) begin
            if(counter == MAX_COUNT -1) begin
                counter <= 0;
                button_state <= sync_2;
            end else
                counter <= counter + 1;              
        end else 
            counter <= 0;
    end
end

//detect rising edge
always@(posedge clk) begin
    if(rst)
        button_state_d <= 0;
     else 
        button_state_d <= button_state;
end

assign signal_rising_edge = button_state & ~button_state_d;

endmodule
