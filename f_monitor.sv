class f_monitor extends uvm_monitor;
  virtual f_interface vif;
  f_sequence_item item_got;
  uvm_analysis_port#(f_sequence_item) item_got_port;
  `uvm_component_utils(f_monitor)
  
  function new(string name = "f_monitor", uvm_component parent);
    super.new(name, parent);
    item_got_port = new("item_got_port", this);
  endfunction
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_got = f_sequence_item::type_id::create("item_got");
    if(!uvm_config_db#(virtual f_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
  endfunction
      
  virtual task run_phase(uvm_phase phase);
    //forever begin
      fork
      	forever begin 
          @(posedge vif.mw_mp.wr_clk)
          `uvm_info(get_name(),$sformatf("posedge of wr_en %d",vif.mw_mp.mw_cb.wr_en),UVM_LOW) ;
          if(vif.mw_mp.mw_cb.wr_en == 1)begin
        	$display("\nWR is high");
        	item_got.data_in = vif.mw_mp.mw_cb.data_in;
        	item_got.wr_en = 'b1;
        	item_got.rd_en = 'b0;
        	item_got.fifo_full = vif.mw_mp.mw_cb.fifo_full;
        	item_got_port.write(item_got);
      	  end
        end 
        
        forever begin
          @(posedge vif.mr_mp.rd_clk)
          `uvm_info(get_name(),$sformatf("posedge of rd_en %d",vif.mr_mp.mr_cb.rd_en),UVM_LOW) ;
          if(vif.mr_mp.mr_cb.rd_en == 1)begin
        	$display("\nRD is high");
        	item_got.data_out = vif.mr_mp.mr_cb.data_out;
        	item_got.rd_en = 'b1;
        	item_got.wr_en = 'b0;
        	item_got.fifo_empty = vif.mr_mp.mr_cb.fifo_empty;
        	item_got_port.write(item_got);
      	  end
        end 
      join
     //end
  endtask
endclass

    