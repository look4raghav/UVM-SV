typedef enum {A, B, C, D} resp_type;

class driver_callback extends uvm_callback;
  `uvm_object_utils(driver_callback)
  
  function new(string name = "driver_callback");
    super.new(name);
  endfunction
  
  virtual task update_resp(ref resp_type resp);
  endtask
endclass

//----------------------------------------------------

class err_driver extends uvm_component;
  resp_type resp;
  
  `uvm_component_utils(err_driver)
  `uvm_register_cb(err_driver,driver_callback)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    repeat(2) begin
      std::randomize(resp) with { resp == A;};
      `uvm_do_callbacks(err_driver,driver_callback,update_resp(resp));
      `uvm_info("DRIVER",$sformatf("Generated response is %s",resp.name()),UVM_LOW);
    end
  endtask  
endclass

//-------------------------------------------------------

class err_env extends uvm_env;
  err_driver driver;
  
  `uvm_component_utils(err_env)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = err_driver::type_id::create("driver", this);
  endfunction
endclass

//=============================================


//=================================

class test extends uvm_test;
  err_env env;
  
  `uvm_component_utils(test)
  
  function new(string name = "test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = err_env::type_id::create("env", this);
  endfunction
endclass

//-------------------------------------------------

class err_error_callback extends driver_callback;
  
  `uvm_object_utils(err_error_callback)
  
  function new(string name = "err_error_callback");
    super.new(name);
  endfunction
  
  task update_resp(ref resp_type resp);
    resp = C;
  endtask
endclass

//----------------------------------------

class err_err_test extends test;
  err_error_callback err_callback;
  
  `uvm_component_utils(err_err_test)
  
  function new(string name = "err_err_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    err_callback = err_error_callback::type_id::create("err_callback", this);
    
    uvm_callbacks#(err_driver,driver_callback)::add(env.driver,err_callback);
  endfunction
endclass

//--------------------------------------------------------------------

program testbench_top;
  initial begin
    run_test();
  end 
endprogram
