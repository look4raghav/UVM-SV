program automatic simple_test;
  import uvm_pkg::*;
  class testcase_1 extends uvm_test;
    `uvm_component_utils(testcase_1)
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction
    virtual task run();
      `uvm_info("Normal","Testcase_1!",UVM_MEDIUM);
    endtask
  endclass
  class testcase_2 extends uvm_test;
    `uvm_component_utils(testcase_2)
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction
    virtual task run();
      `uvm_info("Normal","Testcase_2!",UVM_MEDIUM);
    endtask
  endclass
  class testcase_3 extends uvm_test;
    `uvm_component_utils(testcase_3)
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction
    virtual task run();
      `uvm_info("Normal","Testcase_3!",UVM_MEDIUM);
    endtask
  endclass
  initial 
    run_test();
endprogram
