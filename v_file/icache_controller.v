`timescale 1ns/100ps
module icache_controller(// inputs
			clock,
			reset,
                        ////proc
                        proc2ctr_rd_addr,
                        ////cache
			cache2ctr_rd_data,
			cache2ctr_rd_valid,
                        ////mem
			mem2ctr_tag,
			mem2ctr_response,
                        mem2ctr_wr_data,

			// outputs
                        ////proc
			ctr2proc_rd_data,
			ctr2proc_rd_valid,
                        ////cache
                        ctr2cache_wr_addr,
                        ctr2cache_wr_data,
			ctr2cache_wr_enable,
                        ctr2cache_rd_addr,
                        ////mem
			ctr2mem_req_addr,
			ctr2mem_command
			);

input clock;
input reset;
//in proc
input [63:0] proc2ctr_rd_addr;
//in cache
input [63:0] cache2ctr_rd_data;
input        cache2ctr_rd_valid;
//in mem
input  [3:0] mem2ctr_tag;
input  [3:0] mem2ctr_response;
input [63:0] mem2ctr_wr_data;

//out proc
output [63:0] ctr2proc_rd_data;
output        ctr2proc_rd_valid;
//out cache
output [63:0] ctr2cache_wr_addr;
output [63:0] ctr2cache_wr_data;
output        ctr2cache_wr_enable;
output [63:0] ctr2cache_rd_addr;
//out mem
output [63:0] ctr2mem_req_addr;
output [1:0]  ctr2mem_command;

reg    [63:0] next_last_miss_addr;
reg    [63:0] last_miss_addr;
reg    [63:0] next_requesting_addr;
reg    [63:0] requesting_addr;
reg    [63:0] MSHR_addr[15:0];
reg    [15:0] MSHR_valid;
reg    [15:0] next_MSHR_valid;
wire          addr_change_caused_miss;

assign ctr2proc_rd_data = cache2ctr_rd_data;
assign ctr2proc_rd_valid = cache2ctr_rd_valid;// & (!(halt_pc_known & requesting_inst_exceed_bound));
assign ctr2cache_wr_addr = MSHR_addr[mem2ctr_tag];
assign ctr2cache_wr_data = mem2ctr_wr_data;
assign ctr2cache_wr_enable = (MSHR_valid[mem2ctr_tag] == `TRUE) ?`TRUE:`FALSE;
assign ctr2cache_rd_addr = proc2ctr_rd_addr;
assign ctr2mem_req_addr = next_requesting_addr;
assign addr_change_caused_miss = !cache2ctr_rd_valid & (last_miss_addr != proc2ctr_rd_addr);

//CTR2MEM COMMAND
assign ctr2mem_command = `BUS_LOAD;


//last_miss_addr
reg [2:0] lm_counter;
reg [2:0] next_lm_counter;
always@* begin
  next_lm_counter = lm_counter - 3'd1;
  next_last_miss_addr = last_miss_addr;
  if(!cache2ctr_rd_valid & last_miss_addr != proc2ctr_rd_addr)
    next_last_miss_addr = proc2ctr_rd_addr;
end
always@(posedge clock) begin
  if(reset)begin
    last_miss_addr <= `SD proc2ctr_rd_addr;
    lm_counter <= `SD 3'd7;
  end
  else if(next_lm_counter != 0)begin
    lm_counter <= `SD next_lm_counter;
    last_miss_addr <= `SD next_last_miss_addr;
  end else begin
    lm_counter <= `SD next_lm_counter;
    last_miss_addr <= `SD proc2ctr_rd_addr - 64'd8;
  end
end
//last_miss_addr


//requesting_addr
always@* begin
  next_requesting_addr = requesting_addr + 64'd8;
  if(addr_change_caused_miss) next_requesting_addr = proc2ctr_rd_addr;
  else if( mem2ctr_response == 4'd0 ) next_requesting_addr = requesting_addr;
end
always@(posedge clock) begin
  if(reset) requesting_addr <= `SD 64'hFFFFFFFFFFFFFFFF;
  else requesting_addr <= `SD next_requesting_addr;
end
//requesting_addr

//MSHR
always@* begin
  next_MSHR_valid = MSHR_valid;
  if(mem2ctr_response != 4'd0)begin
    next_MSHR_valid[mem2ctr_response] = `TRUE;
  end
  if(MSHR_valid[mem2ctr_tag] == `TRUE) next_MSHR_valid[mem2ctr_tag] = `FALSE;
end
always@(posedge clock) begin
  if(reset)
    MSHR_valid <= `SD 16'd0;
  else begin
    MSHR_valid <= `SD next_MSHR_valid;
  end
end
always@(posedge clock) begin
  if(reset)begin
    MSHR_addr[0]  <= `SD 64'd0;
    MSHR_addr[1]  <= `SD 64'd0;
    MSHR_addr[2]  <= `SD 64'd0;
    MSHR_addr[3]  <= `SD 64'd0;
    MSHR_addr[4]  <= `SD 64'd0;
    MSHR_addr[5]  <= `SD 64'd0;
    MSHR_addr[6]  <= `SD 64'd0;
    MSHR_addr[7]  <= `SD 64'd0;
    MSHR_addr[8]  <= `SD 64'd0;
    MSHR_addr[9]  <= `SD 64'd0;
    MSHR_addr[10] <= `SD 64'd0;
    MSHR_addr[11] <= `SD 64'd0;
    MSHR_addr[12] <= `SD 64'd0;
    MSHR_addr[13] <= `SD 64'd0;
    MSHR_addr[14] <= `SD 64'd0;
    MSHR_addr[15] <= `SD 64'd0;
  end
  else if(mem2ctr_response != 4'd0)begin
    MSHR_addr[mem2ctr_response] <= `SD next_requesting_addr;
  end
end
//MSHR

endmodule
