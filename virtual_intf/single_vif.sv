// Code your testbench here
// or browse Examples
interface intf1;
  logic clk;
  logic [7:0] sa, da;
endinterface

class testbench1;
  virtual intf1 vif;
  
  function new (virtual intf1 vif);
  this.vif = vif;
endfunction
      
task run();
  repeat(3) begin
        @(vif.clk)
      $display($time, "sa = %0d", vif.sa);
      $display($time, "sa = %0d", vif.da);
    end
endtask
endclass

module testbench(intf1 vif);
  testbench1 inf;
  initial begin
    vif.clk=0;
    forever
       #3   vif.clk = ~vif.clk;
  end
    initial begin
      vif.sa = 0;
      vif.da = 0;
      #5
      vif.sa = 2;
      vif.da = 3;
    end
  initial begin
    inf = new(vif);
    inf.run();
  end
endmodule

module top;
  intf1 vif();
  testbench ab(vif);
endmodule
