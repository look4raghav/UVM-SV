// Code your testbench here
// or browse Examples
interface intf();
  logic clk;
  logic [7:0] sa, da;
endinterface


class wrapper;
  virtual intf vif;
  
endclass


class monitor;
  virtual intf vif;
  
  function new (virtual intf vif);
    this.vif = vif;
  endfunction
  
  task run();
    repeat(2) begin
      @(vif.clk)
      $display($time, "sa = %0d", vif.sa);
      $display($time, "da = %0d", vif.da);
    end
  endtask
endclass


class driver;
  virtual intf vif;
  
  function new (virtual intf vif);
    this.vif = vif;
  endfunction
  
  task signals();
    @(vif.clk);
    vif.sa = 0;
    vif.da = 0;
    vif.sa = 2;
    vif.da = 7;
    vif.sa = 15;
    vif.da = 20;
  endtask
endclass


module top;
  intf vif();
  driver drv = new(vif);
  monitor mon = new(vif);
  
  always
    #3 vif.clk = ~vif.clk;
  initial begin
    vif.clk = 0;
    
    drv.signals();
    mon.run();
    $finish;
  end
endmodule
