class my_sequence extends uvm_sequence;
  `uvm_object_utils(my_sequence)

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task pre_body();
  endtask

  task body()
    my_data pkt;
    `uvm_do(pkt);
  endtask

  task post_body();
  endtask
endclass
