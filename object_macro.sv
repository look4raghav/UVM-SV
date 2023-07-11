class asd extends uvm_object;
  `uvm_object_utils(asd)

  function new(string name = "asd");
    super.new(name);
  endfunction
endclass

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  function new(string name = "best_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    asd ASD = asd::type_id::create("ASD_inst");
  endfunction
endclass
