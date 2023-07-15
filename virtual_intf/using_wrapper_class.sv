// Code your testbench here
// or browse Examples
interface intf();
  logic clk;
  logic [7:0] sa, da;
endinterface


class wrapper;
  virtual intf vif;
  
  function new (virtual intf vif);
    this.vif = vif;
  endfunction
endclass


class monitor;
  wrapper wr;
  
  function new (wrapper obj);
    wr = obj;
  endfunction
  
  task run();
    repeat(2) begin
      @(wr.vif.clk)
      $display($time, "sa = %0d", wr.vif.sa);
      $display($time, "da = %0d", wr.vif.da);
    end
  endtask
endclass


class driver;
  wrapper wr;
  
  function new (wrapper obj);
    wr = obj;
  endfunction
  
  task signals();
    @(wr.vif.clk);
    wr.vif.sa = 0;
    wr.vif.da = 0;
    wr.vif.sa = 2;
    wr.vif.da = 7;
    wr.vif.sa = 15;
    wr.vif.da = 20;
  endtask
endclass


module top;
  intf vif();
  wrapper wr;
  driver drv;
  monitor mon;
  
  always
    #3 vif.clk = ~vif.clk;
  initial begin
    vif.clk = 0;
    wr = new(vif);
    drv = new(wr);
    mon = new(wr);
    
    drv.signals();
    mon.run();
    $finish;
  end
endmodule
