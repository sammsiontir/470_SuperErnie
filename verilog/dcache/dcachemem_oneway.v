// cachemem128x64

`timescale 1ns/100ps

`define SD #1

module cache(// inputs
                       clock,
                       reset, 
                       wr_en,
                       wr_data,
                       wr_pc_reg,

                       rd_pc_reg,
                       // outputs
                       rd_data,
                       rd_valid
             );

input clock, reset;
input        wr_en;
input [63:0] wr_data;
input [63:0] wr_pc_reg;
input [63:0] rd_pc_reg;

output wire [63:0] rd_data;
wire        [63:0] rd_data_cache;
//reg         [63:0] rd_data_victim;
output wire rd_valid;
wire        rd_valid_cache;
//reg         rd_valid_victim;


wire [53:0]  wr_pc_tag;
wire [6:0]   wr_pc_idx;
wire [53:0]  rd_pc_tag;
wire [6:0]   rd_pc_idx;

reg  [53:0] tags_1[127:0];
reg  [127:0] valid_1;
reg  [63:0] lines_1[127:0];

assign rd_data   = rd_data_cache;//rd_valid_cache  ? rd_data_cache :
//                   rd_valid_victim ? rd_data_victim: 0;
assign rd_valid  = rd_valid_cache;// | rd_valid_victim;
assign wr_pc_tag = wr_pc_reg[63:10];
assign wr_pc_idx = wr_pc_reg[9:3];
assign rd_pc_tag = rd_pc_reg[63:10];
assign rd_pc_idx = rd_pc_reg[9:3];

reg data_in_1;
always@(*) begin
  data_in_1 = `FALSE;
  if(valid_1[rd_pc_idx]) begin
    if(tags_1[rd_pc_idx] == rd_pc_tag) data_in_1 = `TRUE;
  end
end

assign rd_valid_cache = data_in_1;
assign rd_data_cache  = data_in_1 ? lines_1[rd_pc_idx]:
                        64'd0;

always@(posedge clock) begin
  if(reset) begin
    valid_1 <= `SD 128'd0;
  end else if(wr_en)begin
      lines_1[wr_pc_idx] <= `SD wr_data;
      valid_1[wr_pc_idx] <= `SD 1'd1;
      tags_1[wr_pc_idx] <= `SD wr_pc_tag;
  end
end
endmodule
