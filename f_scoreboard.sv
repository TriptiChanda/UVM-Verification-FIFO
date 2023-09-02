class f_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(f_sequence_item, f_scoreboard) item_got_export;
  `uvm_component_utils(f_scoreboard)
  
  function new(string name = "f_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  int queue[$];
  
  function void write(input f_sequence_item item_got);
    bit [31:0] examdata;
    if(item_got.wr_en == 'b1)begin
      queue.push_back(item_got.data_in);
      `uvm_info("Read Data", $sformatf("Q size = %0d last data written = %0h",queue.size(),item_got.data_in), UVM_LOW);
      `uvm_info("Write Data", $sformatf("wr_en: %0b rd_en: %0b data_in: %0h full: %0b",item_got.wr_en, item_got.rd_en,item_got.data_in, item_got.fifo_full), UVM_LOW);   
    end      
    if (item_got.rd_en == 'b1)begin
      
      if(queue.size() == 'd0)begin 
        `uvm_info("Read Data", $sformatf("Read enabled when the fifo is empty"), UVM_LOW);
      end
      else begin
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b queue_size() = %d", examdata, item_got.data_out, item_got.fifo_empty,queue.size()), UVM_LOW);
        if(examdata == item_got.data_out)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
    end
  endfunction
endclass
        