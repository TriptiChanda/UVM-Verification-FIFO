`timescale 1ns/1ps
module shift_register#(
 parameter integer WIDTH=3, 
 parameter integer NUM_OF_STAGES=2,
 parameter logic[WIDTH-1:0] RESET_VALUE=0) 
(
  input logic clk, reset, 
  input logic [WIDTH-1:0] d,
  output logic [WIDTH-1:0] q
);

 logic[WIDTH-1:0] r[NUM_OF_STAGES-1:0];
 always@(posedge clk, posedge reset) begin
  if(reset == 1) begin
    for(int i=0; i<NUM_OF_STAGES; i++) begin
        r[i] <= RESET_VALUE;
    end 
  end
  else begin
    r[0] <= d;
    for(int i=0; i<(NUM_OF_STAGES-1); i++) begin
      r[i+1] <= r[i];
    end
  end
 end
 assign q = (reset==1) ? RESET_VALUE : r[NUM_OF_STAGES-1];
endmodule: shift_register




