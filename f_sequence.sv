class f_sequence extends uvm_sequence#(f_sequence_item);
  `uvm_object_utils(f_sequence)
  int fifo_full_chk;
  int fifo_empty_chk;
  function new(string name = "f_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("******** Checking for fifo_empty state ********"), UVM_LOW);
    #20;
    uvm_hdl_read("tb.dut.fifo_empty",fifo_empty_chk);
    if(fifo_empty_chk) `uvm_info(get_name(),"fif_empty value = 1",UVM_LOW)
    else               `uvm_error(get_name(),"fifo_empty not equal to 1")
     
      `uvm_info(get_type_name(), $sformatf("******** Generate 8 Write REQs ********"), UVM_LOW);
    repeat(8) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {wr_en == 1;});
      `uvm_info(get_type_name(), $sformatf("******** Generated req hold wr_en = %d and rd_en =%d ********",req.wr_en,req.rd_en), UVM_LOW);
      finish_item(req);
    end
    
    fork
      begin
        forever begin
          uvm_hdl_read("tb.dut.fifo_full",fifo_full_chk);
          #2;
          if(fifo_full_chk) begin 
            `uvm_info(get_name(),"fifo_full gets asserted",UVM_LOW);
            break;
          end 
        end 
      end 
      begin
        #100;
        `uvm_error(get_name(),"Fifo_full not equal to 1")
      end 
    join_any
    disable fork;
      `uvm_info(get_type_name(), $sformatf("******** Generate 8 Read REQs ********"), UVM_LOW);
      repeat(8) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {rd_en == 1;});
      finish_item(req);
    end
  
     fork
      begin
        forever begin
          uvm_hdl_read("tb.dut.fifo_empty",fifo_empty_chk);
          #2;
          if(fifo_empty_chk) begin 
            `uvm_info(get_name(),"fifo_empty gets asserted",UVM_LOW);
            break;
          end 
        end 
      end 
      begin
        #100;
        `uvm_error(get_name(),"Fifo_empty not equal to 1")
      end 
    join_any
    disable fork;     
      #10;
 
      
      `uvm_info(get_type_name(), $sformatf("******** Generate 20 Random REQs ********"), UVM_LOW);
      repeat(20) begin
      //#10;
      uvm_hdl_read("tb.dut.fifo_empty",fifo_empty_chk);
      uvm_hdl_read("tb.dut.fifo_full",fifo_full_chk);
      req = f_sequence_item::type_id::create("req");
      start_item(req);
        if ((fifo_empty_chk) || (fifo_full_chk)) 
          assert(req.randomize() with {rd_en == fifo_full_chk; wr_en == fifo_empty_chk;});
      else 
       	assert(req.randomize());
      `uvm_info(get_type_name(), $sformatf("******** Generated req hold wr_en = %d and rd_en =%d ********",req.wr_en,req.rd_en), UVM_LOW);
      	finish_item(req);
      end
      
      #20;
      `uvm_info(get_type_name(), $sformatf("******** Generate 2 Write REQs ********"), UVM_LOW);
      repeat(2) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {wr_en == 1;});
      `uvm_info(get_type_name(), $sformatf("******** Generated req hold wr_en = %d and rd_en =%d ********",req.wr_en,req.rd_en), UVM_LOW);
      finish_item(req);
      end
      #10;
      
      `uvm_info(get_type_name(), $sformatf("******** Generate 10 Random REQs allowing concurrent requests ********"), UVM_LOW)
      repeat(10) begin
        req = f_sequence_item::type_id::create("req");
         start_item(req);
        req.wr_rd2.constraint_mode(0);
        assert(req.randomize()with {rd_en == 1; wr_en == 1;});
        `uvm_info(get_type_name(), $sformatf("******** Generated req hold wr_en = %d and rd_en =%d ********",req.wr_en,req.rd_en), UVM_LOW)
        finish_item(req);       
      end 
  endtask
  
endclass
  
class f_sequence_1 extends uvm_sequence#(f_sequence_item);
  `uvm_object_utils(f_sequence_1)
  int fifo_full_chk;
  int fifo_empty_chk;
  function new(string name = "f_sequence_1");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("******** Runnig from seq_1 Checking for fifo_empty state ********"), UVM_LOW)
    #10;
    uvm_hdl_read("tb.dut.fifo_empty",fifo_empty_chk);
    if(fifo_empty_chk) `uvm_info(get_name(),"fif_empty value = 1",UVM_LOW)
    else               `uvm_error(get_name(),"fifo_empty not equal to 1")
      
    `uvm_info(get_type_name(), $sformatf("******** Generate 8 Random REQs ********"), UVM_LOW)
     repeat(8) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      `uvm_info(get_type_name(), $sformatf("******** Generated req hold wr_en = %d and rd_en =%d ********",req.wr_en,req.rd_en), UVM_LOW)
      finish_item(req);
    end
//     `uvm_info(get_type_name(), $sformatf("******** Check empty status ********"), UVM_LOW)
//     repeat(4) begin
//       req = f_sequence_item::type_id::create("req");
//       start_item(req);
//       assert(req.randomize() with {rd_en == 1; wr_en == 0;});
//       finish_item(req);
//     end
  endtask
  
endclass
  
