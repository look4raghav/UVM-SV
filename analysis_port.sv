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



class abc extends uvm_component;
  `uvm_component_utils(abc)
  uvm_analysis_port#(switch_item)put_port;  
  function new(string name = "abc", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
virtual function void build();
  super.build;
  put_port = new("put_port",this);
endfunction

virtual task run();
  repeat(2) begin
    switch_item si = switch_item::type_id::create("si",this);
    si.randomize();
    put_port.write(si);
  end
endtask
endclass




class xyz extends uvm_component;
  switch_item si;
  `uvm_component_utils(xyz)
  uvm_analysis_imp #(switch_item,xyz)put_export;
  function new(string name = "xyz", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build();
  super.build();
  put_export = new ("put_export",this);
  endfunction
  
  virtual function void write(switch_item si);					//     `uvm_info(get_type_name(), $sformatf("Received value = %0h", tr.sa), UVM_NONE)
    $display("recieved value = %0d",si.addr);
    $display("recieved value = %0d",si.w_data);
    $display("recieved value = %0p",si.dataA);
    $display("recieved value = %0p",si.dataB);
  endfunction
    endclass
    


class s_env extends uvm_env;
  `uvm_component_utils(s_env)
   abc a;
   xyz x;
   
   function new(string name="env", uvm_component parent=null);
     super.new(name, parent);
   endfunction
   virtual function void build();
     super.build();
     a = abc::type_id::create("a",this);
     x = xyz::type_id::create("x",this);
     endfunction

   virtual function void connect();
     a.put_port.connect(x.put_export);
   endfunction
 endclass



class test extends uvm_test;
    s_env env;
    `uvm_component_utils(test) 
    
  function new(string name="test", uvm_component parent = null);
    super.new(name,parent);
    endfunction
    
    virtual function void build();
      super.build();
      env = s_env::type_id::create("env",this);
    endfunction
    
    virtual task run();
    endtask       
  endclass
    
module top;
  import uvm_pkg::*;
  initial 
    begin
      run_test("test");
      end
endmodule
