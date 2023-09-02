class f_sequence_item extends uvm_sequence_item;
  rand bit wr_en;
  rand bit rd_en;
  rand bit [31:0] data_in;
  bit fifo_full;
  bit fifo_empty;
  bit fifo_almost_full;
  bit fifo_almost_empty;
  bit [31:0] data_out;
  
  `uvm_object_utils_begin(f_sequence_item)
  `uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_field_int(data_in, UVM_ALL_ON)
  `uvm_object_utils_end
  constraint wr_rd2 {(wr_en & rd_en) != 1;}
  
  function new(string name = "f_sequence_item");
    super.new(name);
  endfunction

endclass
