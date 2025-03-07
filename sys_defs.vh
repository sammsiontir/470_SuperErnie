/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////
//
// Mmeory/testbench attribute definitions
//
//////////////////////////////////////////////


`define NUM_MEM_TAGS           15

`define MEM_SIZE_IN_BYTES      (64*1024)
`define MEM_64BIT_LINES        (`MEM_SIZE_IN_BYTES/8)

// probably not a good idea to change this second one
`define VIRTUAL_CLOCK_PERIOD   50.0 // Clock period from dc_shell
`define VERILOG_CLOCK_PERIOD   50.0 // Clock period from test bench

`define MEM_LATENCY_IN_CYCLES  (100.0/`VIRTUAL_CLOCK_PERIOD+0.49999)
// the 0.49999 is to force ceiling(100/period).  The default behavior for
// float to integer conversion is rounding to nearest




//////////////////////////////////////////////
//
// Branch
//
//////////////////////////////////////////////

`define BRC_STR_HAZ_FULL     2'b11
`define BRC_STR_HAZ_ONE_SLOT 2'b01
`define BRC_STR_HAZ_NONE     2'b00

`define BRC_EMP_HAZ_EMPTY    2'b11
`define BRC_EMP_HAZ_ONE_SLOT 2'b01
`define BRC_EMP_HAZ_2orM     2'b00

`define BRC_WC_DIFF_0        3'd0
`define BRC_WC_LEAD_1        3'd1
`define BRC_WC_LEAD_2        3'd2
`define BRC_WC_LOSE_1        3'd3
`define BRC_WC_LOSE_2        3'd4

`define BR_MARKER_EMPTY      3'd4

//////////////////////////////////////////////
//
// Error codes
//
//////////////////////////////////////////////

`define NO_ERROR 4'h0
`define HALTED_ON_MEMORY_ERROR 4'h1
`define HALTED_ON_HALT 4'h2
`define HALTED_ON_ILLEGAL 4'h3


//////////////////////////////////////////////
//
// Datapath control signals
//
//////////////////////////////////////////////

//
// ALU opA input mux selects
//
`define ALU_OPA_IS_REGA         2'h0
`define ALU_OPA_IS_MEM_DISP     2'h1
`define ALU_OPA_IS_NPC          2'h2
`define ALU_OPA_IS_NOT3         2'h3

//
// ALU opB input mux selects
//
`define ALU_OPB_IS_REGB         2'h0
`define ALU_OPB_IS_ALU_IMM      2'h1
`define ALU_OPB_IS_BR_DISP      2'h2

//
// Destination register select
//
`define DEST_IS_REGC    2'h0
`define DEST_IS_REGA    2'h1
`define DEST_NONE       2'h2


//
// ALU function code input
// probably want to leave these alone
//
`define ALU_ADDQ        5'h00
`define ALU_SUBQ        5'h01
`define ALU_AND         5'h02
`define ALU_BIC         5'h03
`define ALU_BIS         5'h04
`define ALU_ORNOT       5'h05
`define ALU_XOR         5'h06
`define ALU_EQV         5'h07
`define ALU_SRL         5'h08
`define ALU_SLL         5'h09
`define ALU_SRA         5'h0a
`define ALU_MULQ        5'h0b
`define ALU_CMPEQ       5'h0c
`define ALU_CMPLT       5'h0d
`define ALU_CMPLE       5'h0e
`define ALU_CMPULT      5'h0f
`define ALU_CMPULE      5'h10

//////////////////////////////////////////////
//
// Assorted things it is not wise to change
//
//////////////////////////////////////////////

//
// actually, you might have to change this if you change VERILOG_CLOCK_PERIOD
//
`define SD #1


// the Alpha register file zero register, any read of this register always
// returns a zero value, and any write to this register is thrown away
//
`define REG_00          6'd0
`define REG_01          6'd1
`define REG_02          6'd2
`define REG_03          6'd3
`define REG_04          6'd4
`define REG_05          6'd5
`define REG_06          6'd6
`define REG_07          6'd7
`define REG_08          6'd8
`define REG_09          6'd9
`define REG_10          6'd10
`define REG_11          6'd11
`define REG_12          6'd12
`define REG_13          6'd13
`define REG_14          6'd14
`define REG_15          6'd15
`define REG_16          6'd16
`define REG_17          6'd17
`define REG_18          6'd18
`define REG_19          6'd19
`define REG_20          6'd20
`define REG_21          6'd21
`define REG_22          6'd22
`define REG_23          6'd23
`define REG_24          6'd24
`define REG_25          6'd25
`define REG_26          6'd26
`define REG_27          6'd27
`define REG_28          6'd28
`define REG_29          6'd29
`define REG_30          6'd30
`define ZERO_REG        6'd31

`define REG_32          6'd32
`define REG_33          6'd33
`define REG_34          6'd34
`define REG_35          6'd35
`define REG_36          6'd36
`define REG_37          6'd37
`define REG_38          6'd38
`define REG_39          6'd39
`define REG_40          6'd40
`define REG_41          6'd41
`define REG_42          6'd42
`define REG_43          6'd43
`define REG_44          6'd44
`define REG_45          6'd45
`define REG_46          6'd46
`define REG_47          6'd47
`define REG_48          6'd48
`define REG_49          6'd49
`define REG_50          6'd50
`define REG_51          6'd51
`define REG_52          6'd52
`define REG_53          6'd53
`define REG_54          6'd54
`define REG_55          6'd55
`define REG_56          6'd56
`define REG_57          6'd57
`define REG_58          6'd58
`define REG_59          6'd59
`define REG_60          6'd60
`define REG_61          6'd61
`define REG_62          6'd62
`define REG_63          6'd63



//
// Memory bus commands control signals
//
`define BUS_NONE       2'h0
`define BUS_LOAD       2'h1
`define BUS_STORE      2'h2

//
// useful boolean single-bit definitions
//
`define FALSE	1'h0
`define TRUE	1'h1

//
// Basic NOOP instruction.  Allows pipline registers to clearly be reset with
// an instruction that does nothing instead of Zero which is really a PAL_INST
//
`define NOOP_INST 32'h47ff041f

//
// top level opcodes, used by the IF stage to decode Alpha instructions
//
`define PAL_INST	6'h00
`define LDA_INST	6'h08
`define LDAH_INST	6'h09
`define LDBU_INST	6'h0a
`define LDQ_U_INST	6'h0b
`define LDWU_INST	6'h0c
`define STW_INST	6'h0d
`define STB_INST	6'h0e
`define STQ_U_INST	6'h0f
`define INTA_GRP	6'h10
`define INTL_GRP	6'h11
`define INTS_GRP	6'h12
`define INTM_GRP	6'h13
`define ITFP_GRP	6'h14	// unimplemented
`define FLTV_GRP	6'h15	// unimplemented
`define FLTI_GRP	6'h16	// unimplemented
`define FLTL_GRP	6'h17	// unimplemented
`define MISC_GRP	6'h18
`define JSR_GRP		6'h1a
`define FTPI_GRP	6'h1c
`define LDF_INST	6'h20
`define LDG_INST	6'h21
`define LDS_INST	6'h22
`define LDT_INST	6'h23
`define STF_INST	6'h24
`define STG_INST	6'h25
`define STS_INST	6'h26
`define STT_INST	6'h27
`define LDL_INST	6'h28
`define LDQ_INST	6'h29
`define LDL_L_INST	6'h2a
`define LDQ_L_INST	6'h2b
`define STL_INST	6'h2c
`define STQ_INST	6'h2d
`define STL_C_INST	6'h2e
`define STQ_C_INST	6'h2f
`define BR_INST		6'h30
`define FBEQ_INST	6'h31
`define FBLT_INST	6'h32
`define FBLE_INST	6'h33
`define BSR_INST	6'h34
`define FBNE_INST	6'h35
`define FBGE_INST	6'h36
`define FBGT_INST	6'h37
`define BLBC_INST	6'h38
`define BEQ_INST	6'h39
`define BLT_INST	6'h3a
`define BLE_INST	6'h3b
`define BLBS_INST	6'h3c
`define BNE_INST	6'h3d
`define BGE_INST	6'h3e
`define BGT_INST	6'h3f

// PALcode opcodes
`define PAL_HALT  26'h555
`define PAL_WHAMI 26'h3c

// INTA (10.xx) opcodes
`define ADDL_INST	7'h00
`define S4ADDL_INST	7'h02
`define SUBL_INST	7'h09
`define S4SUBL_INST	7'h0b
`define CMPBGE_INST	7'h0f
`define S8ADDL_INST	7'h12
`define S8SUBL_INST	7'h1b
`define CMPULT_INST	7'h1d
`define ADDQ_INST	7'h20
`define S4ADDQ_INST	7'h22
`define SUBQ_INST	7'h29
`define S4SUBQ_INST	7'h2b
`define CMPEQ_INST	7'h2d
`define S8ADDQ_INST	7'h32
`define S8SUBQ_INST	7'h3b
`define CMPULE_INST	7'h3d
`define ADDLV_INST	7'h40
`define SUBLV_INST	7'h49
`define CMPLT_INST	7'h4d
`define ADDQV_INST	7'h60
`define SUBQV_INST	7'h69
`define CMPLE_INST	7'h6d

// INTL (11.xx) opcodes
`define AND_INST	7'h00
`define BIC_INST	7'h08
`define CMOVLBS_INST	7'h14
`define CMOVLBC_INST	7'h16
`define BIS_INST	7'h20
`define CMOVEQ_INST	7'h24
`define CMOVNE_INST	7'h26
`define ORNOT_INST	7'h28
`define XOR_INST	7'h40
`define CMOVLT_INST	7'h44
`define CMOVGE_INST	7'h46
`define EQV_INST	7'h48
`define AMASK_INST	7'h61
`define CMOVLE_INST	7'h64
`define CMOVGT_INST	7'h66
`define IMPLVER_INST	7'h6c

// INTS (12.xx) opcodes
`define MSKBL_INST	7'h02
`define EXTBL_INST	7'h06
`define INSBL_INST	7'h0b
`define MSKWL_INST	7'h12
`define EXTWL_INST	7'h16
`define INSWL_INST	7'h1b
`define MSKLL_INST	7'h22
`define EXTLL_INST	7'h26
`define INSLL_INST	7'h2b
`define ZAP_INST	7'h30
`define ZAPNOT_INST	7'h31
`define MSKQL_INST	7'h32
`define SRL_INST	7'h34
`define EXTQL_INST	7'h36
`define SLL_INST	7'h39
`define INSQL_INST	7'h3b
`define SRA_INST	7'h3c
`define MSKWH_INST	7'h52
`define INSWH_INST	7'h57
`define EXTWH_INST	7'h5a
`define MSKLH_INST	7'h62
`define INSLH_INST	7'h67
`define EXTLH_INST	7'h6a
`define MSKQH_INST	7'h72
`define INSQH_INST	7'h77
`define EXTQH_INST	7'h7a

// INTM (13.xx) opcodes
`define MULL_INST	7'h00
`define MULQ_INST	7'h20
`define UMULH_INST	7'h30
`define MULLV_INST	7'h40
`define MULQV_INST	7'h60

// MISC (18.xx) opcodes
`define TRAPB_INST	16'h0000
`define EXCB_INST	16'h0400
`define MB_INST		16'h4000
`define WMB_INST	16'h4400
`define FETCH_INST	16'h8000
`define FETCH_M_INST	16'ha000
`define RPCC_INST	16'hc000
`define RC_INST		16'he000
`define ECB_INST	16'he800
`define RS_INST		16'hf000
`define WH64_INST	16'hf800

// JSR (1a.xx) opcodes
`define JMP_INST	2'h0
`define JSR_INST	2'h1
`define RET_INST	2'h2
`define JSR_CO_INST	2'h3
