class f_driver extends uvm_driver#(f_sequence_item);
  virtual f_interface vif;
  f_sequence_item req;
  bit [1:0] en_rd_wr ;
  `uvm_component_utils(f_driver)
  
  function new(string name = "f_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual f_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "No vif is found!")
  endfunction

  virtual task run_phase(uvm_phase phase);
//     vif.d_mp.d_cb.wr_en <= 'b0;
//     vif.d_mp.d_cb.rd_en <= 'b0;
//     vif.d_mp.d_cb.data_in <= 'b0;
    forever begin
      seq_item_port.get_next_item(req);
      en_rd_wr[0] = req.wr_en;
      en_rd_wr[1] = req.rd_en;
      case (en_rd_wr) 
        2'b00 : main_idle();
        2'b01 : main_write(req.data_in);
        2'b10 : main_read();
        2'b11 : main_rd_wr(req.data_in);
      endcase
      #10;
//         if (req.wr_en == 1)
//         main_write(req.data_in);
//       else if(req.rd_en == 1)
//         main_read();
      seq_item_port.item_done();
     end
  endtask
  
    virtual task main_write(input [31:0] din);
      @(posedge vif.dw_mp.wr_clk)
      $display("DEBUG :: ADI :: posedge detected");
      `uvm_info(get_name(),"DEBUG :: ADI :: posedge detected",UVM_LOW);
    vif.dw_mp.dw_cb.wr_en <= 'b1;
    vif.dw_mp.dw_cb.data_in <= din;
     #20;
      `uvm_info(get_name(),"DEBUG :: ADI :: next posedge detected",UVM_LOW);
     //@(posedge vif.d_mp.wr_clk)
    vif.dw_mp.dw_cb.wr_en <= 'b0;
  endtask
  
  virtual task main_read();
    `uvm_info(get_name(),"DEBUG :: ADI :: main_read called",UVM_LOW);
    @(posedge vif.dr_mp.rd_clk)
    vif.dr_mp.dr_cb.rd_en <= 'b1;
    #40;
    //@(posedge vif.d_mp.rd_clk)
    vif.dr_mp.dr_cb.rd_en <= 'b0;
  endtask
    
  virtual task main_rd_wr(input [31:0] din);
    `uvm_info(get_name(),"DEBUG :: ADI :: main_rd_wr called",UVM_LOW);
    fork 
      begin 
        main_write(din);
      end
      begin
        main_read();
      end
    join 
  endtask

   virtual task main_idle();
     `uvm_info(get_name(),"DEBUG :: ADI :: main_idle called",UVM_LOW);
     @(posedge vif.dr_mp.rd_clk)
    vif.dr_mp.dr_cb.rd_en <= 'b0;
     @(posedge vif.dw_mp.wr_clk)
    vif.dw_mp.dw_cb.wr_en <= 'b0;
  endtask
endclass
  
   