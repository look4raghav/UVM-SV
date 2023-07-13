//---------ASYNCHRONOUS READ WRITE RAM--------------------------



// Code your design here
// Code your design here
module ram_dp_ar_aw(
  address_0, 
  data_0,
  cs_0,
  we_0,
  oe_0,
  address_1,
  data_1,
  cs_1,
  we_1,
  oe_1
);
  
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
  
  input [ADDR_WIDTH-1:0] address_0;
  input cs_0;
  input we_0;
  input oe_0;
  input [ADDR_WIDTH-1:0] address_1;
  input cs_1;
  input we_1;
  input oe_1;
  
  inout [DATA_WIDTH-1:0] data_0;
  inout [DATA_WIDTH-1:0] data_1;
  
  reg [DATA_WIDTH-1:0] data_0_out;
  reg [DATA_WIDTH-1:0] data_1_out;
  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
  
  always@(address_0 or cs_0 or we_0 or data_0 or address_0 or cs_1 or we_1 or data_1)
    begin : MEM_WRITE
      if(cs_0 && we_0)
        begin
          mem[address_0] <= data_0;
        end
      else if(cs_1 && we_1)
        begin
          mem[address_1] <= data_1;
        end
    end

  assign data_0 = (cs_0 && oe_0 && !we_0) ? data_0_out : 8'bz;

  always @ (address_0 or cs_0 or we_1 or oe_0)
    begin : MEM_READ_0
      if(cs_0 && !we_0 && oe_0)
        begin
          data_0_out <= mem[address_0];
        end
      else begin
        data_0_out <= 0;
      end
    end

  assign data_1 = (cs_1 && oe_1 && !we_1) ? data_1_out : 8'bz;

  always@(address_1 or cs_1 or we_1 or oe_1)
    begin : MEM_READ_1
      if(cs_1 && !we_1 && oe_1)
        begin
          data_1_out <= mem[address_1];
        end
      else begin
        data_1_out <= 0;
      end
    end
endmodule
      
      
