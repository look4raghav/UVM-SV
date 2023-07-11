class my_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (my_scoreboard)

  function new(string name="my_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(apb_pkt, my_scoreboard) ap_imp;

  function void built_phase (uvm_phase phase);
    ap_imp = new("ap_imp", this);
  endfunction

  virtual function void write(apb_pkt data);
    `uvm_info("write", $sformatf("DATA RECIEVED = 0x%0h", data), UVM_MEDIUM)
  endfunction

  virtual task run_phase(uvm_phase phase);

  endtask

  virtual function void check_phase (uvm_phase phase);

  endfunction
endclass








class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  function new(string name="my_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  my_scoreboard m_scdb;

  virtual function void built_phase (uvm_phase phase)
    super.build_phase(phase);
    m_scdb = my_scoreboard::type_id::create("m_scdb", this);
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    m_apb_agent.m_apb_mon.analysis_port.connect (m_scdb.ap_imp);
  endfunction
endclass
