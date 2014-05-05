module testbench; 
reg	   clock;
reg	   reset;

reg        PreDe_load_port1_allocate_en;
reg [5:0]  PreDe_load_port1_destination;
reg [63:0] PreDe_load_port1_NPC;        
reg        PreDe_load_port2_allocate_en;
reg [5:0]  PreDe_load_port2_destination;
reg [63:0] PreDe_load_port2_NPC; 

reg        PreDe_store_port1_allocate_en;
reg [63:0] PreDe_store_port1_data;
reg [63:0] PreDe_store_port1_NPC; 
reg        PreDe_store_port2_allocate_en;
reg [63:0] PreDe_store_port2_data;
reg [63:0] PreDe_store_port2_NPC; 

reg        Ex_load_port1_address_en;
reg [63:0] Ex_load_port1_address;
reg [4:0]  Ex_load_port1_address_insert_position;
reg        Ex_load_port2_address_en;
reg [63:0] Ex_load_port2_address;
reg [4:0]  Ex_load_port2_address_insert_position;

reg        Ex_store_port1_address_en;
reg [63:0] Ex_store_port1_address;
reg [4:0]  Ex_store_port1_address_insert_position;
reg        Ex_store_port2_address_en;
reg [63:0] Ex_store_port2_address;
reg [4:0]  Ex_store_port2_address_insert_position;

reg        Rob_store_port1_retire_en;
reg        Rob_store_port2_retire_en;   

reg        Dcash_load_valid;
reg [63:0] Dcash_load_valid_data;
reg        Dcash_store_valid;

reg [3:0]  Dcash_response;
reg [63:0] Dcash_tag_data;
reg [3:0]  Dcash_tag;

reg        br_marker_port1_en;
reg [2:0]  br_marker_port1_num;
reg        br_marker_port2_en;
reg [2:0]  br_marker_port2_num;

reg        recovery_en;
reg [2:0]  recovery_br_marker_num;

reg        stall;


wire  [4:0] LSQ_PreDe_tail_position;
wire  [4:0] LSQ_PreDe_tail_position_plus_one;

wire  [5:0] LSQ_Rob_destination;
wire  [63:0]LSQ_Rob_data;
wire  [63:0]LSQ_Rob_NPC;
wire  LSQ_Rob_write_dest_n_data_en;             

wire        LSQ_Dcash_load_address_en;
wire  [63:0]LSQ_Dcash_load_address;
wire        LSQ_Dcash_store_address_en;
wire  [63:0]LSQ_Dcash_store_address;
wire  [63:0]LSQ_Dcash_store_data;
             
wire  LSQ_str_hazard;

simLSQ tbp(
           //Input
	     .clock(clock),
	     .reset(reset),

             .PreDe_load_port1_allocate_en(PreDe_load_port1_allocate_en),
             .PreDe_load_port1_destination(PreDe_load_port1_destination),
             .PreDe_load_port1_NPC(PreDe_load_port1_NPC),
             .PreDe_load_port2_allocate_en(PreDe_load_port2_allocate_en),
             .PreDe_load_port2_destination(PreDe_load_port2_destination),
	     .PreDe_load_port2_NPC(PreDe_load_port2_NPC),

             .PreDe_store_port1_allocate_en(PreDe_store_port1_allocate_en),
             .PreDe_store_port1_data(PreDe_store_port1_data),
             .PreDe_store_port1_NPC(PreDe_store_port1_NPC),
             .PreDe_store_port2_allocate_en(PreDe_store_port2_allocate_en),
             .PreDe_store_port2_data(PreDe_store_port2_data),
             .PreDe_store_port2_NPC(PreDe_store_port2_NPC),

            
             .Ex_load_port1_address_en(Ex_load_port1_address_en),
     	     .Ex_load_port1_address(Ex_load_port1_address),
             .Ex_load_port1_address_insert_position(Ex_load_port1_address_insert_position),
             .Ex_load_port2_address_en(Ex_load_port2_address_en),
     	     .Ex_load_port2_address(Ex_load_port2_address),
             .Ex_load_port2_address_insert_position(Ex_load_port2_address_insert_position),

             .Ex_store_port1_address_en(Ex_store_port1_address_en),
     	     .Ex_store_port1_address(Ex_store_port1_address),
             .Ex_store_port1_address_insert_position(Ex_store_port1_address_insert_position),
             .Ex_store_port2_address_en(Ex_store_port2_address_en),
     	     .Ex_store_port2_address(Ex_store_port2_address),
             .Ex_store_port2_address_insert_position(Ex_store_port2_address_insert_position),

             .Rob_store_port1_retire_en(Rob_store_port1_retire_en),  
             .Rob_store_port2_retire_en(Rob_store_port2_retire_en),  

             .Dcash_load_valid(Dcash_load_valid),
             .Dcash_load_valid_data(Dcash_load_valid_data),
             .Dcash_store_valid(Dcash_store_valid),                   
           

             .Dcash_response(Dcash_response),
             .Dcash_tag_data(Dcash_tag_data),
             .Dcash_tag(Dcash_tag),

             .br_marker_port1_en(br_marker_port1_en),
             .br_marker_port1_num(br_marker_port1_num),
             .br_marker_port2_en(br_marker_port2_en),
             .br_marker_port2_num(br_marker_port2_num),

             .recovery_en(recovery_en),
             .recovery_br_marker_num(recovery_br_marker_num),

             .stall(stall),
	  // Outputs
             .LSQ_PreDe_tail_position(LSQ_PreDe_tail_position),
             .LSQ_PreDe_tail_position_plus_one(LSQ_PreDe_tail_position_plus_one),
             
             .LSQ_Rob_destination(LSQ_Rob_destination),
             .LSQ_Rob_data(LSQ_Rob_data),
             .LSQ_Rob_NPC(LSQ_Rob_NPC),
             .LSQ_Rob_write_dest_n_data_en(LSQ_Rob_write_dest_n_data_en),

             .LSQ_Dcash_load_address_en(LSQ_Dcash_load_address_en),
             .LSQ_Dcash_load_address(LSQ_Dcash_load_address),
             .LSQ_Dcash_store_address_en(LSQ_Dcash_store_address_en),
             .LSQ_Dcash_store_address(LSQ_Dcash_store_address),
             .LSQ_Dcash_store_data(LSQ_Dcash_store_data),
             
             .LSQ_str_hazard(LSQ_str_hazard)
             );

always 
begin 
  #5; 
  clock=~clock; 
end 

initial 
begin 

  clock = 1'b0;
  reset = 1'b1;

  PreDe_load_port1_allocate_en = 1'b0;
  PreDe_load_port1_destination = 6'd0;
  PreDe_load_port1_NPC = 64'd0;
  PreDe_load_port2_allocate_en = 1'b0;
  PreDe_load_port2_destination = 6'd0;
  PreDe_load_port2_NPC = 64'd0;

  PreDe_store_port1_allocate_en = 1'b0;
  PreDe_store_port1_data = 64'd0;
  PreDe_store_port1_NPC = 64'd0;
  PreDe_store_port2_allocate_en = 1'b0;
  PreDe_store_port2_data = 64'd0;
  PreDe_store_port2_NPC = 64'd0;
            
  Ex_load_port1_address_en = 1'b0;
  Ex_load_port1_address = 64'd0;
  Ex_load_port1_address_insert_position = 5'd0;
  Ex_load_port2_address_en = 1'b0;
  Ex_load_port2_address = 64'd0;
  Ex_load_port2_address_insert_position = 5'd0;

  Ex_store_port1_address_en = 1'b0;
  Ex_store_port1_address = 64'd0;
  Ex_store_port1_address_insert_position = 5'd0;
  Ex_store_port2_address_en = 1'b0;
  Ex_store_port2_address = 64'd0;
  Ex_store_port2_address_insert_position = 5'd0;

  Rob_store_port1_retire_en = 1'b0;  
  Rob_store_port2_retire_en = 1'b0;  

  Dcash_load_valid = 1'b0;
  Dcash_load_valid_data = 64'd0;
  Dcash_store_valid = 1'b0;  
  
  Dcash_response = 4'd0;
  Dcash_tag_data = 64'd0;
  Dcash_tag = 4'd0;
  
  br_marker_port1_en = 1'b0;
  br_marker_port1_num = 3'b0;
  br_marker_port2_en = 1'b0;
  br_marker_port2_num = 3'b0;

  recovery_en = 1'b0;
  recovery_br_marker_num = 3'b0;             
           
  stall = 1'b0;

  @(negedge clock); 
  @(negedge clock); 
  reset = 1'b0; 
  @(negedge clock); 
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 0    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 0        ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 0    ||LSQ_ready_bit_stack[1] = 0    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 0        ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 0
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 0    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 0        ||LSQ_destination_stack[2] = 0     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 0     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 0    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 0
// LSQ_ld_or_st_stack[ 5] = 0    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 0     ||LSQ_data_stack[5] = 0
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 1
  PreDe_store_port1_allocate_en = 1'b1;
  PreDe_store_port1_data = 64'd1111;
  PreDe_store_port1_NPC = 64'd111;


  @(negedge clock); 
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 0    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 0        ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 1    ||LSQ_ready_bit_stack[1] = 0    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 0        ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 2222
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 0    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 0        ||LSQ_destination_stack[2] = 3     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 0     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 0    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 0
// LSQ_ld_or_st_stack[ 5] = 0    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 0     ||LSQ_data_stack[5] = 0
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 3
  PreDe_store_port1_allocate_en = 1'b1;
  PreDe_store_port1_data = 64'd2222;
  PreDe_store_port1_NPC = 64'd222;
  PreDe_load_port2_allocate_en = 1'b1;
  PreDe_load_port2_destination = 6'd3;
  PreDe_load_port2_NPC = 64'd333;



  @(negedge clock); 
  PreDe_store_port1_allocate_en = 1'b0;
  PreDe_store_port2_allocate_en = 1'b0;
  PreDe_load_port2_allocate_en = 1'b0;
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 0    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 0        ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 1    ||LSQ_ready_bit_stack[1] = 1    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 222222   ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 2222
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 1    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 333333   ||LSQ_destination_stack[2] = 3     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 4     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 0    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 0
// LSQ_ld_or_st_stack[ 5] = 0    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 0     ||LSQ_data_stack[5] = 0
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 4                LSQ_store_retire_accumulator = 1
  PreDe_load_port1_allocate_en = 1'b1;
  PreDe_load_port1_destination = 6'd4;
  PreDe_load_port1_NPC = 64'd444;

  Ex_store_port1_address_en = 1'b1;
  Ex_store_port1_address = 64'd222222;
  Ex_store_port1_address_insert_position = 5'd1;

  Ex_load_port2_address_en = 1'b1;
  Ex_load_port2_address = 64'd333333;
  Ex_load_port2_address_insert_position = 5'd2;
  reset = 1'b1; 
  Rob_store_port1_retire_en = 1'b1; 

  @(negedge clock); 
  PreDe_store_port2_allocate_en = 1'b0;
  PreDe_load_port1_allocate_en = 1'b0;
  PreDe_load_port2_allocate_en = 1'b0;
  Ex_load_port2_address_en = 1'b0;
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 1    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 111111   ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 1    ||LSQ_ready_bit_stack[1] = 1    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 222222   ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 2222
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 1    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 333333   ||LSQ_destination_stack[2] = 3     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 4     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 0    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 5555
// LSQ_ld_or_st_stack[ 5] = 0    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 0     ||LSQ_data_stack[5] = 0
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 5                LSQ_store_retire_accumulator = 2
  PreDe_store_port1_allocate_en = 1'b1;
  PreDe_store_port1_data = 64'd5555;
  PreDe_store_port1_NPC = 64'd555;
  reset = 1'b0; 
  Ex_store_port1_address_en = 1'b1;
  Ex_store_port1_address = 64'd111111;
  Ex_store_port1_address_insert_position = 5'd0;

  br_marker_port2_en = 1'b1;
  br_marker_port2_num = 3'b001;

  Rob_store_port1_retire_en = 1'b1; 



  @(negedge clock); 
  PreDe_store_port1_allocate_en = 1'b0;
  PreDe_store_port2_allocate_en = 1'b0;
  PreDe_load_port1_allocate_en = 1'b0;
  PreDe_load_port2_allocate_en = 1'b0;
  Ex_store_port1_address_en = 1'b0;
  Ex_store_port2_address_en = 1'b0;
  Ex_load_port1_address_en = 1'b0;
  Ex_load_port2_address_en = 1'b0;
  br_marker_port1_en = 1'b0;
  Rob_store_port1_retire_en = 1'b0; 
 
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 1    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 111111   ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 1    ||LSQ_ready_bit_stack[1] = 1    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 222222   ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 2222
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 1    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 333333   ||LSQ_destination_stack[2] = 3     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 4     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 1    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 5555
// LSQ_ld_or_st_stack[ 5] = 1    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 6     ||LSQ_data_stack[5] = 6666
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 6                LSQ_store_retire_accumulator = 2
  Dcash_store_valid = 1'b1;

  PreDe_store_port1_allocate_en = 1'b1;
  PreDe_store_port1_data = 64'd6666;
  PreDe_store_port1_NPC = 64'd666;

  br_marker_port2_en = 1'b1;
  br_marker_port2_num = 3'b010;


  @(negedge clock); 
  PreDe_store_port1_allocate_en = 1'b0;
  PreDe_store_port2_allocate_en = 1'b0;
  PreDe_load_port1_allocate_en = 1'b0;
  PreDe_load_port2_allocate_en = 1'b0;
  Ex_store_port1_address_en = 1'b0;
  Ex_store_port2_address_en = 1'b0;
  Ex_load_port1_address_en = 1'b0;
  Ex_load_port2_address_en = 1'b0;
  br_marker_port1_en = 1'b0;
  Rob_store_port1_retire_en = 1'b0; 
  br_marker_port2_en = 1'b0;
  Dcash_store_valid = 1'b0;
 
// LSQ_ld_or_st_stack[ 0] = 1    ||LSQ_ready_bit_stack[0] = 1    ||LSQ_response_stack[0] = 0       ||LSQ_address_stack[0] = 111111   ||LSQ_destination_stack[0] = 0     ||LSQ_data_stack[0] = 1111
// LSQ_ld_or_st_stack[ 1] = 1    ||LSQ_ready_bit_stack[1] = 1    ||LSQ_response_stack[1] = 0       ||LSQ_address_stack[1] = 222222   ||LSQ_destination_stack[1] = 0     ||LSQ_data_stack[1] = 2222
// LSQ_ld_or_st_stack[ 2] = 0    ||LSQ_ready_bit_stack[2] = 1    ||LSQ_response_stack[2] = 0       ||LSQ_address_stack[2] = 333333   ||LSQ_destination_stack[2] = 3     ||LSQ_data_stack[2] = 0 
// LSQ_ld_or_st_stack[ 3] = 0    ||LSQ_ready_bit_stack[3] = 0    ||LSQ_response_stack[3] = 0       ||LSQ_address_stack[3] = 0        ||LSQ_destination_stack[3] = 4     ||LSQ_data_stack[3] = 0
// LSQ_ld_or_st_stack[ 4] = 1    ||LSQ_ready_bit_stack[4] = 0    ||LSQ_response_stack[4] = 0       ||LSQ_address_stack[4] = 0        ||LSQ_destination_stack[4] = 0     ||LSQ_data_stack[4] = 5555
// LSQ_ld_or_st_stack[ 5] = 1    ||LSQ_ready_bit_stack[5] = 0    ||LSQ_response_stack[5] = 0       ||LSQ_address_stack[5] = 0        ||LSQ_destination_stack[5] = 6     ||LSQ_data_stack[5] = 6666
// LSQ_ld_or_st_stack[ 6] = 0    ||LSQ_ready_bit_stack[6] = 0    ||LSQ_response_stack[6] = 0       ||LSQ_address_stack[6] = 0        ||LSQ_destination_stack[6] = 0     ||LSQ_data_stack[6] = 0
// LSQ_head_ptr = 0              LSQ_tail_ptr = 6                LSQ_store_retire_accumulator = 2


  recovery_en = 1'b1;
  recovery_br_marker_num = 3'b001;



  @(negedge clock); 
  PreDe_load_port1_allocate_en = 1'b0;
  PreDe_load_port2_allocate_en = 1'b0;

  PreDe_store_port1_allocate_en = 1'b0;
  PreDe_store_port2_allocate_en = 1'b0;

  Ex_load_port1_address_en = 1'b0;
  Ex_load_port2_address_en = 1'b0;

  Ex_store_port1_address_en = 1'b0;
  Ex_store_port2_address_en = 1'b0;
 
  Rob_store_port1_retire_en = 1'b0;  
  Rob_store_port2_retire_en = 1'b0;  

  Dcash_load_valid = 1'b0;
  Dcash_store_valid = 1'b0;  

  br_marker_port1_en = 1'b0;
  br_marker_port2_en = 1'b0;

          
           
  stall = 1'b0;
  
  @(negedge clock); 
  $finish; 

end 

endmodule





