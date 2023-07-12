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

class componentA extends uvm_component;
  `uvm_component_utils(componentA)

  uvm_blocking_put_port #(Packet) m_put_port;
  int m_num_tx = 2;

  function new(string name = "componentA", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    m_put_port = new("m_put_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (m_num_tx)
      begin
        Packet pkt = Packet::type_id::create("pkt");
        assert(pkt.randomize());
        #50;
        `uvm_info("COMPA", "Packet send to compB", UVM_LOW)
        pkt.print(uvm_default_line_printer);
        m_put_port.put (pkt);
      end
    phase.drop_objectiion(this);
  endtask
endclass



class componentB extends uvm_component;
  `uvm_component_utils(componentB)

  uvm_blocking_get_port #(Packet) m_get_port;
  int m_num_tx = 2;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    m_get_port = new("m_get_port", this);
  endfunction

  virtual task run_phase (uvm_phase phase);
    Packet pkt;
    phase.raise_objection(this);
    repeat(m_num_tx)
      begin
        #100;
        m_get_port.get(pkt);
        `uvm_info("COMPB", "COMPA JUST GAVE ME PACKET", UVM_LOW)
        pkt.print(uvm_default_line_printer);
      end
    phase.drop_objection(this);
  endtask
endclass
