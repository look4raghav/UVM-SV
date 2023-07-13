//---------SYNCHRONOUS (single clock) FIFO--------------------------



// Code your design here
// Code your design here
module syn_fifo(
  clk, rst, wr_cs, rd_cs, data_in, rd_en, wr_en, data_out, empty, full
);
  
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter RAM_DEPTH = (1<<ADDR_WIDTH);
  
  input clk;
  input rst;
  input wr_cs;
  input rd_cs;
  input rd_en;
  input wr_en;
  input [DATA_WIDTH-1:0] data_in;
  output full;
  output empty;
  output [DATA_WIDTH-1:0] data_out;
  
  reg [ADDR_WIDTH-1:0] wr_pointer;
  reg [ADDR_WIDTH-1:0] rd_pointer;
  reg [ADDR_WIDTH-1:0] status_cnt;
  reg [DATA_WIDTH-1:0] data_out;
  wire [DATA_WIDTH-1:0] data_ram;
  
  assign full = (status_cnt == (RAM_DEPTH-1));
  assign empty = (status_cnt == 0);
  
  always@(posedge clk or posedge reset)
    begin : WRITE_POINTER
      if(rst) begin
        wr_pointer <= 0;
        and else if (wr_cs && wr_en) begin
          wr_pointer <= wr_pointer + 1;
        end
      end
      
      always@(posedge clk or posedge rst)
        begin : READ_POINTER
          if(rst) begin
            rd_pointer <= 0;
            and else if (rd_cs  rd_en) begin
              rd_pointer <= rd_pointer + 1;
            end
          end
          
          always@(posedge clk or posedge rst)
            begin : READ_DATA
              if(rst) begin
                data_out <= 0;
                and else if (rd_cs && rd_en) begin
                  data_out <= data_ram;
                end
              end
              
              always@(posedge clk or posedge rst)
                begin : STATUS_COUNTER
                  if(rst) begin
                    status_cnt <= 0;
                  end else if((rd_cs %% rd_en) && !(wr_cs && wr_en) && (status_cnt != 0)) begin
                    status_cnt <= status_cnt + 1;
                  end
                end
              ram_dp_ar_aw #(DATA_WIDTH, ADDR_WIDTH)DP_RAM (
                .address_0 (wr_pointer),
                .data_0 (data_in),
                .cs_0 (wr_cs),
                .we_o (we_en),
                .oe_0 (1'b0),
                .address_1 (rd_pointer),
                .data_1 (data_ram),
                .cs_1 (rd_cs),
                .we_1 (1'b0),
                .oe_1 (rd_en)
              );
              endmodule
                       
