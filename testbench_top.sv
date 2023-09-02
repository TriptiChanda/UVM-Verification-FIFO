import uvm_pkg::*;
`include "uvm_macros.svh"
`include "f_interface.sv"
`include "f_test.sv"

module tb;
  bit wr_clk;
  bit rd_clk;
  bit reset;
  parameter DATA_WIDTH=32;
  parameter FIFO_DEPTH=16; 
  
// wr_clock generator
always #10 wr_clk = ~wr_clk;

// rd_clock generator
always #20 rd_clk = ~rd_clk;
  
//Stimulus
initial begin
 // Initiliase Input Stimulus
 //data_in = 0;
 wr_clk = 0;
 //wr_en = 0;
 rd_clk = 0;
 //rd_en = 0;

 // apply reset sequence
 reset = 1;
 #5;
 reset = 0;
  end
  
  f_interface tif(wr_clk, rd_clk, reset);
  
  async_fifo#(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) dut(.wr_clk(tif.wr_clk),
                                                                    .rd_clk(tif.rd_clk),
               .reset(tif.reset),
               .data_in(tif.data_in),
                 .wr_en(tif.wr_en),
                 .rd_en(tif.rd_en),
                 .fifo_full(tif.fifo_full),
                 .fifo_empty(tif.fifo_empty),
                 .fifo_almost_full(tif.fifo_almost_full),
                 .fifo_almost_empty(tif.fifo_almost_empty),
               .data_out(tif.data_out));
  
  initial begin
    uvm_config_db#(virtual f_interface)::set(null, "", "vif", tif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
    run_test("f_test");
    //run_test("f_test_1");
  end
  
endmodule