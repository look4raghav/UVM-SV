typedef enum {FALSE, TRUE} e_bool;
class object extends uvm_object;

  rand e_bool m_bool;
  rand bit[3:0] m_mode;
  rand byte m_data[4];
  rand shortint m_queue[$];
  string m_name;

  constraint c_queue {m_queue.size() == 3;}

  function new(string name = "object");
    super.new(name);
    m_name = name;
  endfunction

  `uvm_object_utils_begin(object)
    `uvm_field_enum(e_bool, m_bool, UVM_DEFAULT)
    `uvm_field_int (m_mode, UVM_DEFAULT)
    `uvm_field_sarray_int (m_data, UVM_DEFAULT)
    `uvm_field_queue_int (m_queue, UVM_DEFAULT)
    `uvm_field_string(m_name, UVM_DEFAULT)
  `uvm_object_utils_end
endclass



class base_test extends uvm_test;
  `uvm_component_utils(base.test)
  function new(string name= "base.test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    object obj = object::type_id::create("obj");
    obj.randomize();
    obj.print();
  endfunction
endclass

module tb;
  initial
    begin
      run_test("base_test");
    end
endmodule
