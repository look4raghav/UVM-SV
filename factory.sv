//-----------sequence item class-----------------------------

class switch_item extends uvm_sequence_item;
  randc bit [7:0]  	addr, w_data;
  randc bit [15:0] 	dataA, dataB;
  `uvm_object_utils_begin(switch_item)
  	`uvm_field_int (addr, UVM_DEFAULT)
  	`uvm_field_int (w_data, UVM_DEFAULT)
  	`uvm_field_int (dataA, UVM_DEFAULT)
  	`uvm_field_int (dataB, UVM_DEFAULT)
  `uvm_object_utils_end
  function new(string name = "switch_item");
    super.new(name);
  endfunction
endclass    


//-----------sequencer---------------------------------


class switch_item_sequencer extends uvm_sequencer #(switch_item);
  `uvm_sequencer_utils(switch_item_sequencer)
  function new(string name="name", uvm_component parent=null);
		super.new(name,parent);
	endfunction
endclass    


//-----------driver class-----------------------------


class driver extends uvm_driver #(switch_item);              
  `uvm_component_utils(driver)
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  virtual task run();
    `uvm_info("TRACE", "Driver sequence test", UVM_MEDIUM)
    forever 
      begin
        seq_item_port.get_next_item(req);
        req.print();
        seq_item_port.item_done();
      end
  endtask
endclass    

//---------------new driver----------------------

class new_driver extends driver;
  `uvm_component_utils(new_driver)
  
  function new (string name = "new_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual task run();
    `uvm_info("TRACE", "New DRIVER", UVM_MEDIUM)
    `uvm_info("TRACE", "Driver sequence test", UVM_MEDIUM)
    forever 
      begin
        seq_item_port.get_next_item(req);
        req.print();
        seq_item_port.item_done();
      end
  endtask
endclass   

//-----------Env class-----------------------------


class s_env extends uvm_env;
   `uvm_component_utils(s_env)
   switch_item si;
   switch_item_sequencer sis;
   driver drv;
   
   function new(string name="env", uvm_component parent=null);
     super.new(name, parent);
   endfunction
   virtual function void build();
     super.build();
     sis = switch_item_sequencer::type_id::create("sis",this);
     drv = driver::type_id::create("drv",this);
     endfunction

   virtual function void connect();
     drv.seq_item_port.connect(sis.seq_item_export);
   endfunction
 endclass
    

//-----------Test class-----------------------------


class test extends uvm_test;
  s_env env;
  switch_item si;
  `uvm_component_utils(test)
  
  function new(string name = "test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build();
    uvm_factory factory = uvm_factory::get();
    super.build();
    env = s_env::type_id::create("env",this);
    set_type_override("driver", "new_driver");
    set_config_string("*.sis","default_sequence","switch_item_sequence");
    factory.print();
  endfunction
  
  virtual task run();
    `uvm_info("id","working",UVM_MEDIUM)
    `uvm_info("id", "factory print", UVM_MEDIUM)
  endtask
endclass

//-------------------------------------------------------
/*
class test2 extends uvm_test;
  s_env env;
  switch_item si;
  `uvm_component_utils(test2)
  
  function new(string name = "test2", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build();
    super.build();
    set_type_override("driver", "new_driver");
  endfunction
  
  virtual task run();
    `uvm_info("id", "new or old identify me", UVM_MEDIUM)
  endtask
endclass

//--------------------------------

class test3 extends uvm_test;
  s_env env;
  switch_item si;
  `uvm_component_utils(test3)
  
  function new(string name = "test3", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    uvm_factory factory = uvm_factory::get();
    super.build_phase(phase);
    set_type_override("driver", "new_driver");
    factory.print();
  endfunction
  
  virtual task run();
    `uvm_info("id", "factory print", UVM_MEDIUM)
  endtask
endclass
*/
//-----------Sequence class-----------------------------


class switch_item_sequence extends uvm_sequence#(switch_item);
  switch_item req;
  `uvm_sequence_utils(switch_item_sequence,switch_item_sequencer)
  function new(string name = "switch_item_sequence");
    super.new(name);
  endfunction
  virtual task body();
    repeat(2) begin
      `uvm_do(req);
    end
  endtask
endclass

 module rs;
  initial 
    begin
      run_test("test");
    end
 endmodule
