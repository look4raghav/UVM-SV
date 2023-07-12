class Packet extends uvm_object;
  rand bit[7:0] addr;
  rand bit [7:0] data;
  
  `uvm_object_utils_begin (Packet)
    `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "Packet");
    super.new(name);
  endfunction
endclass



class subComp1 extends uvm_component;
  `uvm_component_utils(subComp1)

  uvm_blocking_put_port #(Packet) m_put_port;
  int m_num_tx;

  function new(string name = "subComp1", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_put_port = new("m_put_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    repeat (m_num_tx) begin
      Packet pkt = Packet::type_id::create("pkt");
      assert(pkt.randomize());
      #50;
      `uvm_info ("SUBCOMP1", "PACKET SENT TO COMP1:tlm_fifo", UVM_LOW)
      pkt.print(uvm_default_line_printer);
      m_put_port.put(pkt);
    end
  endtask
endclass



class subComp2 extends uvm_component;
  `uvm_component_utils(subComp2)

  uvm_blocking_get_port #(Packet) m_get_port;
  uvm_blocking_put_port #(Packet) m_put_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_get_port = new("m_get_port", this);
    m_put_port = new("m_put_port", this);
  endfunction

  virtual task run_phase (uvm_phase phase);
    Packet pkt;
    forever 
      begin
        #100;
        m_get_port.get(pkt);
        `uvm_info("SUBCOMP2", "RECIEVED FROM A:tlm_fifo, forward it", UVM_LOW)
        pkt.print(uvm_default_line_printer);
        m_put_port.put(pkt);
      end
  endtask
endclass



class componentA extends uvm_component;
  `uvm_component_utils(componentA)

  function new(string name = "componentA", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  subComp1 m_subcomp_1;
  subComp2 m_subcomp_2;

  uvm_tlm_fifo #(Packet) m_tlm_fifo;
  uvm_blocking_put_port #(Packet) m_put_port;
  int m_num_tx;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    m_subcomp_1 = subComp1::type_id::create("m_subComp_1", this);
    m_subComp_2 = subComp2::type_id::create("m_subComp_2", this);

    m_tlm_fifo = new("uvm_tlm_fifo", this, 2);
    m_put_port = new("m_put_port", this);
    m_subcomp_1.m_num_tx = m_num_tx;
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    m_subcomp_1.m_put_port.connect(m_tlm_fifo.put_export);
    m_subcomp_2.m_put_port.connect(m_tlm_fifo.put_export);
    m_subcomp_2.m_put_port.connect(this.m_put_port);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever
      begin
        #10 if(m_tlm_fifo.is_full())
          `uvm_info ("COMPA", "componentA:TLM_FIFO is full!", UVM_MEDIUM)
    end
  endtask  
endclass


          /*subCOmp3, ComponentB, TopEnv/Test pending */  
