/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                     Modulename :  LSQ.v                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`define NO_DATA        64'd0
`timescale 1ns/100ps

//`timescale 1ns/100ps

module simLSQ(// Inputs
	     clock,
	     reset,

             PreDe_load_port1_allocate_en,
             PreDe_load_port1_destination,
             PreDe_load_port1_NPC,
             PreDe_load_port2_allocate_en,
             PreDe_load_port2_destination,
             PreDe_load_port2_NPC,

             PreDe_store_port1_allocate_en,
             PreDe_store_port1_data,
             PreDe_store_port1_NPC,
             PreDe_store_port2_allocate_en,
             PreDe_store_port2_data,
             PreDe_store_port2_NPC,
            
             Ex_load_port1_address_en,
     	     Ex_load_port1_address,
             Ex_load_port1_address_insert_position,
             Ex_load_port2_address_en,
     	     Ex_load_port2_address,
             Ex_load_port2_address_insert_position,

             Ex_store_port1_address_en,
     	     Ex_store_port1_address,
             Ex_store_port1_address_insert_position,
             Ex_store_port2_address_en,
     	     Ex_store_port2_address,
             Ex_store_port2_address_insert_position,

             Rob_store_port1_retire_en,  
             Rob_store_port2_retire_en,  
             Rob_load_retire_en, 
            
             Dcash_load_valid,
             Dcash_load_valid_data,
             Dcash_store_valid,                   
           

             Dcash_response,
             Dcash_tag_data,
             Dcash_tag,

             br_marker_port1_en,
             br_marker_port1_num,
             br_marker_port2_en,
             br_marker_port2_num,
             recovery_en,
             recovery_br_marker_num,
                         
             stall,
	  // Outputs
             LSQ_PreDe_tail_position,
             LSQ_PreDe_tail_position_plus_one,
             
             LSQ_Rob_store_retire_en,
             LSQ_Rob_destination,
             LSQ_Rob_data,
             LSQ_Rob_NPC,
             LSQ_Rob_write_dest_n_data_en,

             LSQ_Dcash_load_address_en,
             LSQ_Dcash_load_address, 
             LSQ_Dcash_store_address_en,
             LSQ_Dcash_store_address,
             LSQ_Dcash_store_data,
             
             LSQ_str_hazard
           );

input	     clock;
input	     reset;

input        PreDe_load_port1_allocate_en;
input [5:0]  PreDe_load_port1_destination;
input [63:0] PreDe_load_port1_NPC;
input        PreDe_load_port2_allocate_en;
input [5:0]  PreDe_load_port2_destination;
input [63:0] PreDe_load_port2_NPC;

input        PreDe_store_port1_allocate_en;
input [63:0] PreDe_store_port1_data;
input [63:0] PreDe_store_port1_NPC;
input        PreDe_store_port2_allocate_en;
input [63:0] PreDe_store_port2_data;
input [63:0] PreDe_store_port2_NPC;

input        Ex_load_port1_address_en;
input [63:0] Ex_load_port1_address;
input [4:0]  Ex_load_port1_address_insert_position;
input        Ex_load_port2_address_en;
input [63:0] Ex_load_port2_address;
input [4:0]  Ex_load_port2_address_insert_position;

input        Ex_store_port1_address_en;
input [63:0] Ex_store_port1_address;
input [4:0]  Ex_store_port1_address_insert_position;
input        Ex_store_port2_address_en;
input [63:0] Ex_store_port2_address;
input [4:0]  Ex_store_port2_address_insert_position;

input        Rob_store_port1_retire_en;
input        Rob_store_port2_retire_en;   
input        Rob_load_retire_en; 

input        Dcash_load_valid;
input [63:0] Dcash_load_valid_data;
input        Dcash_store_valid;

input        br_marker_port1_en;
input [2:0]  br_marker_port1_num;
input        br_marker_port2_en;
input [2:0]  br_marker_port2_num;

input        recovery_en;
input [2:0]  recovery_br_marker_num;

input [3:0]  Dcash_response;
input [63:0] Dcash_tag_data;
input [3:0]  Dcash_tag;

input        stall;


output     [4:0] LSQ_PreDe_tail_position;
output     [4:0] LSQ_PreDe_tail_position_plus_one;

output reg LSQ_Rob_store_retire_en;
output reg [5:0] LSQ_Rob_destination;
output reg [63:0]LSQ_Rob_data;
output reg [63:0]LSQ_Rob_NPC;
output reg LSQ_Rob_write_dest_n_data_en;             

output reg LSQ_Dcash_load_address_en;
output reg [63:0]LSQ_Dcash_load_address;
output reg       LSQ_Dcash_store_address_en;
output reg [63:0]LSQ_Dcash_store_address;
output reg [63:0]LSQ_Dcash_store_data;
             
output reg LSQ_str_hazard;

reg       LSQ_ld_or_st_stack [0:15];
reg [3:0] LSQ_ready_bit_stack [0:15];
reg [3:0] LSQ_response_stack [0:15];
reg [63:0]LSQ_address_stack [0:15];
reg [5:0] LSQ_destination_stack [0:15];
reg [63:0]LSQ_data_stack [0:15];
reg [63:0]LSQ_NPC_stack[0:15];

reg       next_LSQ_ld_or_st_stack [0:15];
reg [3:0] next_LSQ_ready_bit_stack [0:15];
reg [3:0] next_LSQ_response_stack [0:15];
reg [63:0]next_LSQ_address_stack [0:15];
reg [5:0] next_LSQ_destination_stack [0:15];
reg [63:0]next_LSQ_data_stack [0:15];
reg [63:0]next_LSQ_NPC_stack[0:15];

reg [63:0] load_port_1_data;
reg [2:0]  load_port_1_ready_bit;
reg [63:0] load_port_2_data;
reg [2:0]  load_port_2_ready_bit;


reg [4:0]head_ptr;
reg [4:0]next_head_ptr;
reg [4:0]tail_ptr;
reg [4:0]next_tail_ptr;
wire [4:0]head_plus_one;
wire [4:0]tail_plus_one;
wire [4:0]tail_plus_two;
wire [4:0]tail_plus_three;
assign head_plus_one = head_ptr + 5'd1;
assign tail_plus_one = tail_ptr + 5'd1;
assign tail_plus_two = tail_ptr + 5'd2;
assign tail_plus_three = tail_ptr + 5'd3;

reg [3:0] LSQ_store_retire_accumulator;
reg [3:0] next_LSQ_store_retire_accumulator;
wire[3:0] LSQ_store_retire_accumulator_plus_one;
wire[3:0] LSQ_store_retire_accumulator_plus_two;
wire[3:0] LSQ_store_retire_accumulator_minus_one;
assign LSQ_store_retire_accumulator_plus_one = LSQ_store_retire_accumulator + 4'd1;
assign LSQ_store_retire_accumulator_plus_two = LSQ_store_retire_accumulator + 4'd2;
assign LSQ_store_retire_accumulator_minus_one = LSQ_store_retire_accumulator - 4'd1;

wire LSQ_retire_enable;
assign LSQ_retire_enable = (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7)? 1'd1:1'd0; 
assign LSQ_PreDe_tail_position = tail_ptr;

wire [4:0] LSQ_PreDe_tail_position_plus_one;
assign LSQ_PreDe_tail_position_plus_one = LSQ_PreDe_tail_position + 5'd1;

wire write_in_case_2;
assign write_in_case_2 = (PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en) 
                      || (PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en) 
                      || (PreDe_store_port1_allocate_en && PreDe_load_port2_allocate_en)
                      || (PreDe_load_port1_allocate_en && PreDe_store_port2_allocate_en);
wire write_in_1;
assign write_in_1 = (PreDe_store_port1_allocate_en || PreDe_store_port2_allocate_en || PreDe_load_port1_allocate_en || PreDe_load_port2_allocate_en) && ~write_in_case_2;


always @*
begin  
load_port_1_data = 64'd0;
load_port_1_ready_bit = 3'b1;
load_port_2_data = 64'd0;
load_port_2_ready_bit = 3'b1;
if(Ex_load_port1_address_en && ~Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin
//////case 1//////////////////////////////////////////////////////////
      if(head_ptr <= Ex_load_port1_address_insert_position && Ex_load_port1_address_insert_position <= tail_ptr)begin
        if(head_ptr <= 5'b00000 && Ex_load_port1_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin //check addresses only between  (head_ptr ~ Ex_store_port1_address_insert_position)
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00001 && Ex_load_port1_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00010 && Ex_load_port1_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00011 && Ex_load_port1_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00100 && Ex_load_port1_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00101 && Ex_load_port1_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00110 && Ex_load_port1_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00111 && Ex_load_port1_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01000 && Ex_load_port1_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end  
        end
        if(head_ptr <= 5'b01001 && Ex_load_port1_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01010 && Ex_load_port1_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01011 && Ex_load_port1_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01100 && Ex_load_port1_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01101 && Ex_load_port1_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01110 && Ex_load_port1_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01111 && Ex_load_port1_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

        if(head_ptr <= 5'b10000 && Ex_load_port1_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port1_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port1_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port1_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port1_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port1_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port1_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port1_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port1_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port1_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port1_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port1_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port1_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port1_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port1_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port1_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

//////case 2//////////////////////////////////////////////////////////
      end else if(tail_ptr < head_ptr && head_ptr < Ex_load_port1_address_insert_position)begin
        if(head_ptr <= 5'b10000 && Ex_load_port1_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port1_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port1_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port1_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port1_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port1_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port1_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port1_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port1_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end  
        end
        if(head_ptr <= 5'b11001 && Ex_load_port1_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port1_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port1_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port1_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port1_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port1_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port1_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

//////case 3//////////////////////////////////////////////////////////
      end else if(Ex_load_port1_address_insert_position < tail_ptr && tail_ptr < head_ptr)begin
        if(head_ptr <= 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end    
        end
        if(head_ptr <= 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end   
        end
        if(Ex_load_port1_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
      end
end

if(~Ex_load_port1_address_en && Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin

//////case 1//////////////////////////////////////////////////////////
      if(head_ptr <= Ex_load_port2_address_insert_position && Ex_load_port2_address_insert_position <= tail_ptr)begin
        if(head_ptr <= 5'b00000 && Ex_load_port2_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin //check addresses only between  (head_ptr ~ Ex_load_port2_address_insert_position)
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00001 && Ex_load_port2_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00010 && Ex_load_port2_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00011 && Ex_load_port2_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00100 && Ex_load_port2_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00101 && Ex_load_port2_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00110 && Ex_load_port2_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00111 && Ex_load_port2_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01000 && Ex_load_port2_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b01001 && Ex_load_port2_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01010 && Ex_load_port2_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01011 && Ex_load_port2_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01100 && Ex_load_port2_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01101 && Ex_load_port2_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01110 && Ex_load_port2_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01111 && Ex_load_port2_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

        if(head_ptr <= 5'b10000 && Ex_load_port2_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port2_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port2_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port2_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port2_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port2_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port2_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port2_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port2_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port2_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port2_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port2_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port2_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port2_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port2_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port2_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

//////case 2//////////////////////////////////////////////////////////
      end else if(tail_ptr < head_ptr && head_ptr < Ex_load_port2_address_insert_position)begin
        if(head_ptr <= 5'b10000 && Ex_load_port2_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port2_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port2_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port2_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port2_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port2_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port2_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port2_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port2_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port2_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port2_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port2_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port2_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port2_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port2_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port2_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

//////case 3//////////////////////////////////////////////////////////
      end else if(Ex_load_port2_address_insert_position < tail_ptr && tail_ptr < head_ptr)begin
        if(head_ptr <= 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end    
        end
        if(head_ptr <= 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(Ex_load_port2_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
      end

end

if((Ex_load_port1_address_en && Ex_load_port2_address_en) || (Ex_load_port1_address_en && Ex_store_port2_address_en))begin
//////case 1//////////////////////////////////////////////////////////
      if(head_ptr <= Ex_load_port1_address_insert_position && Ex_load_port1_address_insert_position <= tail_ptr)begin
        if(head_ptr <= 5'b00000 && Ex_load_port1_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin //check addresses only between  (head_ptr ~ Ex_store_port1_address_insert_position)
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00001 && Ex_load_port1_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00010 && Ex_load_port1_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00011 && Ex_load_port1_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00100 && Ex_load_port1_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00101 && Ex_load_port1_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00110 && Ex_load_port1_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00111 && Ex_load_port1_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01000 && Ex_load_port1_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end  
        end
        if(head_ptr <= 5'b01001 && Ex_load_port1_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01010 && Ex_load_port1_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01011 && Ex_load_port1_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01100 && Ex_load_port1_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01101 && Ex_load_port1_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01110 && Ex_load_port1_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01111 && Ex_load_port1_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

        if(head_ptr <= 5'b10000 && Ex_load_port1_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port1_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port1_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port1_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port1_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port1_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port1_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port1_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port1_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port1_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port1_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port1_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port1_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port1_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port1_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port1_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

//////case 2//////////////////////////////////////////////////////////
      end else if(tail_ptr < head_ptr && head_ptr < Ex_load_port1_address_insert_position)begin
        if(head_ptr <= 5'b10000 && Ex_load_port1_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port1_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port1_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port1_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port1_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port1_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port1_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port1_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port1_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end  
        end
        if(head_ptr <= 5'b11001 && Ex_load_port1_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port1_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port1_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port1_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port1_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port1_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port1_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end

//////case 3//////////////////////////////////////////////////////////
      end else if(Ex_load_port1_address_insert_position < tail_ptr && tail_ptr < head_ptr)begin
        if(head_ptr <= 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end    
        end
        if(head_ptr <= 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[0];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[1];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[2];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[3];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[4];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[5];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[6];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[7];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[8];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end   
        end
        if(Ex_load_port1_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[9];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[10];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[11];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[12];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[13];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[14];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port1_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port1_address)begin
            load_port_1_data = LSQ_data_stack[15];
            load_port_1_ready_bit = 3'd7;     
          end else begin
            load_port_1_data = 64'd0;
            load_port_1_ready_bit = 3'd1;  
          end
        end
      end
      if(head_ptr <= Ex_load_port2_address_insert_position && Ex_load_port2_address_insert_position <= tail_ptr)begin
        if(head_ptr <= 5'b00000 && Ex_load_port2_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin //check addresses only between  (head_ptr ~ Ex_load_port2_address_insert_position)
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00001 && Ex_load_port2_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00010 && Ex_load_port2_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00011 && Ex_load_port2_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00100 && Ex_load_port2_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00101 && Ex_load_port2_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00110 && Ex_load_port2_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b00111 && Ex_load_port2_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01000 && Ex_load_port2_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b01001 && Ex_load_port2_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01010 && Ex_load_port2_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01011 && Ex_load_port2_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01100 && Ex_load_port2_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01101 && Ex_load_port2_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01110 && Ex_load_port2_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b01111 && Ex_load_port2_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

        if(head_ptr <= 5'b10000 && Ex_load_port2_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port2_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port2_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port2_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port2_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port2_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port2_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port2_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port2_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port2_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port2_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port2_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port2_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port2_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port2_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port2_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

//////case 2//////////////////////////////////////////////////////////
      end else if(tail_ptr < head_ptr && head_ptr < Ex_load_port2_address_insert_position)begin
        if(head_ptr <= 5'b10000 && Ex_load_port2_address_insert_position > 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && Ex_load_port2_address_insert_position > 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && Ex_load_port2_address_insert_position > 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && Ex_load_port2_address_insert_position > 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && Ex_load_port2_address_insert_position > 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && Ex_load_port2_address_insert_position > 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && Ex_load_port2_address_insert_position > 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && Ex_load_port2_address_insert_position > 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && Ex_load_port2_address_insert_position > 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(head_ptr <= 5'b11001 && Ex_load_port2_address_insert_position > 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && Ex_load_port2_address_insert_position > 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && Ex_load_port2_address_insert_position > 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && Ex_load_port2_address_insert_position > 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && Ex_load_port2_address_insert_position > 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && Ex_load_port2_address_insert_position > 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && Ex_load_port2_address_insert_position > 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end

//////case 3//////////////////////////////////////////////////////////
      end else if(Ex_load_port2_address_insert_position < tail_ptr && tail_ptr < head_ptr)begin
        if(head_ptr <= 5'b10000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b10111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end    
        end
        if(head_ptr <= 5'b11001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(head_ptr <= 5'b11111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00000 && LSQ_ld_or_st_stack[0])begin 
          if(LSQ_address_stack[0] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[0];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00001 && LSQ_ld_or_st_stack[1])begin 
          if(LSQ_address_stack[1] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[1];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00010 && LSQ_ld_or_st_stack[2])begin 
          if(LSQ_address_stack[2] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[2];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00011 && LSQ_ld_or_st_stack[3])begin 
          if(LSQ_address_stack[3] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[3];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00100 && LSQ_ld_or_st_stack[4])begin 
          if(LSQ_address_stack[4] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[4];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00101 && LSQ_ld_or_st_stack[5])begin 
          if(LSQ_address_stack[5] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[5];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00110 && LSQ_ld_or_st_stack[6])begin 
          if(LSQ_address_stack[6] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[6];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b00111 && LSQ_ld_or_st_stack[7])begin 
          if(LSQ_address_stack[7] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[7];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01000 && LSQ_ld_or_st_stack[8])begin 
          if(LSQ_address_stack[8] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[8];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end   
        end
        if(Ex_load_port2_address_insert_position > 5'b01001 && LSQ_ld_or_st_stack[9])begin 
          if(LSQ_address_stack[9] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[9];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01010 && LSQ_ld_or_st_stack[10])begin 
          if(LSQ_address_stack[10] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[10];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01011 && LSQ_ld_or_st_stack[11])begin 
          if(LSQ_address_stack[11] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[11];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01100 && LSQ_ld_or_st_stack[12])begin 
          if(LSQ_address_stack[12] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[12];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01101 && LSQ_ld_or_st_stack[13])begin 
          if(LSQ_address_stack[13] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[13];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01110 && LSQ_ld_or_st_stack[14])begin 
          if(LSQ_address_stack[14] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[14];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
        if(Ex_load_port2_address_insert_position > 5'b01111 && LSQ_ld_or_st_stack[15])begin 
          if(LSQ_address_stack[15] == Ex_load_port2_address)begin
            load_port_2_data = LSQ_data_stack[15];
            load_port_2_ready_bit = 3'd7;     
          end else begin
            load_port_2_data = 64'd0;
            load_port_2_ready_bit = 3'd1;  
          end
        end
      end



end


end




always @*
begin
  LSQ_Rob_store_retire_en = 1'b0;
  if(LSQ_ld_or_st_stack[head_ptr[3:0]]  && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7) LSQ_Rob_store_retire_en = 1'b1;//
end

always @*
begin
  LSQ_str_hazard = 1'b0;
  if({!head_ptr[4],head_ptr[3:0]} == tail_plus_three && write_in_case_2) LSQ_str_hazard = 1'b1;
  if({!head_ptr[4],head_ptr[3:0]} == tail_plus_two && (write_in_1 || write_in_case_2) ) LSQ_str_hazard = 1'b1;
  if(({!head_ptr[4],head_ptr[3:0]} == tail_plus_one || {!head_ptr[4],head_ptr[3:0]} == tail_ptr)) LSQ_str_hazard = 1'b1;
end

always @*
begin
  LSQ_Dcash_store_address_en = 1'b0;
  LSQ_Dcash_store_address = 64'd0;
  LSQ_Dcash_store_data = 64'd0;
  if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3))begin
    LSQ_Dcash_store_address_en = 1'b1;
    LSQ_Dcash_store_address = LSQ_address_stack[head_ptr[3:0]];
    LSQ_Dcash_store_data = LSQ_data_stack[head_ptr[3:0]];
  end
end


always @*
begin
  LSQ_Dcash_load_address_en = 1'b0;
  LSQ_Dcash_load_address = 64'd0;
  if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2))begin
    LSQ_Dcash_load_address_en = 1'b1;
    LSQ_Dcash_load_address = LSQ_address_stack[head_ptr[3:0]];
  end
end

always @*
begin
  LSQ_Rob_destination = 6'd31; 
  LSQ_Rob_data = 64'd0;
  LSQ_Rob_NPC = 64'd0;
  LSQ_Rob_write_dest_n_data_en = 1'b0;
  if(~stall && ~recovery_en && ~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7)begin//
    LSQ_Rob_destination = LSQ_destination_stack[head_ptr[3:0]]; 
    LSQ_Rob_data = LSQ_data_stack[head_ptr[3:0]];
    LSQ_Rob_NPC = LSQ_NPC_stack[head_ptr[3:0]];          
    LSQ_Rob_write_dest_n_data_en = 1'b1;
  end
end

always @* 
  begin
      next_LSQ_ld_or_st_stack[ 0]   = LSQ_ld_or_st_stack[ 0];
      next_LSQ_ld_or_st_stack[ 1]   = LSQ_ld_or_st_stack[ 1];
      next_LSQ_ld_or_st_stack[ 2]   = LSQ_ld_or_st_stack[ 2];
      next_LSQ_ld_or_st_stack[ 3]   = LSQ_ld_or_st_stack[ 3];
      next_LSQ_ld_or_st_stack[ 4]   = LSQ_ld_or_st_stack[ 4];
      next_LSQ_ld_or_st_stack[ 5]   = LSQ_ld_or_st_stack[ 5];
      next_LSQ_ld_or_st_stack[ 6]   = LSQ_ld_or_st_stack[ 6];
      next_LSQ_ld_or_st_stack[ 7]   = LSQ_ld_or_st_stack[ 7];
      next_LSQ_ld_or_st_stack[ 8]   = LSQ_ld_or_st_stack[ 8];
      next_LSQ_ld_or_st_stack[ 9]   = LSQ_ld_or_st_stack[ 9];
      next_LSQ_ld_or_st_stack[10]   = LSQ_ld_or_st_stack[10];
      next_LSQ_ld_or_st_stack[11]   = LSQ_ld_or_st_stack[11];
      next_LSQ_ld_or_st_stack[12]   = LSQ_ld_or_st_stack[12];
      next_LSQ_ld_or_st_stack[13]   = LSQ_ld_or_st_stack[13];
      next_LSQ_ld_or_st_stack[14]   = LSQ_ld_or_st_stack[14];
      next_LSQ_ld_or_st_stack[15]   = LSQ_ld_or_st_stack[15];
         
      next_LSQ_ready_bit_stack[ 0]  = LSQ_ready_bit_stack[ 0];
      next_LSQ_ready_bit_stack[ 1]  = LSQ_ready_bit_stack[ 1];
      next_LSQ_ready_bit_stack[ 2]  = LSQ_ready_bit_stack[ 2];
      next_LSQ_ready_bit_stack[ 3]  = LSQ_ready_bit_stack[ 3];
      next_LSQ_ready_bit_stack[ 4]  = LSQ_ready_bit_stack[ 4];
      next_LSQ_ready_bit_stack[ 5]  = LSQ_ready_bit_stack[ 5];
      next_LSQ_ready_bit_stack[ 6]  = LSQ_ready_bit_stack[ 6];
      next_LSQ_ready_bit_stack[ 7]  = LSQ_ready_bit_stack[ 7];
      next_LSQ_ready_bit_stack[ 8]  = LSQ_ready_bit_stack[ 8];
      next_LSQ_ready_bit_stack[ 9]  = LSQ_ready_bit_stack[ 9];
      next_LSQ_ready_bit_stack[10]  = LSQ_ready_bit_stack[10];
      next_LSQ_ready_bit_stack[11]  = LSQ_ready_bit_stack[11];
      next_LSQ_ready_bit_stack[12]  = LSQ_ready_bit_stack[12];
      next_LSQ_ready_bit_stack[13]  = LSQ_ready_bit_stack[13];
      next_LSQ_ready_bit_stack[14]  = LSQ_ready_bit_stack[14];
      next_LSQ_ready_bit_stack[15]  = LSQ_ready_bit_stack[15];

      next_LSQ_response_stack[ 0]   = LSQ_response_stack[ 0];
      next_LSQ_response_stack[ 1]   = LSQ_response_stack[ 1];
      next_LSQ_response_stack[ 2]   = LSQ_response_stack[ 2];
      next_LSQ_response_stack[ 3]   = LSQ_response_stack[ 3];
      next_LSQ_response_stack[ 4]   = LSQ_response_stack[ 4];
      next_LSQ_response_stack[ 5]   = LSQ_response_stack[ 5];
      next_LSQ_response_stack[ 6]   = LSQ_response_stack[ 6];
      next_LSQ_response_stack[ 7]   = LSQ_response_stack[ 7];
      next_LSQ_response_stack[ 8]   = LSQ_response_stack[ 8];
      next_LSQ_response_stack[ 9]   = LSQ_response_stack[ 9];
      next_LSQ_response_stack[10]   = LSQ_response_stack[10];
      next_LSQ_response_stack[11]   = LSQ_response_stack[11];
      next_LSQ_response_stack[12]   = LSQ_response_stack[12];
      next_LSQ_response_stack[13]   = LSQ_response_stack[13];
      next_LSQ_response_stack[14]   = LSQ_response_stack[14]; 
      next_LSQ_response_stack[15]   = LSQ_response_stack[15];

      next_LSQ_address_stack[ 0]    = LSQ_address_stack[ 0];
      next_LSQ_address_stack[ 1]    = LSQ_address_stack[ 1];
      next_LSQ_address_stack[ 2]    = LSQ_address_stack[ 2];
      next_LSQ_address_stack[ 3]    = LSQ_address_stack[ 3];
      next_LSQ_address_stack[ 4]    = LSQ_address_stack[ 4];
      next_LSQ_address_stack[ 5]    = LSQ_address_stack[ 5];
      next_LSQ_address_stack[ 6]    = LSQ_address_stack[ 6];
      next_LSQ_address_stack[ 7]    = LSQ_address_stack[ 7];
      next_LSQ_address_stack[ 8]    = LSQ_address_stack[ 8];
      next_LSQ_address_stack[ 9]    = LSQ_address_stack[ 9];
      next_LSQ_address_stack[10]    = LSQ_address_stack[10];
      next_LSQ_address_stack[11]    = LSQ_address_stack[11];
      next_LSQ_address_stack[12]    = LSQ_address_stack[12];
      next_LSQ_address_stack[13]    = LSQ_address_stack[13];
      next_LSQ_address_stack[14]    = LSQ_address_stack[14];
      next_LSQ_address_stack[15]    = LSQ_address_stack[15];

      next_LSQ_destination_stack[ 0]  = LSQ_destination_stack[ 0];
      next_LSQ_destination_stack[ 1]  = LSQ_destination_stack[ 1];
      next_LSQ_destination_stack[ 2]  = LSQ_destination_stack[ 2];
      next_LSQ_destination_stack[ 3]  = LSQ_destination_stack[ 3];
      next_LSQ_destination_stack[ 4]  = LSQ_destination_stack[ 4];
      next_LSQ_destination_stack[ 5]  = LSQ_destination_stack[ 5];
      next_LSQ_destination_stack[ 6]  = LSQ_destination_stack[ 6];
      next_LSQ_destination_stack[ 7]  = LSQ_destination_stack[ 7];
      next_LSQ_destination_stack[ 8]  = LSQ_destination_stack[ 8];
      next_LSQ_destination_stack[ 9]  = LSQ_destination_stack[ 9];
      next_LSQ_destination_stack[10]  = LSQ_destination_stack[10];
      next_LSQ_destination_stack[11]  = LSQ_destination_stack[11];
      next_LSQ_destination_stack[12]  = LSQ_destination_stack[12];
      next_LSQ_destination_stack[13]  = LSQ_destination_stack[13];
      next_LSQ_destination_stack[14]  = LSQ_destination_stack[14];
      next_LSQ_destination_stack[15]  = LSQ_destination_stack[15];

      next_LSQ_data_stack[ 0]    = LSQ_data_stack[ 0];
      next_LSQ_data_stack[ 1]    = LSQ_data_stack[ 1];
      next_LSQ_data_stack[ 2]    = LSQ_data_stack[ 2];
      next_LSQ_data_stack[ 3]    = LSQ_data_stack[ 3];
      next_LSQ_data_stack[ 4]    = LSQ_data_stack[ 4];
      next_LSQ_data_stack[ 5]    = LSQ_data_stack[ 5];
      next_LSQ_data_stack[ 6]    = LSQ_data_stack[ 6];
      next_LSQ_data_stack[ 7]    = LSQ_data_stack[ 7];
      next_LSQ_data_stack[ 8]    = LSQ_data_stack[ 8];
      next_LSQ_data_stack[ 9]    = LSQ_data_stack[ 9];
      next_LSQ_data_stack[10]    = LSQ_data_stack[10];
      next_LSQ_data_stack[11]    = LSQ_data_stack[11];
      next_LSQ_data_stack[12]    = LSQ_data_stack[12];
      next_LSQ_data_stack[13]    = LSQ_data_stack[13];
      next_LSQ_data_stack[14]    = LSQ_data_stack[14];
      next_LSQ_data_stack[15]    = LSQ_data_stack[15];

      next_LSQ_NPC_stack[ 0]        = LSQ_NPC_stack[ 0];
      next_LSQ_NPC_stack[ 1]        = LSQ_NPC_stack[ 1];
      next_LSQ_NPC_stack[ 2]        = LSQ_NPC_stack[ 2];
      next_LSQ_NPC_stack[ 3]        = LSQ_NPC_stack[ 3];
      next_LSQ_NPC_stack[ 4]        = LSQ_NPC_stack[ 4];
      next_LSQ_NPC_stack[ 5]        = LSQ_NPC_stack[ 5];
      next_LSQ_NPC_stack[ 6]        = LSQ_NPC_stack[ 6];
      next_LSQ_NPC_stack[ 7]        = LSQ_NPC_stack[ 7];
      next_LSQ_NPC_stack[ 8]        = LSQ_NPC_stack[ 8];
      next_LSQ_NPC_stack[ 9]        = LSQ_NPC_stack[ 9];
      next_LSQ_NPC_stack[10]        = LSQ_NPC_stack[10];
      next_LSQ_NPC_stack[11]        = LSQ_NPC_stack[11];
      next_LSQ_NPC_stack[12]        = LSQ_NPC_stack[12];
      next_LSQ_NPC_stack[13]        = LSQ_NPC_stack[13];
      next_LSQ_NPC_stack[14]        = LSQ_NPC_stack[14];
      next_LSQ_NPC_stack[15]        = LSQ_NPC_stack[15];

      next_LSQ_store_retire_accumulator = LSQ_store_retire_accumulator;
      next_tail_ptr                 = tail_ptr;
/////////////////////Rob retire signal///////////////////////////////////////////
//one store//
      if(Rob_store_port1_retire_en && ~Rob_store_port2_retire_en  ||  ~Rob_store_port1_retire_en && Rob_store_port2_retire_en)begin
        next_LSQ_store_retire_accumulator  = LSQ_store_retire_accumulator_plus_one;
      end
//two stores//
      if(Rob_store_port1_retire_en && Rob_store_port2_retire_en)begin
        next_LSQ_store_retire_accumulator  = LSQ_store_retire_accumulator_plus_two;
      end
/////////////////////retire enable/////////////////////////////////////////////
      if(LSQ_retire_enable && ~stall && ~recovery_en)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd0;
	next_LSQ_response_stack[head_ptr[3:0]]     = 4'd0;
	next_LSQ_address_stack[head_ptr[3:0]]      = 64'd0;
 	next_LSQ_destination_stack[head_ptr[3:0]]  = 6'd0;
	next_LSQ_data_stack[head_ptr[3:0]]         = `NO_DATA;
        if(LSQ_ld_or_st_stack[head_ptr[3:0]]) next_LSQ_store_retire_accumulator = LSQ_store_retire_accumulator_minus_one;
      end
/////////////////////PreDecoder Stage//////////////////////////////////////////
//only one store//
      if(~recovery_en && PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en && ~PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]      = 3'd0;

        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]       = 1'b1;  
        next_LSQ_NPC_stack[tail_ptr[3:0]]            = PreDe_store_port1_NPC;
        next_tail_ptr                                = tail_plus_one;   
      end
      if(~recovery_en && ~PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en && ~PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]      = 3'd0;

        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]       = 1'b1;  
        next_LSQ_NPC_stack[tail_ptr[3:0]]            = PreDe_store_port2_NPC;
        next_tail_ptr                                = tail_plus_one;   
      end
//only one load//
      if(~recovery_en && PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en && ~PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]      = 3'd0;
        next_LSQ_destination_stack[tail_ptr[3:0]]    = PreDe_load_port1_destination;
        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]       = 1'b0;
        next_LSQ_NPC_stack[tail_ptr[3:0]]            = PreDe_load_port1_NPC;
        next_tail_ptr                                = tail_plus_one;
      end      
      if(~recovery_en && ~PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en && ~PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]      = 3'd0;
        next_LSQ_destination_stack[tail_ptr[3:0]]    = PreDe_load_port2_destination;
        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]       = 1'b0;
        next_LSQ_NPC_stack[tail_ptr[3:0]]            = PreDe_load_port2_NPC;
        next_tail_ptr                                = tail_plus_one;
      end  
//two stores//
      if(~recovery_en && PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]       = 3'd0;

        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]        = 1'b1;   
        next_LSQ_NPC_stack[tail_ptr[3:0]]             = PreDe_store_port1_NPC;
        next_LSQ_ready_bit_stack[tail_plus_one[3:0]]  = 3'd0;

        next_LSQ_ld_or_st_stack[tail_plus_one[3:0]]   = 1'b1;  
        next_LSQ_NPC_stack[tail_plus_one[3:0]]        = PreDe_store_port2_NPC;
        next_tail_ptr                                 = tail_plus_two;   
      end
//two load//
      if(~recovery_en && PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]       = 3'd0;
        next_LSQ_destination_stack[tail_ptr[3:0]]     = PreDe_load_port1_destination;
        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]        = 1'b0;
        next_LSQ_NPC_stack[tail_ptr[3:0]]             = PreDe_load_port1_NPC;
        next_LSQ_ready_bit_stack[tail_plus_one[3:0]]  = 3'd0;
        next_LSQ_destination_stack[tail_plus_one[3:0]]= PreDe_load_port2_destination;
        next_LSQ_ld_or_st_stack[tail_plus_one[3:0]]   = 1'b0;
        next_LSQ_NPC_stack[tail_plus_one[3:0]]        = PreDe_load_port2_NPC;
        next_tail_ptr                                 = tail_plus_two;
      end  
//store and load//
      if(~recovery_en && PreDe_store_port1_allocate_en && PreDe_load_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]       = 3'd0;

        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]        = 1'b1;  
        next_LSQ_NPC_stack[tail_ptr[3:0]]             = PreDe_store_port1_NPC;
        next_LSQ_ready_bit_stack[tail_plus_one[3:0]]  = 3'd0;
        next_LSQ_destination_stack[tail_plus_one[3:0]]= PreDe_load_port2_destination;
        next_LSQ_ld_or_st_stack[tail_plus_one[3:0]]   = 1'b0;
        next_LSQ_NPC_stack[tail_plus_one[3:0]]        = PreDe_load_port2_NPC;
        next_tail_ptr                                 = tail_plus_two;
      end 
//load and store//
      if(~recovery_en && PreDe_load_port1_allocate_en && PreDe_store_port2_allocate_en)begin
        next_LSQ_ready_bit_stack[tail_ptr[3:0]]       = 3'd0;
        next_LSQ_destination_stack[tail_ptr[3:0]]     = PreDe_load_port1_destination;
        next_LSQ_ld_or_st_stack[tail_ptr[3:0]]        = 1'b0;
        next_LSQ_NPC_stack[tail_ptr[3:0]]             = PreDe_load_port1_NPC;
        next_LSQ_ready_bit_stack[tail_plus_one[3:0]]  = 3'd0;

        next_LSQ_ld_or_st_stack[tail_plus_one[3:0]]   = 1'b1;
        next_LSQ_NPC_stack[tail_plus_one[3:0]]        = PreDe_store_port2_NPC;
        next_tail_ptr                                 = tail_plus_two;
      end 


/////////////////////Execution Stage////////////////////////////////////////////
//only one store//
      if(Ex_store_port1_address_en && ~Ex_store_port2_address_en && ~Ex_load_port1_address_en && ~Ex_load_port2_address_en)begin
        next_LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       = PreDe_store_port1_data;
        next_LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    = Ex_store_port1_address;
        next_LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  = 3'd1;
      end
      if(~Ex_store_port1_address_en && Ex_store_port2_address_en && ~Ex_load_port1_address_en && ~Ex_load_port2_address_en)begin
        next_LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       = PreDe_store_port2_data;
        next_LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    = Ex_store_port2_address;
        next_LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  = 3'd1;
      end
//only one load//
      if(Ex_load_port1_address_en && ~Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin
        next_LSQ_data_stack[Ex_load_port1_address_insert_position[3:0]]        = load_port_1_data;
        next_LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     = Ex_load_port1_address;
        next_LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   = load_port_1_ready_bit;
      end
      if(~Ex_load_port1_address_en && Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin
        next_LSQ_data_stack[Ex_load_port2_address_insert_position[3:0]]        = load_port_2_data;
        next_LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     = Ex_load_port2_address;
        next_LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   = load_port_2_ready_bit;
      end
//two stores//
      if(Ex_store_port1_address_en && Ex_store_port2_address_en)begin
        next_LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       = PreDe_store_port1_data;
        next_LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    = Ex_store_port1_address;
        next_LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  = 3'd1;
        next_LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       = PreDe_store_port2_data;
        next_LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    = Ex_store_port2_address;
        next_LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  = 3'd1;
      end
//two loads//
      if(Ex_load_port1_address_en && Ex_load_port2_address_en)begin
        next_LSQ_data_stack[Ex_load_port1_address_insert_position[3:0]]        = load_port_1_data;
        next_LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     = Ex_load_port1_address;
        next_LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   = load_port_1_ready_bit;
        next_LSQ_data_stack[Ex_load_port2_address_insert_position[3:0]]        = load_port_2_data;
        next_LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     = Ex_load_port2_address;
        next_LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   = load_port_2_ready_bit;
      end
//store and load//
      if(Ex_store_port1_address_en && Ex_load_port2_address_en)begin
        next_LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       = PreDe_store_port1_data;
        next_LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    = Ex_store_port1_address;
        next_LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  = 3'd1;
        next_LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     = Ex_load_port2_address;
        next_LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   = 3'd1;
      end
//load and store//
      if(Ex_load_port1_address_en && Ex_store_port2_address_en)begin
        next_LSQ_data_stack[Ex_load_port1_address_insert_position[3:0]]        = load_port_1_data;
        next_LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     = Ex_load_port1_address;
        next_LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   = load_port_1_ready_bit;
        next_LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       = PreDe_store_port2_data;
        next_LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    = Ex_store_port2_address;
        next_LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  = 3'd1;
      end


/////////////////////Actions for store at the head///////////////////////////////
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 && Rob_store_port1_retire_en)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd2;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && Dcash_store_valid)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd7;//
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && !Dcash_store_valid && Dcash_response != 4'd0)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd4;
        next_LSQ_response_stack[head_ptr[3:0]]     = Dcash_response;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && !Dcash_store_valid && Dcash_response == 4'd0)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd3;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd4 && LSQ_response_stack[head_ptr[3:0]] == Dcash_tag)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]    = 3'd7;//
      end
/////////////////////Actions for load at the head//////////////////////////////// 
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && Dcash_load_valid)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]      = 3'd7;//
        next_LSQ_data_stack[head_ptr[3:0]]           = Dcash_load_valid_data;
      end 
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_load_valid && Dcash_response != 4'd0)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]      = 3'd3;
        next_LSQ_response_stack[head_ptr[3:0]]       = Dcash_response;
      end
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_load_valid && Dcash_response == 4'd0)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]      = 3'd2;
      end
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3 && LSQ_response_stack[head_ptr[3:0]] == Dcash_tag)begin
        next_LSQ_ready_bit_stack[head_ptr[3:0]]      = 3'd7;//
        next_LSQ_data_stack[head_ptr[3:0]]           = Dcash_tag_data;
      end
end

always @*
begin
  next_head_ptr = head_ptr;
  if(LSQ_retire_enable && ~stall && ~recovery_en) next_head_ptr = head_ptr + 1;
end


always@(posedge clock) begin
  if(reset) head_ptr <= `SD 0;
  else      head_ptr <= `SD next_head_ptr;
end

always @(posedge clock)
    if (reset)
    begin
 
      LSQ_ld_or_st_stack[ 0]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 1]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 2]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 3]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 4]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 5]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 6]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 7]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 8]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 9]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[10]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[11]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[12]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[13]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[14]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[15]   <= `SD 1'b0;
         
      LSQ_ready_bit_stack[ 0]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 1]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 2]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 3]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 4]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 5]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 6]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 7]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 8]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 9]  <= `SD 3'd0;
      LSQ_ready_bit_stack[10]  <= `SD 3'd0;
      LSQ_ready_bit_stack[11]  <= `SD 3'd0;
      LSQ_ready_bit_stack[12]  <= `SD 3'd0;
      LSQ_ready_bit_stack[13]  <= `SD 3'd0;
      LSQ_ready_bit_stack[14]  <= `SD 3'd0;
      LSQ_ready_bit_stack[15]  <= `SD 3'd0;

      LSQ_response_stack[ 0]   <= `SD 4'd0;
      LSQ_response_stack[ 1]   <= `SD 4'd0;
      LSQ_response_stack[ 2]   <= `SD 4'd0;
      LSQ_response_stack[ 3]   <= `SD 4'd0;
      LSQ_response_stack[ 4]   <= `SD 4'd0;
      LSQ_response_stack[ 5]   <= `SD 4'd0;
      LSQ_response_stack[ 6]   <= `SD 4'd0;
      LSQ_response_stack[ 7]   <= `SD 4'd0;
      LSQ_response_stack[ 8]   <= `SD 4'd0;
      LSQ_response_stack[ 9]   <= `SD 4'd0;
      LSQ_response_stack[10]   <= `SD 4'd0;
      LSQ_response_stack[11]   <= `SD 4'd0;
      LSQ_response_stack[12]   <= `SD 4'd0;
      LSQ_response_stack[13]   <= `SD 4'd0;
      LSQ_response_stack[14]   <= `SD 4'd0;  
      LSQ_response_stack[15]   <= `SD 4'd0;

      LSQ_address_stack[ 0]    <= `SD 64'd0;
      LSQ_address_stack[ 1]    <= `SD 64'd0;
      LSQ_address_stack[ 2]    <= `SD 64'd0;
      LSQ_address_stack[ 3]    <= `SD 64'd0;
      LSQ_address_stack[ 4]    <= `SD 64'd0;
      LSQ_address_stack[ 5]    <= `SD 64'd0;
      LSQ_address_stack[ 6]    <= `SD 64'd0;
      LSQ_address_stack[ 7]    <= `SD 64'd0;
      LSQ_address_stack[ 8]    <= `SD 64'd0;
      LSQ_address_stack[ 9]    <= `SD 64'd0;
      LSQ_address_stack[10]    <= `SD 64'd0;
      LSQ_address_stack[11]    <= `SD 64'd0;
      LSQ_address_stack[12]    <= `SD 64'd0;
      LSQ_address_stack[13]    <= `SD 64'd0;
      LSQ_address_stack[14]    <= `SD 64'd0;
      LSQ_address_stack[15]    <= `SD 64'd0;

      LSQ_destination_stack[ 0]  <= `SD 6'd0;
      LSQ_destination_stack[ 1]  <= `SD 6'd0;
      LSQ_destination_stack[ 2]  <= `SD 6'd0;
      LSQ_destination_stack[ 3]  <= `SD 6'd0;
      LSQ_destination_stack[ 4]  <= `SD 6'd0;
      LSQ_destination_stack[ 5]  <= `SD 6'd0;
      LSQ_destination_stack[ 6]  <= `SD 6'd0;
      LSQ_destination_stack[ 7]  <= `SD 6'd0;
      LSQ_destination_stack[ 8]  <= `SD 6'd0;
      LSQ_destination_stack[ 9]  <= `SD 6'd0;
      LSQ_destination_stack[10]  <= `SD 6'd0;
      LSQ_destination_stack[11]  <= `SD 6'd0;
      LSQ_destination_stack[12]  <= `SD 6'd0;
      LSQ_destination_stack[13]  <= `SD 6'd0;
      LSQ_destination_stack[14]  <= `SD 6'd0;
      LSQ_destination_stack[15]  <= `SD 6'd0;

      LSQ_data_stack[ 0]    <= `SD `NO_DATA;
      LSQ_data_stack[ 1]    <= `SD `NO_DATA;
      LSQ_data_stack[ 2]    <= `SD `NO_DATA;
      LSQ_data_stack[ 3]    <= `SD `NO_DATA;
      LSQ_data_stack[ 4]    <= `SD `NO_DATA;
      LSQ_data_stack[ 5]    <= `SD `NO_DATA;
      LSQ_data_stack[ 6]    <= `SD `NO_DATA;
      LSQ_data_stack[ 7]    <= `SD `NO_DATA;
      LSQ_data_stack[ 8]    <= `SD `NO_DATA;
      LSQ_data_stack[ 9]    <= `SD `NO_DATA;
      LSQ_data_stack[10]    <= `SD `NO_DATA;
      LSQ_data_stack[11]    <= `SD `NO_DATA;
      LSQ_data_stack[12]    <= `SD `NO_DATA;
      LSQ_data_stack[13]    <= `SD `NO_DATA;
      LSQ_data_stack[14]    <= `SD `NO_DATA;
      LSQ_data_stack[15]    <= `SD `NO_DATA;


      LSQ_NPC_stack[ 0]        <= `SD 64'd0;
      LSQ_NPC_stack[ 1]        <= `SD 64'd0;
      LSQ_NPC_stack[ 2]        <= `SD 64'd0;
      LSQ_NPC_stack[ 3]        <= `SD 64'd0;
      LSQ_NPC_stack[ 4]        <= `SD 64'd0;
      LSQ_NPC_stack[ 5]        <= `SD 64'd0;
      LSQ_NPC_stack[ 6]        <= `SD 64'd0;
      LSQ_NPC_stack[ 7]        <= `SD 64'd0;
      LSQ_NPC_stack[ 8]        <= `SD 64'd0;
      LSQ_NPC_stack[ 9]        <= `SD 64'd0;
      LSQ_NPC_stack[10]        <= `SD 64'd0;
      LSQ_NPC_stack[11]        <= `SD 64'd0;
      LSQ_NPC_stack[12]        <= `SD 64'd0;
      LSQ_NPC_stack[13]        <= `SD 64'd0;
      LSQ_NPC_stack[14]        <= `SD 64'd0;
      LSQ_NPC_stack[15]        <= `SD 64'd0;

     
      tail_ptr      	             <= `SD 5'd0;
      LSQ_store_retire_accumulator   <= `SD 4'd0;

    end else begin
/////////////////////Rob retire signal///////////////////////////////////////////
      LSQ_store_retire_accumulator         <= `SD next_LSQ_store_retire_accumulator;

 
////////////////////////////////////////////////////////////////////////////////
      LSQ_ld_or_st_stack[ 0]   <= `SD next_LSQ_ld_or_st_stack[ 0];
      LSQ_ld_or_st_stack[ 1]   <= `SD next_LSQ_ld_or_st_stack[ 1];
      LSQ_ld_or_st_stack[ 2]   <= `SD next_LSQ_ld_or_st_stack[ 2];
      LSQ_ld_or_st_stack[ 3]   <= `SD next_LSQ_ld_or_st_stack[ 3];
      LSQ_ld_or_st_stack[ 4]   <= `SD next_LSQ_ld_or_st_stack[ 4];
      LSQ_ld_or_st_stack[ 5]   <= `SD next_LSQ_ld_or_st_stack[ 5];
      LSQ_ld_or_st_stack[ 6]   <= `SD next_LSQ_ld_or_st_stack[ 6];
      LSQ_ld_or_st_stack[ 7]   <= `SD next_LSQ_ld_or_st_stack[ 7];
      LSQ_ld_or_st_stack[ 8]   <= `SD next_LSQ_ld_or_st_stack[ 8];
      LSQ_ld_or_st_stack[ 9]   <= `SD next_LSQ_ld_or_st_stack[ 9];
      LSQ_ld_or_st_stack[10]   <= `SD next_LSQ_ld_or_st_stack[10];
      LSQ_ld_or_st_stack[11]   <= `SD next_LSQ_ld_or_st_stack[11];
      LSQ_ld_or_st_stack[12]   <= `SD next_LSQ_ld_or_st_stack[12];
      LSQ_ld_or_st_stack[13]   <= `SD next_LSQ_ld_or_st_stack[13];
      LSQ_ld_or_st_stack[14]   <= `SD next_LSQ_ld_or_st_stack[14];
      LSQ_ld_or_st_stack[15]   <= `SD next_LSQ_ld_or_st_stack[15];
         
      LSQ_ready_bit_stack[ 0]  <= `SD next_LSQ_ready_bit_stack[ 0];
      LSQ_ready_bit_stack[ 1]  <= `SD next_LSQ_ready_bit_stack[ 1];
      LSQ_ready_bit_stack[ 2]  <= `SD next_LSQ_ready_bit_stack[ 2];
      LSQ_ready_bit_stack[ 3]  <= `SD next_LSQ_ready_bit_stack[ 3];
      LSQ_ready_bit_stack[ 4]  <= `SD next_LSQ_ready_bit_stack[ 4];
      LSQ_ready_bit_stack[ 5]  <= `SD next_LSQ_ready_bit_stack[ 5];
      LSQ_ready_bit_stack[ 6]  <= `SD next_LSQ_ready_bit_stack[ 6];
      LSQ_ready_bit_stack[ 7]  <= `SD next_LSQ_ready_bit_stack[ 7];
      LSQ_ready_bit_stack[ 8]  <= `SD next_LSQ_ready_bit_stack[ 8];
      LSQ_ready_bit_stack[ 9]  <= `SD next_LSQ_ready_bit_stack[ 9];
      LSQ_ready_bit_stack[10]  <= `SD next_LSQ_ready_bit_stack[10];
      LSQ_ready_bit_stack[11]  <= `SD next_LSQ_ready_bit_stack[11];
      LSQ_ready_bit_stack[12]  <= `SD next_LSQ_ready_bit_stack[12];
      LSQ_ready_bit_stack[13]  <= `SD next_LSQ_ready_bit_stack[13];
      LSQ_ready_bit_stack[14]  <= `SD next_LSQ_ready_bit_stack[14];
      LSQ_ready_bit_stack[15]  <= `SD next_LSQ_ready_bit_stack[15];

      LSQ_response_stack[ 0]   <= `SD next_LSQ_response_stack[ 0];
      LSQ_response_stack[ 1]   <= `SD next_LSQ_response_stack[ 1];
      LSQ_response_stack[ 2]   <= `SD next_LSQ_response_stack[ 2];
      LSQ_response_stack[ 3]   <= `SD next_LSQ_response_stack[ 3];
      LSQ_response_stack[ 4]   <= `SD next_LSQ_response_stack[ 4];
      LSQ_response_stack[ 5]   <= `SD next_LSQ_response_stack[ 5];
      LSQ_response_stack[ 6]   <= `SD next_LSQ_response_stack[ 6];
      LSQ_response_stack[ 7]   <= `SD next_LSQ_response_stack[ 7];
      LSQ_response_stack[ 8]   <= `SD next_LSQ_response_stack[ 8];
      LSQ_response_stack[ 9]   <= `SD next_LSQ_response_stack[ 9];
      LSQ_response_stack[10]   <= `SD next_LSQ_response_stack[10];
      LSQ_response_stack[11]   <= `SD next_LSQ_response_stack[11];
      LSQ_response_stack[12]   <= `SD next_LSQ_response_stack[12];
      LSQ_response_stack[13]   <= `SD next_LSQ_response_stack[13];
      LSQ_response_stack[14]   <= `SD next_LSQ_response_stack[14]; 
      LSQ_response_stack[15]   <= `SD next_LSQ_response_stack[15];

      LSQ_address_stack[ 0]    <= `SD next_LSQ_address_stack[ 0];
      LSQ_address_stack[ 1]    <= `SD next_LSQ_address_stack[ 1];
      LSQ_address_stack[ 2]    <= `SD next_LSQ_address_stack[ 2];
      LSQ_address_stack[ 3]    <= `SD next_LSQ_address_stack[ 3];
      LSQ_address_stack[ 4]    <= `SD next_LSQ_address_stack[ 4];
      LSQ_address_stack[ 5]    <= `SD next_LSQ_address_stack[ 5];
      LSQ_address_stack[ 6]    <= `SD next_LSQ_address_stack[ 6];
      LSQ_address_stack[ 7]    <= `SD next_LSQ_address_stack[ 7];
      LSQ_address_stack[ 8]    <= `SD next_LSQ_address_stack[ 8];
      LSQ_address_stack[ 9]    <= `SD next_LSQ_address_stack[ 9];
      LSQ_address_stack[10]    <= `SD next_LSQ_address_stack[10];
      LSQ_address_stack[11]    <= `SD next_LSQ_address_stack[11];
      LSQ_address_stack[12]    <= `SD next_LSQ_address_stack[12];
      LSQ_address_stack[13]    <= `SD next_LSQ_address_stack[13];
      LSQ_address_stack[14]    <= `SD next_LSQ_address_stack[14];
      LSQ_address_stack[15]    <= `SD next_LSQ_address_stack[15];

      LSQ_destination_stack[ 0]  <= `SD next_LSQ_destination_stack[ 0];
      LSQ_destination_stack[ 1]  <= `SD next_LSQ_destination_stack[ 1];
      LSQ_destination_stack[ 2]  <= `SD next_LSQ_destination_stack[ 2];
      LSQ_destination_stack[ 3]  <= `SD next_LSQ_destination_stack[ 3];
      LSQ_destination_stack[ 4]  <= `SD next_LSQ_destination_stack[ 4];
      LSQ_destination_stack[ 5]  <= `SD next_LSQ_destination_stack[ 5];
      LSQ_destination_stack[ 6]  <= `SD next_LSQ_destination_stack[ 6];
      LSQ_destination_stack[ 7]  <= `SD next_LSQ_destination_stack[ 7];
      LSQ_destination_stack[ 8]  <= `SD next_LSQ_destination_stack[ 8];
      LSQ_destination_stack[ 9]  <= `SD next_LSQ_destination_stack[ 9];
      LSQ_destination_stack[10]  <= `SD next_LSQ_destination_stack[10];
      LSQ_destination_stack[11]  <= `SD next_LSQ_destination_stack[11];
      LSQ_destination_stack[12]  <= `SD next_LSQ_destination_stack[12];
      LSQ_destination_stack[13]  <= `SD next_LSQ_destination_stack[13];
      LSQ_destination_stack[14]  <= `SD next_LSQ_destination_stack[14];
      LSQ_destination_stack[15]  <= `SD next_LSQ_destination_stack[15];

      LSQ_data_stack[ 0]    <= `SD next_LSQ_data_stack[ 0];
      LSQ_data_stack[ 1]    <= `SD next_LSQ_data_stack[ 1];
      LSQ_data_stack[ 2]    <= `SD next_LSQ_data_stack[ 2];
      LSQ_data_stack[ 3]    <= `SD next_LSQ_data_stack[ 3];
      LSQ_data_stack[ 4]    <= `SD next_LSQ_data_stack[ 4];
      LSQ_data_stack[ 5]    <= `SD next_LSQ_data_stack[ 5];
      LSQ_data_stack[ 6]    <= `SD next_LSQ_data_stack[ 6];
      LSQ_data_stack[ 7]    <= `SD next_LSQ_data_stack[ 7];
      LSQ_data_stack[ 8]    <= `SD next_LSQ_data_stack[ 8];
      LSQ_data_stack[ 9]    <= `SD next_LSQ_data_stack[ 9];
      LSQ_data_stack[10]    <= `SD next_LSQ_data_stack[10];
      LSQ_data_stack[11]    <= `SD next_LSQ_data_stack[11];
      LSQ_data_stack[12]    <= `SD next_LSQ_data_stack[12];
      LSQ_data_stack[13]    <= `SD next_LSQ_data_stack[13];
      LSQ_data_stack[14]    <= `SD next_LSQ_data_stack[14];
      LSQ_data_stack[15]    <= `SD next_LSQ_data_stack[15];

      LSQ_NPC_stack[ 0]        <= `SD next_LSQ_NPC_stack[ 0];
      LSQ_NPC_stack[ 1]        <= `SD next_LSQ_NPC_stack[ 1];
      LSQ_NPC_stack[ 2]        <= `SD next_LSQ_NPC_stack[ 2];
      LSQ_NPC_stack[ 3]        <= `SD next_LSQ_NPC_stack[ 3];
      LSQ_NPC_stack[ 4]        <= `SD next_LSQ_NPC_stack[ 4];
      LSQ_NPC_stack[ 5]        <= `SD next_LSQ_NPC_stack[ 5];
      LSQ_NPC_stack[ 6]        <= `SD next_LSQ_NPC_stack[ 6];
      LSQ_NPC_stack[ 7]        <= `SD next_LSQ_NPC_stack[ 7];
      LSQ_NPC_stack[ 8]        <= `SD next_LSQ_NPC_stack[ 8];
      LSQ_NPC_stack[ 9]        <= `SD next_LSQ_NPC_stack[ 9];
      LSQ_NPC_stack[10]        <= `SD next_LSQ_NPC_stack[10];
      LSQ_NPC_stack[11]        <= `SD next_LSQ_NPC_stack[11];
      LSQ_NPC_stack[12]        <= `SD next_LSQ_NPC_stack[12];
      LSQ_NPC_stack[13]        <= `SD next_LSQ_NPC_stack[13];
      LSQ_NPC_stack[14]        <= `SD next_LSQ_NPC_stack[14];
      LSQ_NPC_stack[15]        <= `SD next_LSQ_NPC_stack[15];

      tail_ptr                 <= `SD next_tail_ptr;
    end

endmodule




