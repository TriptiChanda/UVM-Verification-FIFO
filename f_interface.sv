interface f_interface(input wr_clk, rd_clk, reset);
  bit wr_en;
  bit rd_en;
  bit [31:0] data_in;
  bit fifo_almost_full;
  bit fifo_almost_empty;
  bit fifo_full;
  bit fifo_empty;
  bit [31:0] data_out;
  
  clocking dr_cb @(posedge rd_clk);
    default input #1 output #1;
    output wr_en;
    output rd_en;
    output data_in;
    input fifo_full;
    input fifo_empty;
    input fifo_almost_full;
    input fifo_almost_empty;
    input data_out;
  endclocking
    
  clocking dw_cb @( posedge wr_clk);
    default input #1 output #1;
    output wr_en;
    output rd_en;
    output data_in;
    input fifo_full;
    input fifo_empty;
    input fifo_almost_full;
    input fifo_almost_empty;
    input data_out;
  endclocking
  
  clocking mr_cb @(posedge rd_clk );
    default input #2 output #2;
    input wr_en;
    input rd_en;
    input data_in;
    input fifo_full;
    input fifo_empty;
    input fifo_almost_full;
    input fifo_almost_empty;
    input data_out;
  endclocking
  
   clocking mw_cb @(posedge wr_clk);
    default input #2 output #2;
    input wr_en;
    input rd_en;
    input data_in;
    input fifo_full;
    input fifo_empty;
    input fifo_almost_full;
    input fifo_almost_empty;
    input data_out;
  endclocking
  
  modport dr_mp (input  rd_clk, reset, clocking dr_cb);
  modport dw_mp (input wr_clk, reset, clocking dw_cb);
  modport mr_mp (input  rd_clk, reset, clocking mr_cb);
  modport mw_mp (input wr_clk, reset, clocking mw_cb);
    
endinterface