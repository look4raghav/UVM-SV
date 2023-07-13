class my_data extends uvm_sequence_item;
  rand bit[7:0] data;
  rand bit [7:0] addr;
endclass

class my_driver extends uvm_drover #(my_data);
  `uvm_component_utils(my_driver)
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info ("DRIVER", $sformatf("WAIt for data from seqr"), UVM_MEDIUM)
    seq_item_port.get(req);
    `uvm_info ("DRIVER", $sformatf("Start driving tx addr=0x%0h data=0x%0h", req.addr, req.data), UVM_MEDIUM)
    #20;
    `uvm_info ("DRIVER", $sformatf("#20 delay end, curr data=0x%0h", req.data), UVM_MEDIUM)
    req.data=8'hAA;
    `uvm_info ("DRIVER", $sformatf("About to call put() with new data=0x%0h", req.data), UVM_MEDIUM)
    seq_item_port.get(req);
    `uvm_info ("DRIVER", $sformatf("Finish driving tx addr=0x%0h data=0x%0h", req.addr, req.data), UVM_MEDIUM)
  endtask
endclass



class my_sequence extends uvm_sequence #(my_data);
  virtual task body();
    my_data tx = my_data::type_id::create("tx");
    `uvm_info("SEQ", $sformatf("Abt to call start_item"), UVM_MEDIUM)
    start_item(tx);
    `uvm_info("SEQ", $sformatf("start_item() fn call done"), UVM_MEDIUM)
    tx.randomize();
    `uvm_info ("SEQ", $sformatf("tx randomizes with addr=0x%0h data=0x%0h", tx.addr, tx.data), UVM_MEDIUM)
    finish_item(tx);
    `uvm_info("SEQ", $sformatf("finish_item() fn call done, wait for rsp"), UVM_MEDIUM)
    get_response(tx);
    `uvm_info("SEQ", $sformatf("get_response() fn call done rsp addr=0x%0h data=0x%0h, exit seq", tx.addr, tx.data), UVM_MEDIUM)
  endtask
endclass



class test extends uvm_test;
  my_driver drv;
  uvm_sequencer #(my_data) seqr;
  my_sequence seq;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = my_driver::type_id::create("drv", this);
    seqr = uvm_sequencer#(my_data)::type_id::create("seqr", this);
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    seq = my_sequence::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(seqr);
    phase.drop_objection(this);
  endtask
