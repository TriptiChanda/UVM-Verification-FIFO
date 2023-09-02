class f_coverage extends uvm_subscriber#(f_sequence_item);
  uvm_analysis_imp#(f_sequence_item, f_coverage) item_got_export;//
    `uvm_component_utils(f_coverage);
  
  //f_sequence_item cg;
  //virtual f_interface vif;
    
  bit wr_en;
  bit rd_en;
  bit [31:0] data_in;
  bit fifo_full;
  bit fifo_empty;
  bit [31:0] data_out;
  
//   covergroup cg;
//     coverpoint wr_en;
//     coverpoint rd_en;
//     coverpoint data_in;
//     coverpoint fifo_full;
//     coverpoint fifo_empty;
//     coverpoint data_out;
//     //$display("************inside coverage************");
//   endgroup
  
  covergroup cg;
  coverpoint wr_en {
    bins high = {1};
    bins low = {0};
  }
  coverpoint rd_en {
    bins high = {1};
    bins low = {0};
  }
//   //coverpoint data_in {
//     //bins [0:31] = {0};
//   //}
//   coverpoint fifo_full {
//     bins high = {1};
//     bins low = {0};
//   }
//   coverpoint fifo_empty {
//     bins high = {1};
//     bins low = {0};
//   }
//   //coverpoint data_out {
//     //bins [0:31] = {0};
//   //}
//   // Define additional coverpoints as needed
  
//   // Example cross coverage
//   // cross wr_rd_cross = cross(wr_en, rd_en);
endgroup

  
  function new(string name = "f_coverage", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
    //$display("************inside coverage************");
    cg = new();
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //$display("************inside coverage************");
  endfunction
  
  function void write(f_sequence_item t);
    /*cg.wr_en = item_got.m_mp.m_cb.wr_en;
    cg.rd_en = item_got.m_cb.rd_en;
    cg.data_in = item_got.m_mp.m_cb.data_in;
    cg.fifo_full =  item_got.m_mp.m_cb.fifo_full;
    cg.fifo_empty = item_got.m_mp.m_cb.fifo_empty;
    cg.data_out = item_got.m_mp.m_cb.data_out;*/
    
//     wr_en = item_got.wr_en;
//     rd_en = item_got.rd_en;
//     data_in = item_got.data_in;
//     fifo_full =  item_got.fifo_full;
//     fifo_empty = item_got.fifo_empty;
//     data_out = item_got.data_out;
    
        wr_en = t.wr_en;
     rd_en = t.rd_en;
//     data_in = t.data_in;
//     fifo_full =  t.fifo_full;
//     fifo_empty = t.fifo_empty;
//     data_out = t.data_out;
    //$display("\nwrite enable value is %b", wr_en);
    //$display("\n*******inside coverage task********");
    cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    $display("\nFIFO COVERAGE: %2.0f%%", cg.get_coverage());
    // Additional coverage reporting if needed
  endfunction
endclass
