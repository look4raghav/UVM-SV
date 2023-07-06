// Code your testbench here
// or browse Examples
class packet extends uvm_sequence_item;
  rand bit[3:0] sa, da;
  rand bit[7:0] payload[$];
  constraint valid {payload.size inside {[2:100]};}
  `uvm_object_utils_begin(packet)
  `uvm_field_int(sa, UVM_ALL_ON)
  `uvm_field_int(da, UVM_ALL_ON)
  `uvm_field_queue_int(payload, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name = "packet");
    super.new(name);
  endfunction
endclass

module test;
  initial 
    begin
      packet obj1;
      obj1 = new();
      obj1.randomize();
      obj1.print();
  end
  initial 
    begin
      packet obj2;
      packet obj3;
      obj2=new();
      obj3=new();
      obj2.randomize();
      obj2.print();
    //copy method
      obj3.copy(obj2);
      obj3.print();
     //matching case 
      if(obj2.compare(obj3))
        `uvm_info("","obj2 is matching with obj3",UVM_LOW)
        else
          `uvm_error("","obj2 is not matching with obj3")
  end
  initial begin
    packet obj4;
    packet obj5;
    obj4=new();
    obj5=new();
    obj4.randomize();
    obj5.randomize();
    obj4.print();
    obj5.print();
    
    //compare method
    if(obj4.compare(obj5))
      `uvm_info("","obj4 is matching with obj5",UVM_LOW)
    else
      `uvm_error("","obj4 is not matching with obj5")
  end
endmodule
  
