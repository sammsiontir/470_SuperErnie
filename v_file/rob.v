/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  rob.v                                               //
//   # od ROB   :  07                                                  //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module rob(// Input
           clock,
           reset,
           T_in_1,
           T_in_2,
           Told_in_1,
           Told_in_2,
           T_wr_en_1,
           T_wr_en_2,
           id_wr_mem_in_1,
           id_wr_mem_in_2,
           id_rd_mem_in_1,
           id_rd_mem_in_2,
           id_cond_branch_in_1,
           id_cond_branch_in_2,
           id_uncond_branch_in_1,
           id_uncond_branch_in_2,
           id_halt_in_1,
           id_halt_in_2,
           id_noop_in_1,
           id_noop_in_2,
           id_br_in_1,
           id_br_in_2,
           NPC_1,
           NPC_2,
           br_wr_en_1,
           br_wr_en_2,
           br_marker_in_1,
           br_marker_in_2,
           br_mispredict,
           br_mispre_marker,
           C_tag_1,
           C_tag_2,
           C_wr_en_1,
           C_wr_en_2,
           C_wb_data_1,
           C_wb_data_2,
           X_br_wr_en_1,
           X_br_wr_en_2,
           X_br_marker_1,
           X_br_marker_2,
           X_br_taken_1,
           X_br_taken_2,
           X_br_target_PC_1,
           X_br_target_PC_2,
           LSQ_wr_mem_finished,

           // Output
           T_out_1,
           T_out_2,
           Told_out_1,
           Told_out_2,
           NPC_out_1,
           NPC_out_2,
           wb_data_out_1,
           wb_data_out_2,
           T_valid_1,
           T_valid_2,
           rob_halt,
           rob_store,
           rob_load,
           rob_stall,
           
           rob_br_mispredict,
           rob_br_mispredict_target_PC,
           rob_br_mispredict_marker,
           rob_br_marker_1,
           rob_br_marker_2,
           rob_br_retire_en_1,
           rob_br_retire_en_2,
           pipeline_commit_halt_on_2_signal
          );

  input        clock;
  input        reset;
  input  [5:0] T_in_1;       // Dispatch: put Tag into rob
  input  [5:0] T_in_2;
  input  [5:0] Told_in_1;    // Dispatch: put Tag Old into rob
  input  [5:0] Told_in_2;
  input        T_wr_en_1;    // Dispatch: tag write enable
  input        T_wr_en_2;
  input        id_wr_mem_in_1;
  input        id_wr_mem_in_2;
  input        id_rd_mem_in_1;
  input        id_rd_mem_in_2;
  input        id_cond_branch_in_1;
  input        id_cond_branch_in_2;
  input        id_uncond_branch_in_1;
  input        id_uncond_branch_in_2;
  input        id_halt_in_1;
  input        id_halt_in_2;
  input        id_noop_in_1;
  input        id_noop_in_2;
  input        id_br_in_1;
  input        id_br_in_2;
  input [63:0] NPC_1;
  input [63:0] NPC_2;
  input        br_wr_en_1;
  input        br_wr_en_2;
  input  [2:0] br_marker_in_1;
  input  [2:0] br_marker_in_2;
  input        br_mispredict;
  input  [2:0] br_mispre_marker;
  input  [5:0] C_tag_1;      // Complete: complete mark = (insn finish)? 1:0
  input  [5:0] C_tag_2;
  input        C_wr_en_1;    // Complete: mark write enable
  input        C_wr_en_2;
  input [63:0] C_wb_data_1;
  input [63:0] C_wb_data_2;
  input        X_br_wr_en_1;
  input        X_br_wr_en_2;
  input  [2:0] X_br_marker_1;
  input  [2:0] X_br_marker_2;
  input        X_br_taken_1;
  input        X_br_taken_2;
  input [63:0] X_br_target_PC_1;
  input [63:0] X_br_target_PC_2;
  input        LSQ_wr_mem_finished;
  
  output [5:0] T_out_1;      // Retire  : put tag to Maptable
  output [5:0] T_out_2;
  output [5:0] Told_out_1;   // Retire  : put Told to Architecture Map
  output [5:0] Told_out_2;
  output       T_valid_1;    // Retire  : T & Told out valid?
  output       T_valid_2;
  output       rob_halt;
  output       rob_store;
  output       rob_load;
  output [1:0] rob_stall;    // Dispatch: Rob full? 2'b00: not full
                             //                     2'b01: only 1 space left
                             //                     2'b11: full
  output        rob_br_mispredict;
  output [63:0] rob_br_mispredict_target_PC;
  output [2:0]  rob_br_mispredict_marker;
  output [2:0]  rob_br_marker_1;
  output [2:0]  rob_br_marker_2;
  output        rob_br_retire_en_1;
  output        rob_br_retire_en_2;
  output        pipeline_commit_halt_on_2_signal;

  output [63:0] NPC_out_1;
  output [63:0] NPC_out_2;
  output [63:0] wb_data_out_1;
  output [63:0] wb_data_out_2;

  // current state
  reg    [5:0] T_out_1;
  reg    [5:0] T_out_2;
  reg    [5:0] Told_out_1;
  reg    [5:0] Told_out_2;
  reg          T_valid_1;
  reg          T_valid_2;
  reg   [63:0] NPC_out_1;
  reg   [63:0] NPC_out_2;
  reg   [63:0] wb_data_out_1;
  reg   [63:0] wb_data_out_2;
  reg    [5:0] br_t     [0:3];
  reg    [5:0] T        [0:31]; 
  reg    [5:0] Told     [0:31]; 
  reg          C        [0:31]; 
  reg          wr_mem   [0:31]; 
  reg          rd_mem   [0:31]; 
  reg   [63:0] NPC      [0:31]; 
  reg   [63:0] wb_data  [0:31]; 
  reg          halt     [0:31]; 
  reg          noop     [0:31]; 
  reg          br       [0:31]; 
  reg          br_taken [0:31]; 
  reg   [63:0] br_target_PC[0:31];
  reg    [2:0] br_marker[0:31];
  // next state
  reg    [5:0] next_T_out_1;
  reg    [5:0] next_T_out_2;
  reg    [5:0] next_Told_out_1;
  reg    [5:0] next_Told_out_2;
  reg          next_T_valid_1;
  reg          next_T_valid_2;
  reg   [63:0] next_NPC_out_1;
  reg   [63:0] next_NPC_out_2;
  reg   [63:0] next_wb_data_out_1;
  reg   [63:0] next_wb_data_out_2;
  reg    [5:0] next_T            [0:31];
  reg    [5:0] next_Told         [0:31];
  reg          next_wr_mem       [0:31];
  reg          next_rd_mem       [0:31];
  reg   [63:0] next_NPC          [0:31];
  reg          next_halt         [0:31];
  reg          next_noop         [0:31];
  reg          next_br           [0:31]; 
  reg    [2:0] next_br_marker    [0:31];
  reg          next_C            [0:31];
  reg          next_br_taken     [0:31];
  reg   [63:0] next_br_target_PC [0:31];
  reg   [63:0] next_wb_data      [0:31];
  // head tail pointer
  reg    [5:0] h;
  reg    [5:0] t;
  wire   [5:0] next_h;
  wire   [5:0] next_t;
  wire   [5:0] h_plus_1 = h + 1;
  wire   [5:0] t_plus_1 = t + 1;
  wire   [5:0] next_t_plus_1 = next_t + 1;
  //////////////////////////////////////////////////
  //                                              //
  //             Retire constraint                //
  //                                              //
  //////////////////////////////////////////////////
  wire         head_empty                 = (h==t);
  wire         head_plus_1_empty          = !head_empty && (h_plus_1==t);
  wire         R_ready_head               = C[h[4:0]]        || noop[h[4:0]]        || halt[h[4:0]]       ;
  wire         R_ready_head_plus_1        = C[h_plus_1[4:0]] || noop[h_plus_1[4:0]] || halt[h_plus_1[4:0]];
  wire         R_Mem_head                 = wr_mem[h[4:0]];
  wire         R_Mem_head_plus_1          = wr_mem[h_plus_1[4:0]];
  wire         R_Mem_ready_head           = R_Mem_head       && LSQ_wr_mem_finished;
  wire         R_Mis_Br_ready_head        = C[h[4:0]]        && br_taken[h[4:0]]        && !head_empty;
  wire         R_Mis_Br_ready_head_plus_1 = C[h_plus_1[4:0]] && br_taken[h_plus_1[4:0]] && !head_plus_1_empty;
  wire retire_one = !head_empty                      && (R_ready_head || R_Mem_ready_head);
  wire retire_two = !head_plus_1_empty && retire_one && R_ready_head_plus_1 && !br_taken[h[4:0]];
  
  assign rob_store = R_Mem_head && !head_empty;
  assign rob_load  = 0;
  assign rob_halt  = (halt[h[4:0]] && retire_one) || (retire_two && halt[h_plus_1[4:0]]);
  assign pipeline_commit_halt_on_2_signal = (retire_two && halt[h_plus_1[4:0]]);

  assign next_h    = (retire_two)? h + 6'd2:        // can retire 2 head inst
                     (retire_one)? h + 6'd1:        // can retire 1 inst
                     h;                             // can retire 0 inst

  assign next_t    = (T_wr_en_2 && T_wr_en_1)?  t + 6'd2: // dispatch 2 inst  
                     (!T_wr_en_2 && T_wr_en_1)? t + 6'd1: // dispatch 1 inst  
                     (T_wr_en_2 && !T_wr_en_1)? t + 6'd1: // dispatch 1 inst  
                     t;                                   // dispatch 0 inst

  assign rob_stall = ({!h[5],h[4:0]}==t)? 2'b11:
                     ({!h[5],h[4:0]}==next_t)? 2'b11:
                     ({!h[5],h[4:0]}==next_t_plus_1)? 2'b01: 
                     2'b00;
  //////////////////////////////////////////////////
  //                                              //
  //                   Branch                     //
  //                                              //
  //////////////////////////////////////////////////
  assign rob_br_mispredict = (retire_two)? R_Mis_Br_ready_head_plus_1: R_Mis_Br_ready_head;
  assign rob_br_mispredict_target_PC = (retire_two)? br_target_PC[h_plus_1[4:0]]: br_target_PC[h[4:0]];
  assign rob_br_mispredict_marker    = (retire_two)? rob_br_marker_2: rob_br_marker_1;
  assign rob_br_marker_1    = br_marker[h[4:0]];
  assign rob_br_marker_2    = br_marker[h_plus_1[4:0]];
  assign rob_br_retire_en_1 = (retire_one)? br[h[4:0]]:1'b0;
  assign rob_br_retire_en_2 = (retire_two)? br[h_plus_1[4:0]]:1'b0;

  //////////////////////////////////////////////////
  //                                              //
  //                 next_state                   //
  //                                              //
  //////////////////////////////////////////////////
  always @*
  begin
    next_T[0]  = T[0];
    next_T[1]  = T[1];
    next_T[2]  = T[2];
    next_T[3]  = T[3];
    next_T[4]  = T[4];
    next_T[5]  = T[5];
    next_T[6]  = T[6];
    next_T[7]  = T[7];
    next_T[8]  = T[8];
    next_T[9]  = T[9];
    next_T[10] = T[10];
    next_T[11] = T[11];
    next_T[12] = T[12];
    next_T[13] = T[13];
    next_T[14] = T[14];
    next_T[15] = T[15];
    next_T[16] = T[16];
    next_T[17] = T[17];
    next_T[18] = T[18];
    next_T[19] = T[19];
    next_T[20] = T[20];
    next_T[21] = T[21];
    next_T[22] = T[22];
    next_T[23] = T[23];
    next_T[24] = T[24];
    next_T[25] = T[25];
    next_T[26] = T[26];
    next_T[27] = T[27];
    next_T[28] = T[28];
    next_T[29] = T[29];
    next_T[30] = T[30];
    next_T[31] = T[31];
    next_Told[0]  = Told[0];
    next_Told[1]  = Told[1];
    next_Told[2]  = Told[2];
    next_Told[3]  = Told[3];
    next_Told[4]  = Told[4];
    next_Told[5]  = Told[5];
    next_Told[6]  = Told[6];
    next_Told[7]  = Told[7];
    next_Told[8]  = Told[8];
    next_Told[9]  = Told[9];
    next_Told[10] = Told[10];
    next_Told[11] = Told[11];
    next_Told[12] = Told[12];
    next_Told[13] = Told[13];
    next_Told[14] = Told[14];
    next_Told[15] = Told[15];
    next_Told[16] = Told[16];
    next_Told[17] = Told[17];
    next_Told[18] = Told[18];
    next_Told[19] = Told[19];
    next_Told[20] = Told[20];
    next_Told[21] = Told[21];
    next_Told[22] = Told[22];
    next_Told[23] = Told[23];
    next_Told[24] = Told[24];
    next_Told[25] = Told[25];
    next_Told[26] = Told[26];
    next_Told[27] = Told[27];
    next_Told[28] = Told[28];
    next_Told[29] = Told[29];
    next_Told[30] = Told[30];
    next_Told[31] = Told[31];
    next_wr_mem[0]  = wr_mem[0];
    next_wr_mem[1]  = wr_mem[1];
    next_wr_mem[2]  = wr_mem[2];
    next_wr_mem[3]  = wr_mem[3];
    next_wr_mem[4]  = wr_mem[4];
    next_wr_mem[5]  = wr_mem[5];
    next_wr_mem[6]  = wr_mem[6];
    next_wr_mem[7]  = wr_mem[7];
    next_wr_mem[8]  = wr_mem[8];
    next_wr_mem[9]  = wr_mem[9];
    next_wr_mem[10] = wr_mem[10];
    next_wr_mem[11] = wr_mem[11];
    next_wr_mem[12] = wr_mem[12];
    next_wr_mem[13] = wr_mem[13];
    next_wr_mem[14] = wr_mem[14];
    next_wr_mem[15] = wr_mem[15];
    next_wr_mem[16] = wr_mem[16];
    next_wr_mem[17] = wr_mem[17];
    next_wr_mem[18] = wr_mem[18];
    next_wr_mem[19] = wr_mem[19];
    next_wr_mem[20] = wr_mem[20];
    next_wr_mem[21] = wr_mem[21];
    next_wr_mem[22] = wr_mem[22];
    next_wr_mem[23] = wr_mem[23];
    next_wr_mem[24] = wr_mem[24];
    next_wr_mem[25] = wr_mem[25];
    next_wr_mem[26] = wr_mem[26];
    next_wr_mem[27] = wr_mem[27];
    next_wr_mem[28] = wr_mem[28];
    next_wr_mem[29] = wr_mem[29];
    next_wr_mem[30] = wr_mem[30];
    next_wr_mem[31] = wr_mem[31];
    next_rd_mem[0]  = rd_mem[0];
    next_rd_mem[1]  = rd_mem[1];
    next_rd_mem[2]  = rd_mem[2];
    next_rd_mem[3]  = rd_mem[3];
    next_rd_mem[4]  = rd_mem[4];
    next_rd_mem[5]  = rd_mem[5];
    next_rd_mem[6]  = rd_mem[6];
    next_rd_mem[7]  = rd_mem[7];
    next_rd_mem[8]  = rd_mem[8];
    next_rd_mem[9]  = rd_mem[9];
    next_rd_mem[10] = rd_mem[10];
    next_rd_mem[11] = rd_mem[11];
    next_rd_mem[12] = rd_mem[12];
    next_rd_mem[13] = rd_mem[13];
    next_rd_mem[14] = rd_mem[14];
    next_rd_mem[15] = rd_mem[15];
    next_rd_mem[16] = rd_mem[16];
    next_rd_mem[17] = rd_mem[17];
    next_rd_mem[18] = rd_mem[18];
    next_rd_mem[19] = rd_mem[19];
    next_rd_mem[20] = rd_mem[20];
    next_rd_mem[21] = rd_mem[21];
    next_rd_mem[22] = rd_mem[22];
    next_rd_mem[23] = rd_mem[23];
    next_rd_mem[24] = rd_mem[24];
    next_rd_mem[25] = rd_mem[25];
    next_rd_mem[26] = rd_mem[26];
    next_rd_mem[27] = rd_mem[27];
    next_rd_mem[28] = rd_mem[28];
    next_rd_mem[29] = rd_mem[29];
    next_rd_mem[30] = rd_mem[30];
    next_rd_mem[31] = rd_mem[31];
    next_br_marker[0]  = br_marker[0];
    next_br_marker[1]  = br_marker[1];
    next_br_marker[2]  = br_marker[2];
    next_br_marker[3]  = br_marker[3];
    next_br_marker[4]  = br_marker[4];
    next_br_marker[5]  = br_marker[5];
    next_br_marker[6]  = br_marker[6];
    next_br_marker[7]  = br_marker[7];
    next_br_marker[8]  = br_marker[8];
    next_br_marker[9]  = br_marker[9];
    next_br_marker[10] = br_marker[10];
    next_br_marker[11] = br_marker[11];
    next_br_marker[12] = br_marker[12];
    next_br_marker[13] = br_marker[13];
    next_br_marker[14] = br_marker[14];
    next_br_marker[15] = br_marker[15];
    next_br_marker[16] = br_marker[16];
    next_br_marker[17] = br_marker[17];
    next_br_marker[18] = br_marker[18];
    next_br_marker[19] = br_marker[19];
    next_br_marker[20] = br_marker[20];
    next_br_marker[21] = br_marker[21];
    next_br_marker[22] = br_marker[22];
    next_br_marker[23] = br_marker[23];
    next_br_marker[24] = br_marker[24];
    next_br_marker[25] = br_marker[25];
    next_br_marker[26] = br_marker[26];
    next_br_marker[27] = br_marker[27];
    next_br_marker[28] = br_marker[28];
    next_br_marker[29] = br_marker[29];
    next_br_marker[30] = br_marker[30];
    next_br_marker[31] = br_marker[31];
    next_NPC[0]  = NPC[0];
    next_NPC[1]  = NPC[1];
    next_NPC[2]  = NPC[2];
    next_NPC[3]  = NPC[3];
    next_NPC[4]  = NPC[4];
    next_NPC[5]  = NPC[5];
    next_NPC[6]  = NPC[6];
    next_NPC[7]  = NPC[7];
    next_NPC[8]  = NPC[8];
    next_NPC[9]  = NPC[9];
    next_NPC[10] = NPC[10];
    next_NPC[11] = NPC[11];
    next_NPC[12] = NPC[12];
    next_NPC[13] = NPC[13];
    next_NPC[14] = NPC[14];
    next_NPC[15] = NPC[15];
    next_NPC[16] = NPC[16];
    next_NPC[17] = NPC[17];
    next_NPC[18] = NPC[18];
    next_NPC[19] = NPC[19];
    next_NPC[20] = NPC[20];
    next_NPC[21] = NPC[21];
    next_NPC[22] = NPC[22];
    next_NPC[23] = NPC[23];
    next_NPC[24] = NPC[24];
    next_NPC[25] = NPC[25];
    next_NPC[26] = NPC[26];
    next_NPC[27] = NPC[27];
    next_NPC[28] = NPC[28];
    next_NPC[29] = NPC[29];
    next_NPC[30] = NPC[30];
    next_NPC[31] = NPC[31];
    next_halt[0]  = halt[0];
    next_halt[1]  = halt[1];
    next_halt[2]  = halt[2];
    next_halt[3]  = halt[3];
    next_halt[4]  = halt[4];
    next_halt[5]  = halt[5];
    next_halt[6]  = halt[6];
    next_halt[7]  = halt[7];
    next_halt[8]  = halt[8];
    next_halt[9]  = halt[9];
    next_halt[10] = halt[10];
    next_halt[11] = halt[11];
    next_halt[12] = halt[12];
    next_halt[13] = halt[13];
    next_halt[14] = halt[14];
    next_halt[15] = halt[15];
    next_halt[16] = halt[16];
    next_halt[17] = halt[17];
    next_halt[18] = halt[18];
    next_halt[19] = halt[19];
    next_halt[20] = halt[20];
    next_halt[21] = halt[21];
    next_halt[22] = halt[22];
    next_halt[23] = halt[23];
    next_halt[24] = halt[24];
    next_halt[25] = halt[25];
    next_halt[26] = halt[26];
    next_halt[27] = halt[27];
    next_halt[28] = halt[28];
    next_halt[29] = halt[29];
    next_halt[30] = halt[30];
    next_halt[31] = halt[31];
    next_noop[0]  = noop[0];
    next_noop[1]  = noop[1];
    next_noop[2]  = noop[2];
    next_noop[3]  = noop[3];
    next_noop[4]  = noop[4];
    next_noop[5]  = noop[5];
    next_noop[6]  = noop[6];
    next_noop[7]  = noop[7];
    next_noop[8]  = noop[8];
    next_noop[9]  = noop[9];
    next_noop[10] = noop[10];
    next_noop[11] = noop[11];
    next_noop[12] = noop[12];
    next_noop[13] = noop[13];
    next_noop[14] = noop[14];
    next_noop[15] = noop[15];
    next_noop[16] = noop[16];
    next_noop[17] = noop[17];
    next_noop[18] = noop[18];
    next_noop[19] = noop[19];
    next_noop[20] = noop[20];
    next_noop[21] = noop[21];
    next_noop[22] = noop[22];
    next_noop[23] = noop[23];
    next_noop[24] = noop[24];
    next_noop[25] = noop[25];
    next_noop[26] = noop[26];
    next_noop[27] = noop[27];
    next_noop[28] = noop[28];
    next_noop[29] = noop[29];
    next_noop[30] = noop[30];
    next_noop[31] = noop[31];
    next_br[0]  = br[0];
    next_br[1]  = br[1];
    next_br[2]  = br[2];
    next_br[3]  = br[3];
    next_br[4]  = br[4];
    next_br[5]  = br[5];
    next_br[6]  = br[6];
    next_br[7]  = br[7];
    next_br[8]  = br[8];
    next_br[9]  = br[9];
    next_br[10] = br[10];
    next_br[11] = br[11];
    next_br[12] = br[12];
    next_br[13] = br[13];
    next_br[14] = br[14];
    next_br[15] = br[15];
    next_br[16] = br[16];
    next_br[17] = br[17];
    next_br[18] = br[18];
    next_br[19] = br[19];
    next_br[20] = br[20];
    next_br[21] = br[21];
    next_br[22] = br[22];
    next_br[23] = br[23];
    next_br[24] = br[24];
    next_br[25] = br[25];
    next_br[26] = br[26];
    next_br[27] = br[27];
    next_br[28] = br[28];
    next_br[29] = br[29];
    next_br[30] = br[30];
    next_br[31] = br[31];
    next_C[0]  = C[0];
    next_C[1]  = C[1];
    next_C[2]  = C[2];
    next_C[3]  = C[3];
    next_C[4]  = C[4];
    next_C[5]  = C[5];
    next_C[6]  = C[6];
    next_C[7]  = C[7];
    next_C[8]  = C[8];
    next_C[9]  = C[9];
    next_C[10] = C[10];
    next_C[11] = C[11];
    next_C[12] = C[12];
    next_C[13] = C[13];
    next_C[14] = C[14];
    next_C[15] = C[15];
    next_C[16] = C[16];
    next_C[17] = C[17];
    next_C[18] = C[18];
    next_C[19] = C[19];
    next_C[20] = C[20];
    next_C[21] = C[21];
    next_C[22] = C[22];
    next_C[23] = C[23];
    next_C[24] = C[24];
    next_C[25] = C[25];
    next_C[26] = C[26];
    next_C[27] = C[27];
    next_C[28] = C[28];
    next_C[29] = C[29];
    next_C[30] = C[30];
    next_C[31] = C[31];
    next_br_taken[0]  = br_taken[0];
    next_br_taken[1]  = br_taken[1];
    next_br_taken[2]  = br_taken[2];
    next_br_taken[3]  = br_taken[3];
    next_br_taken[4]  = br_taken[4];
    next_br_taken[5]  = br_taken[5];
    next_br_taken[6]  = br_taken[6];
    next_br_taken[7]  = br_taken[7];
    next_br_taken[8]  = br_taken[8];
    next_br_taken[9]  = br_taken[9];
    next_br_taken[10] = br_taken[10];
    next_br_taken[11] = br_taken[11];
    next_br_taken[12] = br_taken[12];
    next_br_taken[13] = br_taken[13];
    next_br_taken[14] = br_taken[14];
    next_br_taken[15] = br_taken[15];
    next_br_taken[16] = br_taken[16];
    next_br_taken[17] = br_taken[17];
    next_br_taken[18] = br_taken[18];
    next_br_taken[19] = br_taken[19];
    next_br_taken[20] = br_taken[20];
    next_br_taken[21] = br_taken[21];
    next_br_taken[22] = br_taken[22];
    next_br_taken[23] = br_taken[23];
    next_br_taken[24] = br_taken[24];
    next_br_taken[25] = br_taken[25];
    next_br_taken[26] = br_taken[26];
    next_br_taken[27] = br_taken[27];
    next_br_taken[28] = br_taken[28];
    next_br_taken[29] = br_taken[29];
    next_br_taken[30] = br_taken[30];
    next_br_taken[31] = br_taken[31];
    next_br_target_PC[0]  = br_target_PC[0];
    next_br_target_PC[1]  = br_target_PC[1];
    next_br_target_PC[2]  = br_target_PC[2];
    next_br_target_PC[3]  = br_target_PC[3];
    next_br_target_PC[4]  = br_target_PC[4];
    next_br_target_PC[5]  = br_target_PC[5];
    next_br_target_PC[6]  = br_target_PC[6];
    next_br_target_PC[7]  = br_target_PC[7];
    next_br_target_PC[8]  = br_target_PC[8];
    next_br_target_PC[9]  = br_target_PC[9];
    next_br_target_PC[10] = br_target_PC[10];
    next_br_target_PC[11] = br_target_PC[11];
    next_br_target_PC[12] = br_target_PC[12];
    next_br_target_PC[13] = br_target_PC[13];
    next_br_target_PC[14] = br_target_PC[14];
    next_br_target_PC[15] = br_target_PC[15];
    next_br_target_PC[16] = br_target_PC[16];
    next_br_target_PC[17] = br_target_PC[17];
    next_br_target_PC[18] = br_target_PC[18];
    next_br_target_PC[19] = br_target_PC[19];
    next_br_target_PC[20] = br_target_PC[20];
    next_br_target_PC[21] = br_target_PC[21];
    next_br_target_PC[22] = br_target_PC[22];
    next_br_target_PC[23] = br_target_PC[23];
    next_br_target_PC[24] = br_target_PC[24];
    next_br_target_PC[25] = br_target_PC[25];
    next_br_target_PC[26] = br_target_PC[26];
    next_br_target_PC[27] = br_target_PC[27];
    next_br_target_PC[28] = br_target_PC[28];
    next_br_target_PC[29] = br_target_PC[29];
    next_br_target_PC[30] = br_target_PC[30];
    next_br_target_PC[31] = br_target_PC[31];
    next_wb_data[0]  = wb_data[0];
    next_wb_data[1]  = wb_data[1];
    next_wb_data[2]  = wb_data[2];
    next_wb_data[3]  = wb_data[3];
    next_wb_data[4]  = wb_data[4];
    next_wb_data[5]  = wb_data[5];
    next_wb_data[6]  = wb_data[6];
    next_wb_data[7]  = wb_data[7];
    next_wb_data[8]  = wb_data[8];
    next_wb_data[9]  = wb_data[9];
    next_wb_data[10] = wb_data[10];
    next_wb_data[11] = wb_data[11];
    next_wb_data[12] = wb_data[12];
    next_wb_data[13] = wb_data[13];
    next_wb_data[14] = wb_data[14];
    next_wb_data[15] = wb_data[15];
    next_wb_data[16] = wb_data[16];
    next_wb_data[17] = wb_data[17];
    next_wb_data[18] = wb_data[18];
    next_wb_data[19] = wb_data[19];
    next_wb_data[20] = wb_data[20];
    next_wb_data[21] = wb_data[21];
    next_wb_data[22] = wb_data[22];
    next_wb_data[23] = wb_data[23];
    next_wb_data[24] = wb_data[24];
    next_wb_data[25] = wb_data[25];
    next_wb_data[26] = wb_data[26];
    next_wb_data[27] = wb_data[27];
    next_wb_data[28] = wb_data[28];
    next_wb_data[29] = wb_data[29];
    next_wb_data[30] = wb_data[30];
    next_wb_data[31] = wb_data[31];

    if(C_wr_en_1 && T[0]==C_tag_1) begin
      next_C[0]         = 1'd1;
      next_wb_data[0]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[0]==C_tag_2) begin
      next_C[0]         = 1'd1;
      next_wb_data[0]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[0]==X_br_marker_1) begin
      next_C[0]         = T[0]==`ZERO_REG;
      next_br_taken[0]  = X_br_taken_1;
      next_br_target_PC[0] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[0]==X_br_marker_2) begin
      next_C[0]         = T[0]==`ZERO_REG;
      next_br_taken[0]  = X_br_taken_2;
      next_br_target_PC[0] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[1]==C_tag_1) begin
      next_C[1]         = 1'd1;
      next_wb_data[1]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[1]==C_tag_2) begin
      next_C[1]         = 1'd1;
      next_wb_data[1]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[1]==X_br_marker_1) begin
      next_C[1]         = T[1]==`ZERO_REG;
      next_br_taken[1]  = X_br_taken_1;
      next_br_target_PC[1] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[1]==X_br_marker_2) begin
      next_C[1]         = T[1]==`ZERO_REG;
      next_br_taken[1]  = X_br_taken_2;
      next_br_target_PC[1] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[2]==C_tag_1) begin
      next_C[2]         = 1'd1;
      next_wb_data[2]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[2]==C_tag_2) begin
      next_C[2]         = 1'd1;
      next_wb_data[2]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[2]==X_br_marker_1) begin
      next_C[2]         = T[2]==`ZERO_REG;
      next_br_taken[2]  = X_br_taken_1;
      next_br_target_PC[2] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[2]==X_br_marker_2) begin
      next_C[2]         = T[2]==`ZERO_REG;
      next_br_taken[2]  = X_br_taken_2;
      next_br_target_PC[2] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[3]==C_tag_1) begin
      next_C[3]         = 1'd1;
      next_wb_data[3]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[3]==C_tag_2) begin
      next_C[3]         = 1'd1;
      next_wb_data[3]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[3]==X_br_marker_1) begin
      next_C[3]         = T[3]==`ZERO_REG;
      next_br_taken[3]  = X_br_taken_1;
      next_br_target_PC[3] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[3]==X_br_marker_2) begin
      next_C[3]         = T[3]==`ZERO_REG;
      next_br_taken[3]  = X_br_taken_2;
      next_br_target_PC[3] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[4]==C_tag_1) begin
      next_C[4]         = 1'd1;
      next_wb_data[4]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[4]==C_tag_2) begin
      next_C[4]         = 1'd1;
      next_wb_data[4]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[4]==X_br_marker_1) begin
      next_C[4]         = T[4]==`ZERO_REG;
      next_br_taken[4]  = X_br_taken_1;
      next_br_target_PC[4] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[4]==X_br_marker_2) begin
      next_C[4]         = T[4]==`ZERO_REG;
      next_br_taken[4]  = X_br_taken_2;
      next_br_target_PC[4] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[5]==C_tag_1) begin
      next_C[5]         = 1'd1;
      next_wb_data[5]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[5]==C_tag_2) begin
      next_C[5]         = 1'd1;
      next_wb_data[5]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[5]==X_br_marker_1) begin
      next_C[5]         = T[5]==`ZERO_REG;
      next_br_taken[5]  = X_br_taken_1;
      next_br_target_PC[5] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[5]==X_br_marker_2) begin
      next_C[5]         = T[5]==`ZERO_REG;
      next_br_taken[5]  = X_br_taken_2;
      next_br_target_PC[5] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[6]==C_tag_1) begin
      next_C[6]         = 1'd1;
      next_wb_data[6]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[6]==C_tag_2) begin
      next_C[6]         = 1'd1;
      next_wb_data[6]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[6]==X_br_marker_1) begin
      next_C[6]         = T[6]==`ZERO_REG;
      next_br_taken[6]  = X_br_taken_1;
      next_br_target_PC[6] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[6]==X_br_marker_2) begin
      next_C[6]         = T[6]==`ZERO_REG;
      next_br_taken[6]  = X_br_taken_2;
      next_br_target_PC[6] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[7]==C_tag_1) begin
      next_C[7]         = 1'd1;
      next_wb_data[7]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[7]==C_tag_2) begin
      next_C[7]         = 1'd1;
      next_wb_data[7]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[7]==X_br_marker_1) begin
      next_C[7]         = T[7]==`ZERO_REG;
      next_br_taken[7]  = X_br_taken_1;
      next_br_target_PC[7] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[7]==X_br_marker_2) begin
      next_C[7]         = T[7]==`ZERO_REG;
      next_br_taken[7]  = X_br_taken_2;
      next_br_target_PC[7] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[8]==C_tag_1) begin
      next_C[8]         = 1'd1;
      next_wb_data[8]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[8]==C_tag_2) begin
      next_C[8]         = 1'd1;
      next_wb_data[8]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[8]==X_br_marker_1) begin
      next_C[8]         = T[8]==`ZERO_REG;
      next_br_taken[8]  = X_br_taken_1;
      next_br_target_PC[8] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[8]==X_br_marker_2) begin
      next_C[8]         = T[8]==`ZERO_REG;
      next_br_taken[8]  = X_br_taken_2;
      next_br_target_PC[8] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[9]==C_tag_1) begin
      next_C[9]         = 1'd1;
      next_wb_data[9]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[9]==C_tag_2) begin
      next_C[9]         = 1'd1;
      next_wb_data[9]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[9]==X_br_marker_1) begin
      next_C[9]         = T[9]==`ZERO_REG;
      next_br_taken[9]  = X_br_taken_1;
      next_br_target_PC[9] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[9]==X_br_marker_2) begin
      next_C[9]         = T[9]==`ZERO_REG;
      next_br_taken[9]  = X_br_taken_2;
      next_br_target_PC[9] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[10]==C_tag_1) begin
      next_C[10]         = 1'd1;
      next_wb_data[10]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[10]==C_tag_2) begin
      next_C[10]         = 1'd1;
      next_wb_data[10]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[10]==X_br_marker_1) begin
      next_C[10]         = T[10]==`ZERO_REG;
      next_br_taken[10]  = X_br_taken_1;
      next_br_target_PC[10] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[10]==X_br_marker_2) begin
      next_C[10]         = T[10]==`ZERO_REG;
      next_br_taken[10]  = X_br_taken_2;
      next_br_target_PC[10] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[11]==C_tag_1) begin
      next_C[11]         = 1'd1;
      next_wb_data[11]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[11]==C_tag_2) begin
      next_C[11]         = 1'd1;
      next_wb_data[11]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[11]==X_br_marker_1) begin
      next_C[11]         = T[11]==`ZERO_REG;
      next_br_taken[11]  = X_br_taken_1;
      next_br_target_PC[11] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[11]==X_br_marker_2) begin
      next_C[11]         = T[11]==`ZERO_REG;
      next_br_taken[11]  = X_br_taken_2;
      next_br_target_PC[11] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[12]==C_tag_1) begin
      next_C[12]         = 1'd1;
      next_wb_data[12]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[12]==C_tag_2) begin
      next_C[12]         = 1'd1;
      next_wb_data[12]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[12]==X_br_marker_1) begin
      next_C[12]         = T[12]==`ZERO_REG;
      next_br_taken[12]  = X_br_taken_1;
      next_br_target_PC[12] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[12]==X_br_marker_2) begin
      next_C[12]         = T[12]==`ZERO_REG;
      next_br_taken[12]  = X_br_taken_2;
      next_br_target_PC[12] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[13]==C_tag_1) begin
      next_C[13]         = 1'd1;
      next_wb_data[13]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[13]==C_tag_2) begin
      next_C[13]         = 1'd1;
      next_wb_data[13]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[13]==X_br_marker_1) begin
      next_C[13]         = T[13]==`ZERO_REG;
      next_br_taken[13]  = X_br_taken_1;
      next_br_target_PC[13] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[13]==X_br_marker_2) begin
      next_C[13]         = T[13]==`ZERO_REG;
      next_br_taken[13]  = X_br_taken_2;
      next_br_target_PC[13] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[14]==C_tag_1) begin
      next_C[14]         = 1'd1;
      next_wb_data[14]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[14]==C_tag_2) begin
      next_C[14]         = 1'd1;
      next_wb_data[14]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[14]==X_br_marker_1) begin
      next_C[14]         = T[14]==`ZERO_REG;
      next_br_taken[14]  = X_br_taken_1;
      next_br_target_PC[14] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[14]==X_br_marker_2) begin
      next_C[14]         = T[14]==`ZERO_REG;
      next_br_taken[14]  = X_br_taken_2;
      next_br_target_PC[14] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[15]==C_tag_1) begin
      next_C[15]         = 1'd1;
      next_wb_data[15]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[15]==C_tag_2) begin
      next_C[15]         = 1'd1;
      next_wb_data[15]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[15]==X_br_marker_1) begin
      next_C[15]         = T[15]==`ZERO_REG;
      next_br_taken[15]  = X_br_taken_1;
      next_br_target_PC[15] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[15]==X_br_marker_2) begin
      next_C[15]         = T[15]==`ZERO_REG;
      next_br_taken[15]  = X_br_taken_2;
      next_br_target_PC[15] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[16]==C_tag_1) begin
      next_C[16]         = 1'd1;
      next_wb_data[16]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[16]==C_tag_2) begin
      next_C[16]         = 1'd1;
      next_wb_data[16]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[16]==X_br_marker_1) begin
      next_C[16]         = T[16]==`ZERO_REG;
      next_br_taken[16]  = X_br_taken_1;
      next_br_target_PC[16] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[16]==X_br_marker_2) begin
      next_C[16]         = T[16]==`ZERO_REG;
      next_br_taken[16]  = X_br_taken_2;
      next_br_target_PC[16] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[17]==C_tag_1) begin
      next_C[17]         = 1'd1;
      next_wb_data[17]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[17]==C_tag_2) begin
      next_C[17]         = 1'd1;
      next_wb_data[17]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[17]==X_br_marker_1) begin
      next_C[17]         = T[17]==`ZERO_REG;
      next_br_taken[17]  = X_br_taken_1;
      next_br_target_PC[17] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[17]==X_br_marker_2) begin
      next_C[17]         = T[17]==`ZERO_REG;
      next_br_taken[17]  = X_br_taken_2;
      next_br_target_PC[17] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[18]==C_tag_1) begin
      next_C[18]         = 1'd1;
      next_wb_data[18]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[18]==C_tag_2) begin
      next_C[18]         = 1'd1;
      next_wb_data[18]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[18]==X_br_marker_1) begin
      next_C[18]         = T[18]==`ZERO_REG;
      next_br_taken[18]  = X_br_taken_1;
      next_br_target_PC[18] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[18]==X_br_marker_2) begin
      next_C[18]         = T[18]==`ZERO_REG;
      next_br_taken[18]  = X_br_taken_2;
      next_br_target_PC[18] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[19]==C_tag_1) begin
      next_C[19]         = 1'd1;
      next_wb_data[19]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[19]==C_tag_2) begin
      next_C[19]         = 1'd1;
      next_wb_data[19]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[19]==X_br_marker_1) begin
      next_C[19]         = T[19]==`ZERO_REG;
      next_br_taken[19]  = X_br_taken_1;
      next_br_target_PC[19] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[19]==X_br_marker_2) begin
      next_C[19]         = T[19]==`ZERO_REG;
      next_br_taken[19]  = X_br_taken_2;
      next_br_target_PC[19] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[20]==C_tag_1) begin
      next_C[20]         = 1'd1;
      next_wb_data[20]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[20]==C_tag_2) begin
      next_C[20]         = 1'd1;
      next_wb_data[20]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[20]==X_br_marker_1) begin
      next_C[20]         = T[20]==`ZERO_REG;
      next_br_taken[20]  = X_br_taken_1;
      next_br_target_PC[20] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[20]==X_br_marker_2) begin
      next_C[20]         = T[20]==`ZERO_REG;
      next_br_taken[20]  = X_br_taken_2;
      next_br_target_PC[20] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[21]==C_tag_1) begin
     next_C[21]         = 1'd1;
      next_wb_data[21]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[21]==C_tag_2) begin
      next_C[21]         = 1'd1;
      next_wb_data[21]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[21]==X_br_marker_1) begin
      next_C[21]         = T[21]==`ZERO_REG;
      next_br_taken[21]  = X_br_taken_1;
      next_br_target_PC[21] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[21]==X_br_marker_2) begin
      next_C[21]         = T[21]==`ZERO_REG;
      next_br_taken[21]  = X_br_taken_2;
      next_br_target_PC[21] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[22]==C_tag_1) begin
      next_C[22]         = 1'd1;
      next_wb_data[22]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[22]==C_tag_2) begin
      next_C[22]         = 1'd1;
      next_wb_data[22]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[22]==X_br_marker_1) begin
      next_C[22]         = T[22]==`ZERO_REG;
      next_br_taken[22]  = X_br_taken_1;
      next_br_target_PC[22] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[22]==X_br_marker_2) begin
      next_C[22]         = T[22]==`ZERO_REG;
      next_br_taken[22]  = X_br_taken_2;
      next_br_target_PC[22] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[23]==C_tag_1) begin
      next_C[23]         = 1'd1;
      next_wb_data[23]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[23]==C_tag_2) begin
      next_C[23]         = 1'd1;
      next_wb_data[23]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[23]==X_br_marker_1) begin
      next_C[23]         = T[23]==`ZERO_REG;
      next_br_taken[23]  = X_br_taken_1;
      next_br_target_PC[23] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[23]==X_br_marker_2) begin
      next_C[23]         = T[23]==`ZERO_REG;
      next_br_taken[23]  = X_br_taken_2;
      next_br_target_PC[23] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[24]==C_tag_1) begin
      next_C[24]         = 1'd1;
      next_wb_data[24]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[24]==C_tag_2) begin
      next_C[24]         = 1'd1;
      next_wb_data[24]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[24]==X_br_marker_1) begin
      next_C[24]         = T[24]==`ZERO_REG;
      next_br_taken[24]  = X_br_taken_1;
      next_br_target_PC[24] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[24]==X_br_marker_2) begin
      next_C[24]         = T[24]==`ZERO_REG;
      next_br_taken[24]  = X_br_taken_2;
      next_br_target_PC[24] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[25]==C_tag_1) begin
      next_C[25]         = 1'd1;
      next_wb_data[25]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[25]==C_tag_2) begin
      next_C[25]         = 1'd1;
      next_wb_data[25]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[25]==X_br_marker_1) begin
      next_C[25]         = T[25]==`ZERO_REG;
      next_br_taken[25]  = X_br_taken_1;
      next_br_target_PC[25] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[25]==X_br_marker_2) begin
      next_C[25]         = T[25]==`ZERO_REG;
      next_br_taken[25]  = X_br_taken_2;
      next_br_target_PC[25] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[26]==C_tag_1) begin
      next_C[26]         = 1'd1;
      next_wb_data[26]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[26]==C_tag_2) begin
      next_C[26]         = 1'd1;
      next_wb_data[26]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[26]==X_br_marker_1) begin
      next_C[26]         = T[26]==`ZERO_REG;;
      next_br_taken[26]  = X_br_taken_1;
      next_br_target_PC[26] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[26]==X_br_marker_2) begin
      next_C[26]         = T[26]==`ZERO_REG;
      next_br_taken[26]  = X_br_taken_2;
      next_br_target_PC[26] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[27]==C_tag_1) begin
      next_C[27]         = 1'd1;
      next_wb_data[27]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[27]==C_tag_2) begin
      next_C[27]         = 1'd1;
      next_wb_data[27]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[27]==X_br_marker_1) begin
      next_C[27]         = T[27]==`ZERO_REG;
      next_br_taken[27]  = X_br_taken_1;
      next_br_target_PC[27] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[27]==X_br_marker_2) begin
      next_C[27]         = T[27]==`ZERO_REG;
      next_br_taken[27]  = X_br_taken_2;
      next_br_target_PC[27] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[28]==C_tag_1) begin
      next_C[28]         = 1'd1;
      next_wb_data[28]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[28]==C_tag_2) begin
      next_C[28]         = 1'd1;
      next_wb_data[28]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[28]==X_br_marker_1) begin
      next_C[28]         = T[28]==`ZERO_REG;
      next_br_taken[28]  = X_br_taken_1;
      next_br_target_PC[28] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[28]==X_br_marker_2) begin
      next_C[28]         = T[28]==`ZERO_REG;
      next_br_taken[28]  = X_br_taken_2;
      next_br_target_PC[28] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[29]==C_tag_1) begin
      next_C[29]         = 1'd1;
      next_wb_data[29]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[29]==C_tag_2) begin
      next_C[29]         = 1'd1;
      next_wb_data[29]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[29]==X_br_marker_1) begin
      next_C[29]         = T[29]==`ZERO_REG;
      next_br_taken[29]  = X_br_taken_1;
      next_br_target_PC[29] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[29]==X_br_marker_2) begin
      next_C[29]         = T[29]==`ZERO_REG;
      next_br_taken[29]  = X_br_taken_2;
      next_br_target_PC[29] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[30]==C_tag_1) begin
      next_C[30]         = 1'd1;
      next_wb_data[30]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[30]==C_tag_2) begin
      next_C[30]         = 1'd1;
      next_wb_data[30]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[30]==X_br_marker_1) begin
      next_C[30]         = T[30]==`ZERO_REG;
      next_br_taken[30]  = X_br_taken_1;
      next_br_target_PC[30] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[30]==X_br_marker_2) begin
      next_C[30]         = T[30]==`ZERO_REG;
      next_br_taken[30]  = X_br_taken_2;
      next_br_target_PC[30] = X_br_target_PC_2;
    end

    if(C_wr_en_1 && T[31]==C_tag_1) begin
      next_C[31]         = 1'd1;
      next_wb_data[31]   = C_wb_data_1;
    end
    else if(C_wr_en_2 && T[31]==C_tag_2) begin
      next_C[31]         = 1'd1;
      next_wb_data[31]   = C_wb_data_2;
    end
    else if(X_br_wr_en_1 && br_marker[31]==X_br_marker_1) begin
      next_C[31]         = T[31]==`ZERO_REG;
      next_br_taken[31]  = X_br_taken_1;
      next_br_target_PC[31] = X_br_target_PC_1;
    end
    else if(X_br_wr_en_2 && br_marker[31]==X_br_marker_2) begin
      next_C[31]         = T[31]==`ZERO_REG;
      next_br_taken[31]  = X_br_taken_2;
      next_br_target_PC[31] = X_br_target_PC_2;
    end

    // Write in data
    if(h==t) begin
      if(T_wr_en_2 && T_wr_en_1) begin
        next_T[h[4:0]]                        = T_in_1;
        next_T[h_plus_1[4:0]]                 = T_in_2;
        next_Told[h[4:0]]                     = Told_in_1;
        next_Told[h_plus_1[4:0]]              = Told_in_2;
        next_wr_mem[h[4:0]]                   = id_wr_mem_in_1;
        next_wr_mem[h_plus_1[4:0]]            = id_wr_mem_in_2;
        next_rd_mem[h[4:0]]                   = id_rd_mem_in_1;
        next_rd_mem[h_plus_1[4:0]]            = id_rd_mem_in_2;
        next_br_marker[h[4:0]]                = br_marker_in_1;
        next_br_marker[h_plus_1[4:0]]         = br_marker_in_2;
        next_NPC[h[4:0]]                      = NPC_1;
        next_NPC[h_plus_1[4:0]]               = NPC_2;
        next_halt[h[4:0]]                     = id_halt_in_1;
        next_halt[h_plus_1[4:0]]              = id_halt_in_2;
        next_noop[h[4:0]]                     = id_noop_in_1;
        next_noop[h_plus_1[4:0]]              = id_noop_in_2;
        next_br[h[4:0]]                       = id_br_in_1;
        next_br[h_plus_1[4:0]]                = id_br_in_2;
        next_C[h[4:0]]                        = 1'b0;
        next_C[h_plus_1[4:0]]                 = 1'b0;
        next_br_taken[h[4:0]]                 = 1'b0;
        next_br_taken[h_plus_1[4:0]]          = 1'b0;
        next_br_target_PC[h[4:0]]             = 64'd0;
        next_br_target_PC[h_plus_1[4:0]]      = 64'd0;
        next_wb_data[h[4:0]]                  = 64'd0;
        next_wb_data[h_plus_1[4:0]]           = 64'd0;
      end
      else if(T_wr_en_1) begin
        next_T[h[4:0]]                        = T_in_1;
        next_Told[h[4:0]]                     = Told_in_1;
        next_wr_mem[h[4:0]]                   = id_wr_mem_in_1;
        next_rd_mem[h[4:0]]                   = id_rd_mem_in_1;
        next_br_marker[h[4:0]]                = br_marker_in_1;
        next_NPC[h[4:0]]                      = NPC_1;
        next_halt[h[4:0]]                     = id_halt_in_1;
        next_noop[h[4:0]]                     = id_noop_in_1;
        next_br[h[4:0]]                       = id_br_in_1;
        next_C[h[4:0]]                        = 0;
        next_br_taken[h[4:0]]                 = 0;
        next_br_target_PC[h[4:0]]             = 0;
        next_wb_data[h[4:0]]                  = 0;
      end
      else if(T_wr_en_2) begin
        next_T[h[4:0]]                        = T_in_2;
        next_Told[h[4:0]]                     = Told_in_2;
        next_wr_mem[h[4:0]]                   = id_wr_mem_in_2;
        next_rd_mem[h[4:0]]                   = id_rd_mem_in_2;
        next_br_marker[h[4:0]]                = br_marker_in_2;
        next_NPC[h[4:0]]                      = NPC_2;
        next_halt[h[4:0]]                     = id_halt_in_2;
        next_noop[h[4:0]]                     = id_noop_in_2;
        next_br[h[4:0]]                       = id_br_in_2;
        next_C[h[4:0]]                        = 1'b0;
        next_br_taken[h[4:0]]                 = 1'b0;
        next_br_target_PC[h[4:0]]             = 64'd0;
        next_wb_data[h[4:0]]                  = 64'd0;
      end
    end
    else begin
      if(T_wr_en_2 && T_wr_en_1) begin
        next_T[t[4:0]]                        = T_in_1;
        next_T[t_plus_1[4:0]]                 = T_in_2;
        next_Told[t[4:0]]                     = Told_in_1;
        next_Told[t_plus_1[4:0]]              = Told_in_2;
        next_wr_mem[t[4:0]]                   = id_wr_mem_in_1;
        next_wr_mem[t_plus_1[4:0]]            = id_wr_mem_in_2;
        next_rd_mem[t[4:0]]                   = id_rd_mem_in_1;
        next_rd_mem[t_plus_1[4:0]]            = id_rd_mem_in_2;
        next_br_marker[t[4:0]]                = br_marker_in_1;
        next_br_marker[t_plus_1[4:0]]         = br_marker_in_2;
        next_NPC[t[4:0]]                      = NPC_1;
        next_NPC[t_plus_1[4:0]]               = NPC_2;
        next_halt[t[4:0]]                     = id_halt_in_1;
        next_halt[t_plus_1[4:0]]              = id_halt_in_2;
        next_noop[t[4:0]]                     = id_noop_in_1;
        next_noop[t_plus_1[4:0]]              = id_noop_in_2;
        next_br[t[4:0]]                       = id_br_in_1;
        next_br[t_plus_1[4:0]]                = id_br_in_2;
        next_C[t[4:0]]                        = 1'b0;
        next_C[t_plus_1[4:0]]                 = 1'b0;
        next_br_taken[t[4:0]]                 = 1'b0;
        next_br_taken[t_plus_1[4:0]]          = 1'b0;
        next_br_target_PC[t[4:0]]             = 64'd0;
        next_br_target_PC[t_plus_1[4:0]]      = 64'd0;
        next_wb_data[t[4:0]]                  = 64'd0;
        next_wb_data[t_plus_1[4:0]]           = 64'd0;
      end
      else if(T_wr_en_1) begin
        next_T[t[4:0]]                        = T_in_1;
        next_Told[t[4:0]]                     = Told_in_1;
        next_wr_mem[t[4:0]]                   = id_wr_mem_in_1;
        next_rd_mem[t[4:0]]                   = id_rd_mem_in_1;
        next_br_marker[t[4:0]]                = br_marker_in_1;
        next_NPC[t[4:0]]                      = NPC_1;
        next_halt[t[4:0]]                     = id_halt_in_1;
        next_noop[t[4:0]]                     = id_noop_in_1;
        next_br[t[4:0]]                       = id_br_in_1;
        next_C[t[4:0]]                        = 1'b0;
        next_br_taken[t[4:0]]                 = 1'b0;
        next_br_target_PC[t[4:0]]             = 64'd0;
        next_wb_data[t[4:0]]                  = 64'd0;
      end
      else if(T_wr_en_2) begin
        next_T[t[4:0]]                        = T_in_2;
        next_Told[t[4:0]]                     = Told_in_2;
        next_wr_mem[t[4:0]]                   = id_wr_mem_in_2;
        next_rd_mem[t[4:0]]                   = id_rd_mem_in_2;
        next_br_marker[t[4:0]]                = br_marker_in_2;
        next_NPC[t[4:0]]                      = NPC_2;
        next_halt[t[4:0]]                     = id_halt_in_2;
        next_noop[t[4:0]]                     = id_noop_in_2;
        next_br[t[4:0]]                       = id_br_in_2;
        next_C[t[4:0]]                        = 1'b0;
        next_br_taken[t[4:0]]                 = 1'b0;
        next_br_target_PC[t[4:0]]             = 64'd0;
        next_wb_data[t[4:0]]                  = 64'd0;
      end
    end
  end
  // Retire
  always @*
  begin
    next_T_out_1          = 6'd0;
    next_T_out_2          = 6'd0;
    next_Told_out_1       = 6'd0;
    next_Told_out_2       = 6'd0;
    next_T_valid_1        = 1'b0;
    next_T_valid_2        = 1'b0;
    next_NPC_out_1        = 64'd0;
    next_NPC_out_2        = 64'd0;
    next_wb_data_out_1    = 64'd0;
    next_wb_data_out_2    = 64'd0;
    if(retire_two) begin
      next_T_out_1        = T[h[4:0]];
      next_T_out_2        = T[h_plus_1[4:0]];
      next_Told_out_1     = Told[h[4:0]];
      next_Told_out_2     = Told[h_plus_1[4:0]];
      next_T_valid_1      = 1'd1;
      next_T_valid_2      = 1'd1;
      next_NPC_out_1      = NPC[h[4:0]];
      next_NPC_out_2      = NPC[h_plus_1[4:0]];
      next_wb_data_out_1  = wb_data[h[4:0]];
      next_wb_data_out_2  = wb_data[h_plus_1[4:0]];
    end
    else if(retire_one) begin
      next_T_out_1        = T[h[4:0]];
      next_T_out_2        = `ZERO_REG;
      next_Told_out_1     = Told[h[4:0]];
      next_Told_out_2     = `ZERO_REG;
      next_T_valid_1      = 1'd1;
      next_T_valid_2      = 1'd0;
      next_NPC_out_1      = NPC[h[4:0]];
      next_NPC_out_2      = 64'd0;
      next_wb_data_out_1  = wb_data[h[4:0]];
      next_wb_data_out_2  = 64'd0;
    end
  end

  //////////////////////////////////////////////////
  //                                              //
  //               current state                  //
  //                                              //
  //////////////////////////////////////////////////
  always @(posedge clock)
  begin
    if (reset) begin
      h             <= `SD 6'd0;
      t             <= `SD 6'd0;
      T[0]          <= `SD `ZERO_REG;
      T[1]          <= `SD `ZERO_REG;
      T[2]          <= `SD `ZERO_REG;
      T[3]          <= `SD `ZERO_REG;
      T[4]          <= `SD `ZERO_REG;
      T[5]          <= `SD `ZERO_REG;
      T[6]          <= `SD `ZERO_REG;
      T[7]          <= `SD `ZERO_REG;
      T[8]          <= `SD `ZERO_REG;
      T[9]          <= `SD `ZERO_REG;
      T[10]         <= `SD `ZERO_REG;
      T[11]         <= `SD `ZERO_REG;
      T[12]         <= `SD `ZERO_REG;
      T[13]         <= `SD `ZERO_REG;
      T[14]         <= `SD `ZERO_REG;
      T[15]         <= `SD `ZERO_REG;
      T[16]         <= `SD `ZERO_REG;
      T[17]         <= `SD `ZERO_REG;
      T[18]         <= `SD `ZERO_REG;
      T[19]         <= `SD `ZERO_REG;
      T[20]         <= `SD `ZERO_REG;
      T[21]         <= `SD `ZERO_REG;
      T[22]         <= `SD `ZERO_REG;
      T[23]         <= `SD `ZERO_REG;
      T[24]         <= `SD `ZERO_REG;
      T[25]         <= `SD `ZERO_REG;
      T[26]         <= `SD `ZERO_REG;
      T[27]         <= `SD `ZERO_REG;
      T[28]         <= `SD `ZERO_REG;
      T[29]         <= `SD `ZERO_REG;
      T[30]         <= `SD `ZERO_REG;
      T[31]         <= `SD `ZERO_REG;
      Told[0]       <= `SD `ZERO_REG;
      Told[1]       <= `SD `ZERO_REG;
      Told[2]       <= `SD `ZERO_REG;
      Told[3]       <= `SD `ZERO_REG;
      Told[4]       <= `SD `ZERO_REG;
      Told[5]       <= `SD `ZERO_REG;
      Told[6]       <= `SD `ZERO_REG;
      Told[7]       <= `SD `ZERO_REG;
      Told[8]       <= `SD `ZERO_REG;
      Told[9]       <= `SD `ZERO_REG;
      Told[10]      <= `SD `ZERO_REG;
      Told[11]      <= `SD `ZERO_REG;
      Told[12]      <= `SD `ZERO_REG;
      Told[13]      <= `SD `ZERO_REG;
      Told[14]      <= `SD `ZERO_REG;
      Told[15]      <= `SD `ZERO_REG;
      Told[16]      <= `SD `ZERO_REG;
      Told[17]      <= `SD `ZERO_REG;
      Told[18]      <= `SD `ZERO_REG;
      Told[19]      <= `SD `ZERO_REG;
      Told[20]      <= `SD `ZERO_REG;
      Told[21]      <= `SD `ZERO_REG;
      Told[22]      <= `SD `ZERO_REG;
      Told[23]      <= `SD `ZERO_REG;
      Told[24]      <= `SD `ZERO_REG;
      Told[25]      <= `SD `ZERO_REG;
      Told[26]      <= `SD `ZERO_REG;
      Told[27]      <= `SD `ZERO_REG;
      Told[28]      <= `SD `ZERO_REG;
      Told[29]      <= `SD `ZERO_REG;
      Told[30]      <= `SD `ZERO_REG;
      Told[31]      <= `SD `ZERO_REG;
      C[0]          <= `SD 1'b0;
      C[1]          <= `SD 1'b0;
      C[2]          <= `SD 1'b0;
      C[3]          <= `SD 1'b0;
      C[4]          <= `SD 1'b0;
      C[5]          <= `SD 1'b0;
      C[6]          <= `SD 1'b0;
      C[7]          <= `SD 1'b0;
      C[8]          <= `SD 1'b0;
      C[9]          <= `SD 1'b0;
      C[10]         <= `SD 1'b0;
      C[11]         <= `SD 1'b0;
      C[12]         <= `SD 1'b0;
      C[13]         <= `SD 1'b0;
      C[14]         <= `SD 1'b0;
      C[15]         <= `SD 1'b0;
      C[16]         <= `SD 1'b0;
      C[17]         <= `SD 1'b0;
      C[18]         <= `SD 1'b0;
      C[19]         <= `SD 1'b0;
      C[20]         <= `SD 1'b0;
      C[21]         <= `SD 1'b0;
      C[22]         <= `SD 1'b0;
      C[23]         <= `SD 1'b0;
      C[24]         <= `SD 1'b0;
      C[25]         <= `SD 1'b0;
      C[26]         <= `SD 1'b0;
      C[27]         <= `SD 1'b0;
      C[28]         <= `SD 1'b0;
      C[29]         <= `SD 1'b0;
      C[30]         <= `SD 1'b0;
      C[31]         <= `SD 1'b0;
      wr_mem[0]     <= `SD 1'b0;
      wr_mem[1]     <= `SD 1'b0;
      wr_mem[2]     <= `SD 1'b0;
      wr_mem[3]     <= `SD 1'b0;
      wr_mem[4]     <= `SD 1'b0;
      wr_mem[5]     <= `SD 1'b0;
      wr_mem[6]     <= `SD 1'b0;
      wr_mem[7]     <= `SD 1'b0;
      wr_mem[8]     <= `SD 1'b0;
      wr_mem[9]     <= `SD 1'b0;
      wr_mem[10]    <= `SD 1'b0;
      wr_mem[11]    <= `SD 1'b0;
      wr_mem[12]    <= `SD 1'b0;
      wr_mem[13]    <= `SD 1'b0;
      wr_mem[14]    <= `SD 1'b0;
      wr_mem[15]    <= `SD 1'b0;
      wr_mem[16]    <= `SD 1'b0;
      wr_mem[17]    <= `SD 1'b0;
      wr_mem[18]    <= `SD 1'b0;
      wr_mem[19]    <= `SD 1'b0;
      wr_mem[20]    <= `SD 1'b0;
      wr_mem[21]    <= `SD 1'b0;
      wr_mem[22]    <= `SD 1'b0;
      wr_mem[23]    <= `SD 1'b0;
      wr_mem[24]    <= `SD 1'b0;
      wr_mem[25]    <= `SD 1'b0;
      wr_mem[26]    <= `SD 1'b0;
      wr_mem[27]    <= `SD 1'b0;
      wr_mem[28]    <= `SD 1'b0;
      wr_mem[29]    <= `SD 1'b0;
      wr_mem[30]    <= `SD 1'b0;
      wr_mem[31]    <= `SD 1'b0;
      rd_mem[0]     <= `SD 1'b0;
      rd_mem[1]     <= `SD 1'b0;
      rd_mem[2]     <= `SD 1'b0;
      rd_mem[3]     <= `SD 1'b0;
      rd_mem[4]     <= `SD 1'b0;
      rd_mem[5]     <= `SD 1'b0;
      rd_mem[6]     <= `SD 1'b0;
      rd_mem[7]     <= `SD 1'b0;
      rd_mem[8]     <= `SD 1'b0;
      rd_mem[9]     <= `SD 1'b0;
      rd_mem[10]    <= `SD 1'b0;
      rd_mem[11]    <= `SD 1'b0;
      rd_mem[12]    <= `SD 1'b0;
      rd_mem[13]    <= `SD 1'b0;
      rd_mem[14]    <= `SD 1'b0;
      rd_mem[15]    <= `SD 1'b0;
      rd_mem[16]    <= `SD 1'b0;
      rd_mem[17]    <= `SD 1'b0;
      rd_mem[18]    <= `SD 1'b0;
      rd_mem[19]    <= `SD 1'b0;
      rd_mem[20]    <= `SD 1'b0;
      rd_mem[21]    <= `SD 1'b0;
      rd_mem[22]    <= `SD 1'b0;
      rd_mem[23]    <= `SD 1'b0;
      rd_mem[24]    <= `SD 1'b0;
      rd_mem[25]    <= `SD 1'b0;
      rd_mem[26]    <= `SD 1'b0;
      rd_mem[27]    <= `SD 1'b0;
      rd_mem[28]    <= `SD 1'b0;
      rd_mem[29]    <= `SD 1'b0;
      rd_mem[30]    <= `SD 1'b0;
      rd_mem[31]    <= `SD 1'b0;
      br_marker[0]  <= `SD `BR_MARKER_EMPTY;
      br_marker[1]  <= `SD `BR_MARKER_EMPTY;
      br_marker[2]  <= `SD `BR_MARKER_EMPTY;
      br_marker[3]  <= `SD `BR_MARKER_EMPTY;
      br_marker[4]  <= `SD `BR_MARKER_EMPTY;
      br_marker[5]  <= `SD `BR_MARKER_EMPTY;
      br_marker[6]  <= `SD `BR_MARKER_EMPTY;
      br_marker[7]  <= `SD `BR_MARKER_EMPTY;
      br_marker[8]  <= `SD `BR_MARKER_EMPTY;
      br_marker[9]  <= `SD `BR_MARKER_EMPTY;
      br_marker[10] <= `SD `BR_MARKER_EMPTY;
      br_marker[11] <= `SD `BR_MARKER_EMPTY;
      br_marker[12] <= `SD `BR_MARKER_EMPTY;
      br_marker[13] <= `SD `BR_MARKER_EMPTY;
      br_marker[14] <= `SD `BR_MARKER_EMPTY;
      br_marker[15] <= `SD `BR_MARKER_EMPTY;
      br_marker[16] <= `SD `BR_MARKER_EMPTY;
      br_marker[17] <= `SD `BR_MARKER_EMPTY;
      br_marker[18] <= `SD `BR_MARKER_EMPTY;
      br_marker[19] <= `SD `BR_MARKER_EMPTY;
      br_marker[20] <= `SD `BR_MARKER_EMPTY;
      br_marker[21] <= `SD `BR_MARKER_EMPTY;
      br_marker[22] <= `SD `BR_MARKER_EMPTY;
      br_marker[23] <= `SD `BR_MARKER_EMPTY;
      br_marker[24] <= `SD `BR_MARKER_EMPTY;
      br_marker[25] <= `SD `BR_MARKER_EMPTY;
      br_marker[26] <= `SD `BR_MARKER_EMPTY;
      br_marker[27] <= `SD `BR_MARKER_EMPTY;
      br_marker[28] <= `SD `BR_MARKER_EMPTY;
      br_marker[29] <= `SD `BR_MARKER_EMPTY;
      br_marker[30] <= `SD `BR_MARKER_EMPTY;
      br_marker[31] <= `SD `BR_MARKER_EMPTY;
      br[0]     <= `SD 1'b0;
      br[1]     <= `SD 1'b0;
      br[2]     <= `SD 1'b0;
      br[3]     <= `SD 1'b0;
      br[4]     <= `SD 1'b0;
      br[5]     <= `SD 1'b0;
      br[6]     <= `SD 1'b0;
      br[7]     <= `SD 1'b0;
      br[8]     <= `SD 1'b0;
      br[9]     <= `SD 1'b0;
      br[10]    <= `SD 1'b0;
      br[11]    <= `SD 1'b0;
      br[12]    <= `SD 1'b0;
      br[13]    <= `SD 1'b0;
      br[14]    <= `SD 1'b0;
      br[15]    <= `SD 1'b0;
      br[16]    <= `SD 1'b0;
      br[17]    <= `SD 1'b0;
      br[18]    <= `SD 1'b0;
      br[19]    <= `SD 1'b0;
      br[20]    <= `SD 1'b0;
      br[21]    <= `SD 1'b0;
      br[22]    <= `SD 1'b0;
      br[23]    <= `SD 1'b0;
      br[24]    <= `SD 1'b0;
      br[25]    <= `SD 1'b0;
      br[26]    <= `SD 1'b0;
      br[27]    <= `SD 1'b0;
      br[28]    <= `SD 1'b0;
      br[29]    <= `SD 1'b0;
      br[30]    <= `SD 1'b0;
      br[31]    <= `SD 1'b0;
      br_taken[0]     <= `SD 1'b0;
      br_taken[1]     <= `SD 1'b0;
      br_taken[2]     <= `SD 1'b0;
      br_taken[3]     <= `SD 1'b0;
      br_taken[4]     <= `SD 1'b0;
      br_taken[5]     <= `SD 1'b0;
      br_taken[6]     <= `SD 1'b0;
      br_taken[7]     <= `SD 1'b0;
      br_taken[8]     <= `SD 1'b0;
      br_taken[9]     <= `SD 1'b0;
      br_taken[10]    <= `SD 1'b0;
      br_taken[11]    <= `SD 1'b0;
      br_taken[12]    <= `SD 1'b0;
      br_taken[13]    <= `SD 1'b0;
      br_taken[14]    <= `SD 1'b0;
      br_taken[15]    <= `SD 1'b0;
      br_taken[16]    <= `SD 1'b0;
      br_taken[17]    <= `SD 1'b0;
      br_taken[18]    <= `SD 1'b0;
      br_taken[19]    <= `SD 1'b0;
      br_taken[20]    <= `SD 1'b0;
      br_taken[21]    <= `SD 1'b0;
      br_taken[22]    <= `SD 1'b0;
      br_taken[23]    <= `SD 1'b0;
      br_taken[24]    <= `SD 1'b0;
      br_taken[25]    <= `SD 1'b0;
      br_taken[26]    <= `SD 1'b0;
      br_taken[27]    <= `SD 1'b0;
      br_taken[28]    <= `SD 1'b0;
      br_taken[29]    <= `SD 1'b0;
      br_taken[30]    <= `SD 1'b0;
      br_taken[31]    <= `SD 1'b0;
      br_target_PC[0]     <= `SD 64'd0;
      br_target_PC[1]     <= `SD 64'd0;
      br_target_PC[2]     <= `SD 64'd0;
      br_target_PC[3]     <= `SD 64'd0;
      br_target_PC[4]     <= `SD 64'd0;
      br_target_PC[5]     <= `SD 64'd0;
      br_target_PC[6]     <= `SD 64'd0;
      br_target_PC[7]     <= `SD 64'd0;
      br_target_PC[8]     <= `SD 64'd0;
      br_target_PC[9]     <= `SD 64'd0;
      br_target_PC[10]    <= `SD 64'd0;
      br_target_PC[11]    <= `SD 64'd0;
      br_target_PC[12]    <= `SD 64'd0;
      br_target_PC[13]    <= `SD 64'd0;
      br_target_PC[14]    <= `SD 64'd0;
      br_target_PC[15]    <= `SD 64'd0;
      br_target_PC[16]    <= `SD 64'd0;
      br_target_PC[17]    <= `SD 64'd0;
      br_target_PC[18]    <= `SD 64'd0;
      br_target_PC[19]    <= `SD 64'd0;
      br_target_PC[20]    <= `SD 64'd0;
      br_target_PC[21]    <= `SD 64'd0;
      br_target_PC[22]    <= `SD 64'd0;
      br_target_PC[23]    <= `SD 64'd0;
      br_target_PC[24]    <= `SD 64'd0;
      br_target_PC[25]    <= `SD 64'd0;
      br_target_PC[26]    <= `SD 64'd0;
      br_target_PC[27]    <= `SD 64'd0;
      br_target_PC[28]    <= `SD 64'd0;
      br_target_PC[29]    <= `SD 64'd0;
      br_target_PC[30]    <= `SD 64'd0;
      br_target_PC[31]    <= `SD 64'd0;
      halt[0]       <= `SD `FALSE;
      halt[1]       <= `SD `FALSE;
      halt[2]       <= `SD `FALSE;
      halt[3]       <= `SD `FALSE;
      halt[4]       <= `SD `FALSE;
      halt[5]       <= `SD `FALSE;
      halt[6]       <= `SD `FALSE;
      halt[7]       <= `SD `FALSE;
      halt[8]       <= `SD `FALSE;
      halt[9]       <= `SD `FALSE;
      halt[10]       <= `SD `FALSE;
      halt[11]       <= `SD `FALSE;
      halt[12]       <= `SD `FALSE;
      halt[13]       <= `SD `FALSE;
      halt[14]       <= `SD `FALSE;
      halt[15]       <= `SD `FALSE;
      halt[16]       <= `SD `FALSE;
      halt[17]       <= `SD `FALSE;
      halt[18]       <= `SD `FALSE;
      halt[19]       <= `SD `FALSE;
      halt[20]       <= `SD `FALSE;
      halt[21]       <= `SD `FALSE;
      halt[22]       <= `SD `FALSE;
      halt[23]       <= `SD `FALSE;
      halt[24]       <= `SD `FALSE;
      halt[25]       <= `SD `FALSE;
      halt[26]       <= `SD `FALSE;
      halt[27]       <= `SD `FALSE;
      halt[28]       <= `SD `FALSE;
      halt[29]       <= `SD `FALSE;
      halt[30]       <= `SD `FALSE;
      halt[31]       <= `SD `FALSE;
      noop[0]       <= `SD `FALSE;
      noop[1]       <= `SD `FALSE;
      noop[2]       <= `SD `FALSE;
      noop[3]       <= `SD `FALSE;
      noop[4]       <= `SD `FALSE;
      noop[5]       <= `SD `FALSE;
      noop[6]       <= `SD `FALSE;
      noop[7]       <= `SD `FALSE;
      noop[8]       <= `SD `FALSE;
      noop[9]       <= `SD `FALSE;
      noop[10]       <= `SD `FALSE;
      noop[11]       <= `SD `FALSE;
      noop[12]       <= `SD `FALSE;
      noop[13]       <= `SD `FALSE;
      noop[14]       <= `SD `FALSE;
      noop[15]       <= `SD `FALSE;
      noop[16]       <= `SD `FALSE;
      noop[17]       <= `SD `FALSE;
      noop[18]       <= `SD `FALSE;
      noop[19]       <= `SD `FALSE;
      noop[20]       <= `SD `FALSE;
      noop[21]       <= `SD `FALSE;
      noop[22]       <= `SD `FALSE;
      noop[23]       <= `SD `FALSE;
      noop[24]       <= `SD `FALSE;
      noop[25]       <= `SD `FALSE;
      noop[26]       <= `SD `FALSE;
      noop[27]       <= `SD `FALSE;
      noop[28]       <= `SD `FALSE;
      noop[29]       <= `SD `FALSE;
      noop[30]       <= `SD `FALSE;
      noop[31]       <= `SD `FALSE;
      NPC[0]       <= `SD `FALSE;
      NPC[1]       <= `SD `FALSE;
      NPC[2]       <= `SD `FALSE;
      NPC[3]       <= `SD `FALSE;
      NPC[4]       <= `SD `FALSE;
      NPC[5]       <= `SD `FALSE;
      NPC[6]       <= `SD `FALSE;
      NPC[7]       <= `SD `FALSE;
      NPC[8]       <= `SD `FALSE;
      NPC[9]       <= `SD `FALSE;
      NPC[10]       <= `SD `FALSE;
      NPC[11]       <= `SD `FALSE;
      NPC[12]       <= `SD `FALSE;
      NPC[13]       <= `SD `FALSE;
      NPC[14]       <= `SD `FALSE;
      NPC[15]       <= `SD `FALSE;
      NPC[16]       <= `SD `FALSE;
      NPC[17]       <= `SD `FALSE;
      NPC[18]       <= `SD `FALSE;
      NPC[19]       <= `SD `FALSE;
      NPC[20]       <= `SD `FALSE;
      NPC[21]       <= `SD `FALSE;
      NPC[22]       <= `SD `FALSE;
      NPC[23]       <= `SD `FALSE;
      NPC[24]       <= `SD `FALSE;
      NPC[25]       <= `SD `FALSE;
      NPC[26]       <= `SD `FALSE;
      NPC[27]       <= `SD `FALSE;
      NPC[28]       <= `SD `FALSE;
      NPC[29]       <= `SD `FALSE;
      NPC[30]       <= `SD `FALSE;
      NPC[31]       <= `SD `FALSE;
      wb_data[0]       <= `SD `FALSE;
      wb_data[1]       <= `SD `FALSE;
      wb_data[2]       <= `SD `FALSE;
      wb_data[3]       <= `SD `FALSE;
      wb_data[4]       <= `SD `FALSE;
      wb_data[5]       <= `SD `FALSE;
      wb_data[6]       <= `SD `FALSE;
      wb_data[7]       <= `SD `FALSE;
      wb_data[8]       <= `SD `FALSE;
      wb_data[9]       <= `SD `FALSE;
      wb_data[10]       <= `SD `FALSE;
      wb_data[11]       <= `SD `FALSE;
      wb_data[12]       <= `SD `FALSE;
      wb_data[13]       <= `SD `FALSE;
      wb_data[14]       <= `SD `FALSE;
      wb_data[15]       <= `SD `FALSE;
      wb_data[16]       <= `SD `FALSE;
      wb_data[17]       <= `SD `FALSE;
      wb_data[18]       <= `SD `FALSE;
      wb_data[19]       <= `SD `FALSE;
      wb_data[20]       <= `SD `FALSE;
      wb_data[21]       <= `SD `FALSE;
      wb_data[22]       <= `SD `FALSE;
      wb_data[23]       <= `SD `FALSE;
      wb_data[24]       <= `SD `FALSE;
      wb_data[25]       <= `SD `FALSE;
      wb_data[26]       <= `SD `FALSE;
      wb_data[27]       <= `SD `FALSE;
      wb_data[28]       <= `SD `FALSE;
      wb_data[29]       <= `SD `FALSE;
      wb_data[30]       <= `SD `FALSE;
      wb_data[31]       <= `SD `FALSE;
      br_t[0]           <= `SD 6'd0;
      br_t[1]           <= `SD 6'd0;
      br_t[2]           <= `SD 6'd0;
      br_t[3]           <= `SD 6'd0;

      T_out_1           <= `SD 6'd0;
      T_out_2           <= `SD 6'd0;
      Told_out_1        <= `SD 6'd0;
      Told_out_2        <= `SD 6'd0;
      T_valid_1         <= `SD 1'b0;
      T_valid_2         <= `SD 1'b0;
      NPC_out_1         <= `SD 64'd0;
      NPC_out_2         <= `SD 64'd0;
      wb_data_out_1     <= `SD 64'd0;
      wb_data_out_2     <= `SD 64'd0;
    end
    else if(br_mispredict) begin
      T[0]          <= `SD `ZERO_REG;
      T[1]          <= `SD `ZERO_REG;
      T[2]          <= `SD `ZERO_REG;
      T[3]          <= `SD `ZERO_REG;
      T[4]          <= `SD `ZERO_REG;
      T[5]          <= `SD `ZERO_REG;
      T[6]          <= `SD `ZERO_REG;
      T[7]          <= `SD `ZERO_REG;
      T[8]          <= `SD `ZERO_REG;
      T[9]          <= `SD `ZERO_REG;
      T[10]         <= `SD `ZERO_REG;
      T[11]         <= `SD `ZERO_REG;
      T[12]         <= `SD `ZERO_REG;
      T[13]         <= `SD `ZERO_REG;
      T[14]         <= `SD `ZERO_REG;
      T[15]         <= `SD `ZERO_REG;
      T[16]         <= `SD `ZERO_REG;
      T[17]         <= `SD `ZERO_REG;
      T[18]         <= `SD `ZERO_REG;
      T[19]         <= `SD `ZERO_REG;
      T[20]         <= `SD `ZERO_REG;
      T[21]         <= `SD `ZERO_REG;
      T[22]         <= `SD `ZERO_REG;
      T[23]         <= `SD `ZERO_REG;
      T[24]         <= `SD `ZERO_REG;
      T[25]         <= `SD `ZERO_REG;
      T[26]         <= `SD `ZERO_REG;
      T[27]         <= `SD `ZERO_REG;
      T[28]         <= `SD `ZERO_REG;
      T[29]         <= `SD `ZERO_REG;
      T[30]         <= `SD `ZERO_REG;
      T[31]         <= `SD `ZERO_REG;
      Told[0]       <= `SD `ZERO_REG;
      Told[1]       <= `SD `ZERO_REG;
      Told[2]       <= `SD `ZERO_REG;
      Told[3]       <= `SD `ZERO_REG;
      Told[4]       <= `SD `ZERO_REG;
      Told[5]       <= `SD `ZERO_REG;
      Told[6]       <= `SD `ZERO_REG;
      Told[7]       <= `SD `ZERO_REG;
      Told[8]       <= `SD `ZERO_REG;
      Told[9]       <= `SD `ZERO_REG;
      Told[10]      <= `SD `ZERO_REG;
      Told[11]      <= `SD `ZERO_REG;
      Told[12]      <= `SD `ZERO_REG;
      Told[13]      <= `SD `ZERO_REG;
      Told[14]      <= `SD `ZERO_REG;
      Told[15]      <= `SD `ZERO_REG;
      Told[16]      <= `SD `ZERO_REG;
      Told[17]      <= `SD `ZERO_REG;
      Told[18]      <= `SD `ZERO_REG;
      Told[19]      <= `SD `ZERO_REG;
      Told[20]      <= `SD `ZERO_REG;
      Told[21]      <= `SD `ZERO_REG;
      Told[22]      <= `SD `ZERO_REG;
      Told[23]      <= `SD `ZERO_REG;
      Told[24]      <= `SD `ZERO_REG;
      Told[25]      <= `SD `ZERO_REG;
      Told[26]      <= `SD `ZERO_REG;
      Told[27]      <= `SD `ZERO_REG;
      Told[28]      <= `SD `ZERO_REG;
      Told[29]      <= `SD `ZERO_REG;
      Told[30]      <= `SD `ZERO_REG;
      Told[31]      <= `SD `ZERO_REG;
      C[0]          <= `SD 1'b0;
      C[1]          <= `SD 1'b0;
      C[2]          <= `SD 1'b0;
      C[3]          <= `SD 1'b0;
      C[4]          <= `SD 1'b0;
      C[5]          <= `SD 1'b0;
      C[6]          <= `SD 1'b0;
      C[7]          <= `SD 1'b0;
      C[8]          <= `SD 1'b0;
      C[9]          <= `SD 1'b0;
      C[10]         <= `SD 1'b0;
      C[11]         <= `SD 1'b0;
      C[12]         <= `SD 1'b0;
      C[13]         <= `SD 1'b0;
      C[14]         <= `SD 1'b0;
      C[15]         <= `SD 1'b0;
      C[16]         <= `SD 1'b0;
      C[17]         <= `SD 1'b0;
      C[18]         <= `SD 1'b0;
      C[19]         <= `SD 1'b0;
      C[20]         <= `SD 1'b0;
      C[21]         <= `SD 1'b0;
      C[22]         <= `SD 1'b0;
      C[23]         <= `SD 1'b0;
      C[24]         <= `SD 1'b0;
      C[25]         <= `SD 1'b0;
      C[26]         <= `SD 1'b0;
      C[27]         <= `SD 1'b0;
      C[28]         <= `SD 1'b0;
      C[29]         <= `SD 1'b0;
      C[30]         <= `SD 1'b0;
      C[31]         <= `SD 1'b0;
      wr_mem[0]     <= `SD 1'b0;
      wr_mem[1]     <= `SD 1'b0;
      wr_mem[2]     <= `SD 1'b0;
      wr_mem[3]     <= `SD 1'b0;
      wr_mem[4]     <= `SD 1'b0;
      wr_mem[5]     <= `SD 1'b0;
      wr_mem[6]     <= `SD 1'b0;
      wr_mem[7]     <= `SD 1'b0;
      wr_mem[8]     <= `SD 1'b0;
      wr_mem[9]     <= `SD 1'b0;
      wr_mem[10]    <= `SD 1'b0;
      wr_mem[11]    <= `SD 1'b0;
      wr_mem[12]    <= `SD 1'b0;
      wr_mem[13]    <= `SD 1'b0;
      wr_mem[14]    <= `SD 1'b0;
      wr_mem[15]    <= `SD 1'b0;
      wr_mem[16]    <= `SD 1'b0;
      wr_mem[17]    <= `SD 1'b0;
      wr_mem[18]    <= `SD 1'b0;
      wr_mem[19]    <= `SD 1'b0;
      wr_mem[20]    <= `SD 1'b0;
      wr_mem[21]    <= `SD 1'b0;
      wr_mem[22]    <= `SD 1'b0;
      wr_mem[23]    <= `SD 1'b0;
      wr_mem[24]    <= `SD 1'b0;
      wr_mem[25]    <= `SD 1'b0;
      wr_mem[26]    <= `SD 1'b0;
      wr_mem[27]    <= `SD 1'b0;
      wr_mem[28]    <= `SD 1'b0;
      wr_mem[29]    <= `SD 1'b0;
      wr_mem[30]    <= `SD 1'b0;
      wr_mem[31]    <= `SD 1'b0;
      rd_mem[0]     <= `SD 1'b0;
      rd_mem[1]     <= `SD 1'b0;
      rd_mem[2]     <= `SD 1'b0;
      rd_mem[3]     <= `SD 1'b0;
      rd_mem[4]     <= `SD 1'b0;
      rd_mem[5]     <= `SD 1'b0;
      rd_mem[6]     <= `SD 1'b0;
      rd_mem[7]     <= `SD 1'b0;
      rd_mem[8]     <= `SD 1'b0;
      rd_mem[9]     <= `SD 1'b0;
      rd_mem[10]    <= `SD 1'b0;
      rd_mem[11]    <= `SD 1'b0;
      rd_mem[12]    <= `SD 1'b0;
      rd_mem[13]    <= `SD 1'b0;
      rd_mem[14]    <= `SD 1'b0;
      rd_mem[15]    <= `SD 1'b0;
      rd_mem[16]    <= `SD 1'b0;
      rd_mem[17]    <= `SD 1'b0;
      rd_mem[18]    <= `SD 1'b0;
      rd_mem[19]    <= `SD 1'b0;
      rd_mem[20]    <= `SD 1'b0;
      rd_mem[21]    <= `SD 1'b0;
      rd_mem[22]    <= `SD 1'b0;
      rd_mem[23]    <= `SD 1'b0;
      rd_mem[24]    <= `SD 1'b0;
      rd_mem[25]    <= `SD 1'b0;
      rd_mem[26]    <= `SD 1'b0;
      rd_mem[27]    <= `SD 1'b0;
      rd_mem[28]    <= `SD 1'b0;
      rd_mem[29]    <= `SD 1'b0;
      rd_mem[30]    <= `SD 1'b0;
      rd_mem[31]    <= `SD 1'b0;
      br_marker[0]  <= `SD `BR_MARKER_EMPTY;
      br_marker[1]  <= `SD `BR_MARKER_EMPTY;
      br_marker[2]  <= `SD `BR_MARKER_EMPTY;
      br_marker[3]  <= `SD `BR_MARKER_EMPTY;
      br_marker[4]  <= `SD `BR_MARKER_EMPTY;
      br_marker[5]  <= `SD `BR_MARKER_EMPTY;
      br_marker[6]  <= `SD `BR_MARKER_EMPTY;
      br_marker[7]  <= `SD `BR_MARKER_EMPTY;
      br_marker[8]  <= `SD `BR_MARKER_EMPTY;
      br_marker[9]  <= `SD `BR_MARKER_EMPTY;
      br_marker[10] <= `SD `BR_MARKER_EMPTY;
      br_marker[11] <= `SD `BR_MARKER_EMPTY;
      br_marker[12] <= `SD `BR_MARKER_EMPTY;
      br_marker[13] <= `SD `BR_MARKER_EMPTY;
      br_marker[14] <= `SD `BR_MARKER_EMPTY;
      br_marker[15] <= `SD `BR_MARKER_EMPTY;
      br_marker[16] <= `SD `BR_MARKER_EMPTY;
      br_marker[17] <= `SD `BR_MARKER_EMPTY;
      br_marker[18] <= `SD `BR_MARKER_EMPTY;
      br_marker[19] <= `SD `BR_MARKER_EMPTY;
      br_marker[20] <= `SD `BR_MARKER_EMPTY;
      br_marker[21] <= `SD `BR_MARKER_EMPTY;
      br_marker[22] <= `SD `BR_MARKER_EMPTY;
      br_marker[23] <= `SD `BR_MARKER_EMPTY;
      br_marker[24] <= `SD `BR_MARKER_EMPTY;
      br_marker[25] <= `SD `BR_MARKER_EMPTY;
      br_marker[26] <= `SD `BR_MARKER_EMPTY;
      br_marker[27] <= `SD `BR_MARKER_EMPTY;
      br_marker[28] <= `SD `BR_MARKER_EMPTY;
      br_marker[29] <= `SD `BR_MARKER_EMPTY;
      br_marker[30] <= `SD `BR_MARKER_EMPTY;
      br_marker[31] <= `SD `BR_MARKER_EMPTY;
      br[0]     <= `SD 1'b0;
      br[1]     <= `SD 1'b0;
      br[2]     <= `SD 1'b0;
      br[3]     <= `SD 1'b0;
      br[4]     <= `SD 1'b0;
      br[5]     <= `SD 1'b0;
      br[6]     <= `SD 1'b0;
      br[7]     <= `SD 1'b0;
      br[8]     <= `SD 1'b0;
      br[9]     <= `SD 1'b0;
      br[10]    <= `SD 1'b0;
      br[11]    <= `SD 1'b0;
      br[12]    <= `SD 1'b0;
      br[13]    <= `SD 1'b0;
      br[14]    <= `SD 1'b0;
      br[15]    <= `SD 1'b0;
      br[16]    <= `SD 1'b0;
      br[17]    <= `SD 1'b0;
      br[18]    <= `SD 1'b0;
      br[19]    <= `SD 1'b0;
      br[20]    <= `SD 1'b0;
      br[21]    <= `SD 1'b0;
      br[22]    <= `SD 1'b0;
      br[23]    <= `SD 1'b0;
      br[24]    <= `SD 1'b0;
      br[25]    <= `SD 1'b0;
      br[26]    <= `SD 1'b0;
      br[27]    <= `SD 1'b0;
      br[28]    <= `SD 1'b0;
      br[29]    <= `SD 1'b0;
      br[30]    <= `SD 1'b0;
      br[31]    <= `SD 1'b0;
      br_taken[0]     <= `SD 1'b0;
      br_taken[1]     <= `SD 1'b0;
      br_taken[2]     <= `SD 1'b0;
      br_taken[3]     <= `SD 1'b0;
      br_taken[4]     <= `SD 1'b0;
      br_taken[5]     <= `SD 1'b0;
      br_taken[6]     <= `SD 1'b0;
      br_taken[7]     <= `SD 1'b0;
      br_taken[8]     <= `SD 1'b0;
      br_taken[9]     <= `SD 1'b0;
      br_taken[10]    <= `SD 1'b0;
      br_taken[11]    <= `SD 1'b0;
      br_taken[12]    <= `SD 1'b0;
      br_taken[13]    <= `SD 1'b0;
      br_taken[14]    <= `SD 1'b0;
      br_taken[15]    <= `SD 1'b0;
      br_taken[16]    <= `SD 1'b0;
      br_taken[17]    <= `SD 1'b0;
      br_taken[18]    <= `SD 1'b0;
      br_taken[19]    <= `SD 1'b0;
      br_taken[20]    <= `SD 1'b0;
      br_taken[21]    <= `SD 1'b0;
      br_taken[22]    <= `SD 1'b0;
      br_taken[23]    <= `SD 1'b0;
      br_taken[24]    <= `SD 1'b0;
      br_taken[25]    <= `SD 1'b0;
      br_taken[26]    <= `SD 1'b0;
      br_taken[27]    <= `SD 1'b0;
      br_taken[28]    <= `SD 1'b0;
      br_taken[29]    <= `SD 1'b0;
      br_taken[30]    <= `SD 1'b0;
      br_taken[31]    <= `SD 1'b0;
      br_target_PC[0]     <= `SD 64'd0;
      br_target_PC[1]     <= `SD 64'd0;
      br_target_PC[2]     <= `SD 64'd0;
      br_target_PC[3]     <= `SD 64'd0;
      br_target_PC[4]     <= `SD 64'd0;
      br_target_PC[5]     <= `SD 64'd0;
      br_target_PC[6]     <= `SD 64'd0;
      br_target_PC[7]     <= `SD 64'd0;
      br_target_PC[8]     <= `SD 64'd0;
      br_target_PC[9]     <= `SD 64'd0;
      br_target_PC[10]    <= `SD 64'd0;
      br_target_PC[11]    <= `SD 64'd0;
      br_target_PC[12]    <= `SD 64'd0;
      br_target_PC[13]    <= `SD 64'd0;
      br_target_PC[14]    <= `SD 64'd0;
      br_target_PC[15]    <= `SD 64'd0;
      br_target_PC[16]    <= `SD 64'd0;
      br_target_PC[17]    <= `SD 64'd0;
      br_target_PC[18]    <= `SD 64'd0;
      br_target_PC[19]    <= `SD 64'd0;
      br_target_PC[20]    <= `SD 64'd0;
      br_target_PC[21]    <= `SD 64'd0;
      br_target_PC[22]    <= `SD 64'd0;
      br_target_PC[23]    <= `SD 64'd0;
      br_target_PC[24]    <= `SD 64'd0;
      br_target_PC[25]    <= `SD 64'd0;
      br_target_PC[26]    <= `SD 64'd0;
      br_target_PC[27]    <= `SD 64'd0;
      br_target_PC[28]    <= `SD 64'd0;
      br_target_PC[29]    <= `SD 64'd0;
      br_target_PC[30]    <= `SD 64'd0;
      br_target_PC[31]    <= `SD 64'd0;
      halt[0]       <= `SD `FALSE;
      halt[1]       <= `SD `FALSE;
      halt[2]       <= `SD `FALSE;
      halt[3]       <= `SD `FALSE;
      halt[4]       <= `SD `FALSE;
      halt[5]       <= `SD `FALSE;
      halt[6]       <= `SD `FALSE;
      halt[7]       <= `SD `FALSE;
      halt[8]       <= `SD `FALSE;
      halt[9]       <= `SD `FALSE;
      halt[10]       <= `SD `FALSE;
      halt[11]       <= `SD `FALSE;
      halt[12]       <= `SD `FALSE;
      halt[13]       <= `SD `FALSE;
      halt[14]       <= `SD `FALSE;
      halt[15]       <= `SD `FALSE;
      halt[16]       <= `SD `FALSE;
      halt[17]       <= `SD `FALSE;
      halt[18]       <= `SD `FALSE;
      halt[19]       <= `SD `FALSE;
      halt[20]       <= `SD `FALSE;
      halt[21]       <= `SD `FALSE;
      halt[22]       <= `SD `FALSE;
      halt[23]       <= `SD `FALSE;
      halt[24]       <= `SD `FALSE;
      halt[25]       <= `SD `FALSE;
      halt[26]       <= `SD `FALSE;
      halt[27]       <= `SD `FALSE;
      halt[28]       <= `SD `FALSE;
      halt[29]       <= `SD `FALSE;
      halt[30]       <= `SD `FALSE;
      halt[31]       <= `SD `FALSE;
      noop[0]       <= `SD `FALSE;
      noop[1]       <= `SD `FALSE;
      noop[2]       <= `SD `FALSE;
      noop[3]       <= `SD `FALSE;
      noop[4]       <= `SD `FALSE;
      noop[5]       <= `SD `FALSE;
      noop[6]       <= `SD `FALSE;
      noop[7]       <= `SD `FALSE;
      noop[8]       <= `SD `FALSE;
      noop[9]       <= `SD `FALSE;
      noop[10]       <= `SD `FALSE;
      noop[11]       <= `SD `FALSE;
      noop[12]       <= `SD `FALSE;
      noop[13]       <= `SD `FALSE;
      noop[14]       <= `SD `FALSE;
      noop[15]       <= `SD `FALSE;
      noop[16]       <= `SD `FALSE;
      noop[17]       <= `SD `FALSE;
      noop[18]       <= `SD `FALSE;
      noop[19]       <= `SD `FALSE;
      noop[20]       <= `SD `FALSE;
      noop[21]       <= `SD `FALSE;
      noop[22]       <= `SD `FALSE;
      noop[23]       <= `SD `FALSE;
      noop[24]       <= `SD `FALSE;
      noop[25]       <= `SD `FALSE;
      noop[26]       <= `SD `FALSE;
      noop[27]       <= `SD `FALSE;
      noop[28]       <= `SD `FALSE;
      noop[29]       <= `SD `FALSE;
      noop[30]       <= `SD `FALSE;
      noop[31]       <= `SD `FALSE;
      NPC[0]       <= `SD `FALSE;
      NPC[1]       <= `SD `FALSE;
      NPC[2]       <= `SD `FALSE;
      NPC[3]       <= `SD `FALSE;
      NPC[4]       <= `SD `FALSE;
      NPC[5]       <= `SD `FALSE;
      NPC[6]       <= `SD `FALSE;
      NPC[7]       <= `SD `FALSE;
      NPC[8]       <= `SD `FALSE;
      NPC[9]       <= `SD `FALSE;
      NPC[10]       <= `SD `FALSE;
      NPC[11]       <= `SD `FALSE;
      NPC[12]       <= `SD `FALSE;
      NPC[13]       <= `SD `FALSE;
      NPC[14]       <= `SD `FALSE;
      NPC[15]       <= `SD `FALSE;
      NPC[16]       <= `SD `FALSE;
      NPC[17]       <= `SD `FALSE;
      NPC[18]       <= `SD `FALSE;
      NPC[19]       <= `SD `FALSE;
      NPC[20]       <= `SD `FALSE;
      NPC[21]       <= `SD `FALSE;
      NPC[22]       <= `SD `FALSE;
      NPC[23]       <= `SD `FALSE;
      NPC[24]       <= `SD `FALSE;
      NPC[25]       <= `SD `FALSE;
      NPC[26]       <= `SD `FALSE;
      NPC[27]       <= `SD `FALSE;
      NPC[28]       <= `SD `FALSE;
      NPC[29]       <= `SD `FALSE;
      NPC[30]       <= `SD `FALSE;
      NPC[31]       <= `SD `FALSE;
      wb_data[0]       <= `SD `FALSE;
      wb_data[1]       <= `SD `FALSE;
      wb_data[2]       <= `SD `FALSE;
      wb_data[3]       <= `SD `FALSE;
      wb_data[4]       <= `SD `FALSE;
      wb_data[5]       <= `SD `FALSE;
      wb_data[6]       <= `SD `FALSE;
      wb_data[7]       <= `SD `FALSE;
      wb_data[8]       <= `SD `FALSE;
      wb_data[9]       <= `SD `FALSE;
      wb_data[10]       <= `SD `FALSE;
      wb_data[11]       <= `SD `FALSE;
      wb_data[12]       <= `SD `FALSE;
      wb_data[13]       <= `SD `FALSE;
      wb_data[14]       <= `SD `FALSE;
      wb_data[15]       <= `SD `FALSE;
      wb_data[16]       <= `SD `FALSE;
      wb_data[17]       <= `SD `FALSE;
      wb_data[18]       <= `SD `FALSE;
      wb_data[19]       <= `SD `FALSE;
      wb_data[20]       <= `SD `FALSE;
      wb_data[21]       <= `SD `FALSE;
      wb_data[22]       <= `SD `FALSE;
      wb_data[23]       <= `SD `FALSE;
      wb_data[24]       <= `SD `FALSE;
      wb_data[25]       <= `SD `FALSE;
      wb_data[26]       <= `SD `FALSE;
      wb_data[27]       <= `SD `FALSE;
      wb_data[28]       <= `SD `FALSE;
      wb_data[29]       <= `SD `FALSE;
      wb_data[30]       <= `SD `FALSE;
      wb_data[31]       <= `SD `FALSE;
      br_t[0]           <= `SD 6'd0;
      br_t[1]           <= `SD 6'd0;
      br_t[2]           <= `SD 6'd0;
      br_t[3]           <= `SD 6'd0;

      h                 <= `SD next_h;
      t                 <= `SD br_t[br_mispre_marker[1:0]];
      // Retire
      T_out_1           <= `SD next_T_out_1;
      T_out_2           <= `SD next_T_out_2;
      Told_out_1        <= `SD next_Told_out_1;
      Told_out_2        <= `SD next_Told_out_2;
      T_valid_1         <= `SD next_T_valid_1;
      T_valid_2         <= `SD next_T_valid_2;
      NPC_out_1         <= `SD next_NPC_out_1;
      NPC_out_2         <= `SD next_NPC_out_2;
      wb_data_out_1     <= `SD next_wb_data_out_1;
      wb_data_out_2     <= `SD next_wb_data_out_2;
    end
    else begin
      T[0]  <= `SD next_T[0];
      T[1]  <= `SD next_T[1];
      T[2]  <= `SD next_T[2];
      T[3]  <= `SD next_T[3];
      T[4]  <= `SD next_T[4];
      T[5]  <= `SD next_T[5];
      T[6]  <= `SD next_T[6];
      T[7]  <= `SD next_T[7];
      T[8]  <= `SD next_T[8];
      T[9]  <= `SD next_T[9];
      T[10] <= `SD next_T[10];
      T[11] <= `SD next_T[11];
      T[12] <= `SD next_T[12];
      T[13] <= `SD next_T[13];
      T[14] <= `SD next_T[14];
      T[15] <= `SD next_T[15];
      T[16] <= `SD next_T[16];
      T[17] <= `SD next_T[17];
      T[18] <= `SD next_T[18];
      T[19] <= `SD next_T[19];
      T[20] <= `SD next_T[20];
      T[21] <= `SD next_T[21];
      T[22] <= `SD next_T[22];
      T[23] <= `SD next_T[23];
      T[24] <= `SD next_T[24];
      T[25] <= `SD next_T[25];
      T[26] <= `SD next_T[26];
      T[27] <= `SD next_T[27];
      T[28] <= `SD next_T[28];
      T[29] <= `SD next_T[29];
      T[30] <= `SD next_T[30];
      T[31] <= `SD next_T[31];
      Told[0]  <= `SD next_Told[0];
      Told[1]  <= `SD next_Told[1];
      Told[2]  <= `SD next_Told[2];
      Told[3]  <= `SD next_Told[3];
      Told[4]  <= `SD next_Told[4];
      Told[5]  <= `SD next_Told[5];
      Told[6]  <= `SD next_Told[6];
      Told[7]  <= `SD next_Told[7];
      Told[8]  <= `SD next_Told[8];
      Told[9]  <= `SD next_Told[9];
      Told[10] <= `SD next_Told[10];
      Told[11] <= `SD next_Told[11];
      Told[12] <= `SD next_Told[12];
      Told[13] <= `SD next_Told[13];
      Told[14] <= `SD next_Told[14];
      Told[15] <= `SD next_Told[15];
      Told[16] <= `SD next_Told[16];
      Told[17] <= `SD next_Told[17];
      Told[18] <= `SD next_Told[18];
      Told[19] <= `SD next_Told[19];
      Told[20] <= `SD next_Told[20];
      Told[21] <= `SD next_Told[21];
      Told[22] <= `SD next_Told[22];
      Told[23] <= `SD next_Told[23];
      Told[24] <= `SD next_Told[24];
      Told[25] <= `SD next_Told[25];
      Told[26] <= `SD next_Told[26];
      Told[27] <= `SD next_Told[27];
      Told[28] <= `SD next_Told[28];
      Told[29] <= `SD next_Told[29];
      Told[30] <= `SD next_Told[30];
      Told[31] <= `SD next_Told[31];
      wr_mem[0]  <= `SD next_wr_mem[0];
      wr_mem[1]  <= `SD next_wr_mem[1];
      wr_mem[2]  <= `SD next_wr_mem[2];
      wr_mem[3]  <= `SD next_wr_mem[3];
      wr_mem[4]  <= `SD next_wr_mem[4];
      wr_mem[5]  <= `SD next_wr_mem[5];
      wr_mem[6]  <= `SD next_wr_mem[6];
      wr_mem[7]  <= `SD next_wr_mem[7];
      wr_mem[8]  <= `SD next_wr_mem[8];
      wr_mem[9]  <= `SD next_wr_mem[9];
      wr_mem[10] <= `SD next_wr_mem[10];
      wr_mem[11] <= `SD next_wr_mem[11];
      wr_mem[12] <= `SD next_wr_mem[12];
      wr_mem[13] <= `SD next_wr_mem[13];
      wr_mem[14] <= `SD next_wr_mem[14];
      wr_mem[15] <= `SD next_wr_mem[15];
      wr_mem[16] <= `SD next_wr_mem[16];
      wr_mem[17] <= `SD next_wr_mem[17];
      wr_mem[18] <= `SD next_wr_mem[18];
      wr_mem[19] <= `SD next_wr_mem[19];
      wr_mem[20] <= `SD next_wr_mem[20];
      wr_mem[21] <= `SD next_wr_mem[21];
      wr_mem[22] <= `SD next_wr_mem[22];
      wr_mem[23] <= `SD next_wr_mem[23];
      wr_mem[24] <= `SD next_wr_mem[24];
      wr_mem[25] <= `SD next_wr_mem[25];
      wr_mem[26] <= `SD next_wr_mem[26];
      wr_mem[27] <= `SD next_wr_mem[27];
      wr_mem[28] <= `SD next_wr_mem[28];
      wr_mem[29] <= `SD next_wr_mem[29];
      wr_mem[30] <= `SD next_wr_mem[30];
      wr_mem[31] <= `SD next_wr_mem[31];
      rd_mem[0]  <= `SD next_rd_mem[0];
      rd_mem[1]  <= `SD next_rd_mem[1];
      rd_mem[2]  <= `SD next_rd_mem[2];
      rd_mem[3]  <= `SD next_rd_mem[3];
      rd_mem[4]  <= `SD next_rd_mem[4];
      rd_mem[5]  <= `SD next_rd_mem[5];
      rd_mem[6]  <= `SD next_rd_mem[6];
      rd_mem[7]  <= `SD next_rd_mem[7];
      rd_mem[8]  <= `SD next_rd_mem[8];
      rd_mem[9]  <= `SD next_rd_mem[9];
      rd_mem[10] <= `SD next_rd_mem[10];
      rd_mem[11] <= `SD next_rd_mem[11];
      rd_mem[12] <= `SD next_rd_mem[12];
      rd_mem[13] <= `SD next_rd_mem[13];
      rd_mem[14] <= `SD next_rd_mem[14];
      rd_mem[15] <= `SD next_rd_mem[15];
      rd_mem[16] <= `SD next_rd_mem[16];
      rd_mem[17] <= `SD next_rd_mem[17];
      rd_mem[18] <= `SD next_rd_mem[18];
      rd_mem[19] <= `SD next_rd_mem[19];
      rd_mem[20] <= `SD next_rd_mem[20];
      rd_mem[21] <= `SD next_rd_mem[21];
      rd_mem[22] <= `SD next_rd_mem[22];
      rd_mem[23] <= `SD next_rd_mem[23];
      rd_mem[24] <= `SD next_rd_mem[24];
      rd_mem[25] <= `SD next_rd_mem[25];
      rd_mem[26] <= `SD next_rd_mem[26];
      rd_mem[27] <= `SD next_rd_mem[27];
      rd_mem[28] <= `SD next_rd_mem[28];
      rd_mem[29] <= `SD next_rd_mem[29];
      rd_mem[30] <= `SD next_rd_mem[30];
      rd_mem[31] <= `SD next_rd_mem[31];
      br_marker[0]  <= `SD next_br_marker[0];
      br_marker[1]  <= `SD next_br_marker[1];
      br_marker[2]  <= `SD next_br_marker[2];
      br_marker[3]  <= `SD next_br_marker[3];
      br_marker[4]  <= `SD next_br_marker[4];
      br_marker[5]  <= `SD next_br_marker[5];
      br_marker[6]  <= `SD next_br_marker[6];
      br_marker[7]  <= `SD next_br_marker[7];
      br_marker[8]  <= `SD next_br_marker[8];
      br_marker[9]  <= `SD next_br_marker[9];
      br_marker[10] <= `SD next_br_marker[10];
      br_marker[11] <= `SD next_br_marker[11];
      br_marker[12] <= `SD next_br_marker[12];
      br_marker[13] <= `SD next_br_marker[13];
      br_marker[14] <= `SD next_br_marker[14];
      br_marker[15] <= `SD next_br_marker[15];
      br_marker[16] <= `SD next_br_marker[16];
      br_marker[17] <= `SD next_br_marker[17];
      br_marker[18] <= `SD next_br_marker[18];
      br_marker[19] <= `SD next_br_marker[19];
      br_marker[20] <= `SD next_br_marker[20];
      br_marker[21] <= `SD next_br_marker[21];
      br_marker[22] <= `SD next_br_marker[22];
      br_marker[23] <= `SD next_br_marker[23];
      br_marker[24] <= `SD next_br_marker[24];
      br_marker[25] <= `SD next_br_marker[25];
      br_marker[26] <= `SD next_br_marker[26];
      br_marker[27] <= `SD next_br_marker[27];
      br_marker[28] <= `SD next_br_marker[28];
      br_marker[29] <= `SD next_br_marker[29];
      br_marker[30] <= `SD next_br_marker[30];
      br_marker[31] <= `SD next_br_marker[31];
      NPC[0]  <= `SD next_NPC[0];
      NPC[1]  <= `SD next_NPC[1];
      NPC[2]  <= `SD next_NPC[2];
      NPC[3]  <= `SD next_NPC[3];
      NPC[4]  <= `SD next_NPC[4];
      NPC[5]  <= `SD next_NPC[5];
      NPC[6]  <= `SD next_NPC[6];
      NPC[7]  <= `SD next_NPC[7];
      NPC[8]  <= `SD next_NPC[8];
      NPC[9]  <= `SD next_NPC[9];
      NPC[10] <= `SD next_NPC[10];
      NPC[11] <= `SD next_NPC[11];
      NPC[12] <= `SD next_NPC[12];
      NPC[13] <= `SD next_NPC[13];
      NPC[14] <= `SD next_NPC[14];
      NPC[15] <= `SD next_NPC[15];
      NPC[16] <= `SD next_NPC[16];
      NPC[17] <= `SD next_NPC[17];
      NPC[18] <= `SD next_NPC[18];
      NPC[19] <= `SD next_NPC[19];
      NPC[20] <= `SD next_NPC[20];
      NPC[21] <= `SD next_NPC[21];
      NPC[22] <= `SD next_NPC[22];
      NPC[23] <= `SD next_NPC[23];
      NPC[24] <= `SD next_NPC[24];
      NPC[25] <= `SD next_NPC[25];
      NPC[26] <= `SD next_NPC[26];
      NPC[27] <= `SD next_NPC[27];
      NPC[28] <= `SD next_NPC[28];
      NPC[29] <= `SD next_NPC[29];
      NPC[30] <= `SD next_NPC[30];
      NPC[31] <= `SD next_NPC[31];
      halt[0]  <= `SD next_halt[0];
      halt[1]  <= `SD next_halt[1];
      halt[2]  <= `SD next_halt[2];
      halt[3]  <= `SD next_halt[3];
      halt[4]  <= `SD next_halt[4];
      halt[5]  <= `SD next_halt[5];
      halt[6]  <= `SD next_halt[6];
      halt[7]  <= `SD next_halt[7];
      halt[8]  <= `SD next_halt[8];
      halt[9]  <= `SD next_halt[9];
      halt[10] <= `SD next_halt[10];
      halt[11] <= `SD next_halt[11];
      halt[12] <= `SD next_halt[12];
      halt[13] <= `SD next_halt[13];
      halt[14] <= `SD next_halt[14];
      halt[15] <= `SD next_halt[15];
      halt[16] <= `SD next_halt[16];
      halt[17] <= `SD next_halt[17];
      halt[18] <= `SD next_halt[18];
      halt[19] <= `SD next_halt[19];
      halt[20] <= `SD next_halt[20];
      halt[21] <= `SD next_halt[21];
      halt[22] <= `SD next_halt[22];
      halt[23] <= `SD next_halt[23];
      halt[24] <= `SD next_halt[24];
      halt[25] <= `SD next_halt[25];
      halt[26] <= `SD next_halt[26];
      halt[27] <= `SD next_halt[27];
      halt[28] <= `SD next_halt[28];
      halt[29] <= `SD next_halt[29];
      halt[30] <= `SD next_halt[30];
      halt[31] <= `SD next_halt[31];
      noop[0]  <= `SD next_noop[0];
      noop[1]  <= `SD next_noop[1];
      noop[2]  <= `SD next_noop[2];
      noop[3]  <= `SD next_noop[3];
      noop[4]  <= `SD next_noop[4];
      noop[5]  <= `SD next_noop[5];
      noop[6]  <= `SD next_noop[6];
      noop[7]  <= `SD next_noop[7];
      noop[8]  <= `SD next_noop[8];
      noop[9]  <= `SD next_noop[9];
      noop[10] <= `SD next_noop[10];
      noop[11] <= `SD next_noop[11];
      noop[12] <= `SD next_noop[12];
      noop[13] <= `SD next_noop[13];
      noop[14] <= `SD next_noop[14];
      noop[15] <= `SD next_noop[15];
      noop[16] <= `SD next_noop[16];
      noop[17] <= `SD next_noop[17];
      noop[18] <= `SD next_noop[18];
      noop[19] <= `SD next_noop[19];
      noop[20] <= `SD next_noop[20];
      noop[21] <= `SD next_noop[21];
      noop[22] <= `SD next_noop[22];
      noop[23] <= `SD next_noop[23];
      noop[24] <= `SD next_noop[24];
      noop[25] <= `SD next_noop[25];
      noop[26] <= `SD next_noop[26];
      noop[27] <= `SD next_noop[27];
      noop[28] <= `SD next_noop[28];
      noop[29] <= `SD next_noop[29];
      noop[30] <= `SD next_noop[30];
      noop[31] <= `SD next_noop[31];
      br[0]  <= `SD next_br[0];
      br[1]  <= `SD next_br[1];
      br[2]  <= `SD next_br[2];
      br[3]  <= `SD next_br[3];
      br[4]  <= `SD next_br[4];
      br[5]  <= `SD next_br[5];
      br[6]  <= `SD next_br[6];
      br[7]  <= `SD next_br[7];
      br[8]  <= `SD next_br[8];
      br[9]  <= `SD next_br[9];
      br[10] <= `SD next_br[10];
      br[11] <= `SD next_br[11];
      br[12] <= `SD next_br[12];
      br[13] <= `SD next_br[13];
      br[14] <= `SD next_br[14];
      br[15] <= `SD next_br[15];
      br[16] <= `SD next_br[16];
      br[17] <= `SD next_br[17];
      br[18] <= `SD next_br[18];
      br[19] <= `SD next_br[19];
      br[20] <= `SD next_br[20];
      br[21] <= `SD next_br[21];
      br[22] <= `SD next_br[22];
      br[23] <= `SD next_br[23];
      br[24] <= `SD next_br[24];
      br[25] <= `SD next_br[25];
      br[26] <= `SD next_br[26];
      br[27] <= `SD next_br[27];
      br[28] <= `SD next_br[28];
      br[29] <= `SD next_br[29];
      br[30] <= `SD next_br[30];
      br[31] <= `SD next_br[31];
      C[0]  <= `SD next_C[0];
      C[1]  <= `SD next_C[1];
      C[2]  <= `SD next_C[2];
      C[3]  <= `SD next_C[3];
      C[4]  <= `SD next_C[4];
      C[5]  <= `SD next_C[5];
      C[6]  <= `SD next_C[6];
      C[7]  <= `SD next_C[7];
      C[8]  <= `SD next_C[8];
      C[9]  <= `SD next_C[9];
      C[10] <= `SD next_C[10];
      C[11] <= `SD next_C[11];
      C[12] <= `SD next_C[12];
      C[13] <= `SD next_C[13];
      C[14] <= `SD next_C[14];
      C[15] <= `SD next_C[15];
      C[16] <= `SD next_C[16];
      C[17] <= `SD next_C[17];
      C[18] <= `SD next_C[18];
      C[19] <= `SD next_C[19];
      C[20] <= `SD next_C[20];
      C[21] <= `SD next_C[21];
      C[22] <= `SD next_C[22];
      C[23] <= `SD next_C[23];
      C[24] <= `SD next_C[24];
      C[25] <= `SD next_C[25];
      C[26] <= `SD next_C[26];
      C[27] <= `SD next_C[27];
      C[28] <= `SD next_C[28];
      C[29] <= `SD next_C[29];
      C[30] <= `SD next_C[30];
      C[31] <= `SD next_C[31];
      br_taken[0]  <= `SD next_br_taken[0];
      br_taken[1]  <= `SD next_br_taken[1];
      br_taken[2]  <= `SD next_br_taken[2];
      br_taken[3]  <= `SD next_br_taken[3];
      br_taken[4]  <= `SD next_br_taken[4];
      br_taken[5]  <= `SD next_br_taken[5];
      br_taken[6]  <= `SD next_br_taken[6];
      br_taken[7]  <= `SD next_br_taken[7];
      br_taken[8]  <= `SD next_br_taken[8];
      br_taken[9]  <= `SD next_br_taken[9];
      br_taken[10] <= `SD next_br_taken[10];
      br_taken[11] <= `SD next_br_taken[11];
      br_taken[12] <= `SD next_br_taken[12];
      br_taken[13] <= `SD next_br_taken[13];
      br_taken[14] <= `SD next_br_taken[14];
      br_taken[15] <= `SD next_br_taken[15];
      br_taken[16] <= `SD next_br_taken[16];
      br_taken[17] <= `SD next_br_taken[17];
      br_taken[18] <= `SD next_br_taken[18];
      br_taken[19] <= `SD next_br_taken[19];
      br_taken[20] <= `SD next_br_taken[20];
      br_taken[21] <= `SD next_br_taken[21];
      br_taken[22] <= `SD next_br_taken[22];
      br_taken[23] <= `SD next_br_taken[23];
      br_taken[24] <= `SD next_br_taken[24];
      br_taken[25] <= `SD next_br_taken[25];
      br_taken[26] <= `SD next_br_taken[26];
      br_taken[27] <= `SD next_br_taken[27];
      br_taken[28] <= `SD next_br_taken[28];
      br_taken[29] <= `SD next_br_taken[29];
      br_taken[30] <= `SD next_br_taken[30];
      br_taken[31] <= `SD next_br_taken[31];
      br_target_PC[0]  <= `SD next_br_target_PC[0];
      br_target_PC[1]  <= `SD next_br_target_PC[1];
      br_target_PC[2]  <= `SD next_br_target_PC[2];
      br_target_PC[3]  <= `SD next_br_target_PC[3];
      br_target_PC[4]  <= `SD next_br_target_PC[4];
      br_target_PC[5]  <= `SD next_br_target_PC[5];
      br_target_PC[6]  <= `SD next_br_target_PC[6];
      br_target_PC[7]  <= `SD next_br_target_PC[7];
      br_target_PC[8]  <= `SD next_br_target_PC[8];
      br_target_PC[9]  <= `SD next_br_target_PC[9];
      br_target_PC[10] <= `SD next_br_target_PC[10];
      br_target_PC[11] <= `SD next_br_target_PC[11];
      br_target_PC[12] <= `SD next_br_target_PC[12];
      br_target_PC[13] <= `SD next_br_target_PC[13];
      br_target_PC[14] <= `SD next_br_target_PC[14];
      br_target_PC[15] <= `SD next_br_target_PC[15];
      br_target_PC[16] <= `SD next_br_target_PC[16];
      br_target_PC[17] <= `SD next_br_target_PC[17];
      br_target_PC[18] <= `SD next_br_target_PC[18];
      br_target_PC[19] <= `SD next_br_target_PC[19];
      br_target_PC[20] <= `SD next_br_target_PC[20];
      br_target_PC[21] <= `SD next_br_target_PC[21];
      br_target_PC[22] <= `SD next_br_target_PC[22];
      br_target_PC[23] <= `SD next_br_target_PC[23];
      br_target_PC[24] <= `SD next_br_target_PC[24];
      br_target_PC[25] <= `SD next_br_target_PC[25];
      br_target_PC[26] <= `SD next_br_target_PC[26];
      br_target_PC[27] <= `SD next_br_target_PC[27];
      br_target_PC[28] <= `SD next_br_target_PC[28];
      br_target_PC[29] <= `SD next_br_target_PC[29];
      br_target_PC[30] <= `SD next_br_target_PC[30];
      br_target_PC[31] <= `SD next_br_target_PC[31];
      wb_data[0]  <= `SD next_wb_data[0];
      wb_data[1]  <= `SD next_wb_data[1];
      wb_data[2]  <= `SD next_wb_data[2];
      wb_data[3]  <= `SD next_wb_data[3];
      wb_data[4]  <= `SD next_wb_data[4];
      wb_data[5]  <= `SD next_wb_data[5];
      wb_data[6]  <= `SD next_wb_data[6];
      wb_data[7]  <= `SD next_wb_data[7];
      wb_data[8]  <= `SD next_wb_data[8];
      wb_data[9]  <= `SD next_wb_data[9];
      wb_data[10] <= `SD next_wb_data[10];
      wb_data[11] <= `SD next_wb_data[11];
      wb_data[12] <= `SD next_wb_data[12];
      wb_data[13] <= `SD next_wb_data[13];
      wb_data[14] <= `SD next_wb_data[14];
      wb_data[15] <= `SD next_wb_data[15];
      wb_data[16] <= `SD next_wb_data[16];
      wb_data[17] <= `SD next_wb_data[17];
      wb_data[18] <= `SD next_wb_data[18];
      wb_data[19] <= `SD next_wb_data[19];
      wb_data[20] <= `SD next_wb_data[20];
      wb_data[21] <= `SD next_wb_data[21];
      wb_data[22] <= `SD next_wb_data[22];
      wb_data[23] <= `SD next_wb_data[23];
      wb_data[24] <= `SD next_wb_data[24];
      wb_data[25] <= `SD next_wb_data[25];
      wb_data[26] <= `SD next_wb_data[26];
      wb_data[27] <= `SD next_wb_data[27];
      wb_data[28] <= `SD next_wb_data[28];
      wb_data[29] <= `SD next_wb_data[29];
      wb_data[30] <= `SD next_wb_data[30];
      wb_data[31] <= `SD next_wb_data[31];
      h                <= `SD next_h;
      t                <= `SD next_t;
      // Retire
      T_out_1           <= `SD next_T_out_1;
      T_out_2           <= `SD next_T_out_2;
      Told_out_1        <= `SD next_Told_out_1;
      Told_out_2        <= `SD next_Told_out_2;
      T_valid_1         <= `SD next_T_valid_1;
      T_valid_2         <= `SD next_T_valid_2;
      NPC_out_1         <= `SD next_NPC_out_1;
      NPC_out_2         <= `SD next_NPC_out_2;
      wb_data_out_1     <= `SD next_wb_data_out_1;
      wb_data_out_2     <= `SD next_wb_data_out_2;

      // Branch
      if(br_wr_en_1 && !br_wr_en_2) begin
        br_t[br_marker_in_1[1:0]] <= `SD t+6'd1;
      end
      else if(!br_wr_en_1 && br_wr_en_2) begin
        br_t[br_marker_in_2[1:0]] <= `SD (T_wr_en_1 && T_wr_en_2)? t+6'd2:t+6'd1;
      end
    end
  end

endmodule

