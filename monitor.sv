class my_monitor extends uvm_monitor;
  `uvm_component_utils(my_monitor)

  virtual dut_if vif;
  bit enable_check = 1;

  uvm_analysis_port #(my_data) mon_analysis_port;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);

    mon_analysis_port = new ("mon_analysis_port", this);
    if(!uvm_config_db #(virtual dut_if) :: get(this, "", vif)) begin
      `uvm_error (get_type_name(), "DUT intf not found")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    my_data data_obj = my_data :: type_id :: create("data_obj", this);
    forever
      begin
        @([Some event when data at DUT port is valid]);
        data_obj.data = vif.data;
        data_obj.addr = vif.addr;

        if(enable_check)
          check_protocol();

        if(enable_coverage)
          data_obj.cg)trans.simple();

        mon_analysis_port.write (data_obj);
      end
  endtask

  virtual function void check_protocol();
    
  endfunction
endclass
