class data_pkt extends uvm_sequence_item;
  `uvm_object_utils(data_pkt);
  rand bit[7:0] dest_addr;
  rand bit[7:0] src_addr;
  rand bit[7:0] payload[];

  bit valid;
  bit[7:0] checksum;
  bit[7:0] parity;
  bit retry;
  bit ready;

  constraint c_dest_addr {dest_addr[0] == 1;}
  constraint c_src_addr {src_addr >= 8'h80;}
  constraint c_size {payload_data.size inside {[64:100]};}

  extern function new(string name = "data_pkt");
    extern function void post_randomize();
      extern function void do_print(uvm_printer printer);
        extern function void do_copy(uvm_object rhs);

          endclass : data_pkt

          function data_pkt::new(string name = "data_pkt");
            super.new(name);
          endfunction

          function void data_pkt::post_randomize();
          endfunction

          function void data_pkt::do_print (uvm_printer printer);
          endfunction

          function void data_pkt::do_copy(uvm_object rhs);
          endfunction
