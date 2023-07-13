class fifo_sb;
  mailbox fifo = new();
  integer size;

  function new();
    begin
      size = 0;
    end
  endfunction

  task addItem(bit [7:0] data);
    begin
      if(size == 7) begin
        $write("%dns : ERROR : Over Flow Detented, current occupancy %d\n", $time, size);
      end else begin
        fifo.put(data);
        size ++;
      end
    end
  endtask

  task compareItem (bit [7:0] data);
    begin
      bit [7:0] cdata = 0;
      if(size == 0) begin
        $write("%dns : ERROR : Under Flow detected\n", $time);
      end else begin
        fifo.get(cdata);
        if (data != cdata) begin
          $write("%dns : ERROR : Data Mismatch, Expected %x Got %x\n", %time, cdata, data);
        end
        size --;
      end
    end
  endtask
endclass
