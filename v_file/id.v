/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  id_stage.v                                          //
//                                                                     //
//  Description :  instruction decode (ID) stage of the pipeline;      // 
//                 decode the instruction fetch register operands, and // 
//                 compute immediate operand (if applicable)           // 
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps


  // Decode an instruction: given instruction bits IR produce the
  // appropriate datapath control signals.
  //
  // This is a *combinational* module (basically a PLA).
  //
module decoder(// Inputs
               inst,
               valid_inst_in,  // ignore inst when low, outputs will
                               // reflect noop (except valid_inst)

               // Outputs
               opa_select,
               opb_select,
               alu_func,
               dest_reg,
               rd_mem,
               wr_mem,
               ldl_mem,
               stc_mem,
               cond_branch,
               uncond_branch,
               halt,           // non-zero on a halt
               cpuid,          // get CPUID instruction
               illegal,        // non-zero on an illegal instruction 
               valid_inst      // for counting valid instructions executed
                               // and for making the fetch stage die on halts/
                               // keeping track of when to allow the next
                               // instruction out of fetch
                               // 0 for HALT and illegal instructions (die on halt)
              );

  input [31:0] inst;
  input valid_inst_in;

  output [1:0] opa_select, opb_select, dest_reg; // mux selects
  output [4:0] alu_func;
  output rd_mem, wr_mem, ldl_mem, stc_mem, cond_branch, uncond_branch, halt;
  output cpuid, illegal, valid_inst;

  reg [1:0] opa_select, opb_select, dest_reg; // mux selects
  reg [4:0] alu_func;
  reg rd_mem, wr_mem, ldl_mem, stc_mem, cond_branch, uncond_branch;
  reg cpuid, halt, illegal;

  assign valid_inst = valid_inst_in & ~illegal;
  always @*
  begin
      // default control values:
      // - valid instructions must override these defaults as necessary.
      //   opa_select, opb_select, and alu_func should be set explicitly.
      // - invalid instructions should clear valid_inst.
      // - These defaults are equivalent to a noop
      // * see sys_defs.vh for the constants used here
    opa_select = 2'd0;
    opb_select = 2'd0;
    alu_func = 5'd0;
    dest_reg = `DEST_NONE;
    rd_mem = `FALSE;
    wr_mem = `FALSE;
    ldl_mem = `FALSE;
    stc_mem = `FALSE;
    cond_branch = `FALSE;
    uncond_branch = `FALSE;
    halt = `FALSE;
    cpuid = `FALSE;
    illegal = `FALSE;
    if(valid_inst_in)
    begin
      case ({inst[31:29], 3'b0})
        6'h0:
          case (inst[31:26])
            `PAL_INST: begin
               if (inst[25:0] == `PAL_HALT)
                 halt = `TRUE;
               else if (inst[25:0] == `PAL_WHAMI) begin
                 cpuid = `TRUE;
                 dest_reg = `DEST_IS_REGA;   // get cpuid writes to r0
               end else
                 illegal = `TRUE;
              end
            default: illegal = `TRUE;
          endcase // case(inst[31:26])
         
        6'h10:
          begin
            opa_select = `ALU_OPA_IS_REGA;
            opb_select = inst[12] ? `ALU_OPB_IS_ALU_IMM : `ALU_OPB_IS_REGB;
            dest_reg = `DEST_IS_REGC;
            case (inst[31:26])
              `INTA_GRP:
                 case (inst[11:5])
                   `CMPULT_INST:  alu_func = `ALU_CMPULT;
                   `ADDQ_INST:    alu_func = `ALU_ADDQ;
                   `SUBQ_INST:    alu_func = `ALU_SUBQ;
                   `CMPEQ_INST:   alu_func = `ALU_CMPEQ;
                   `CMPULE_INST:  alu_func = `ALU_CMPULE;
                   `CMPLT_INST:   alu_func = `ALU_CMPLT;
                   `CMPLE_INST:   alu_func = `ALU_CMPLE;
                    default:      illegal = `TRUE;
                  endcase // case(inst[11:5])
              `INTL_GRP:
                case (inst[11:5])
                  `AND_INST:    alu_func = `ALU_AND;
                  `BIC_INST:    alu_func = `ALU_BIC;
                  `BIS_INST:    alu_func = `ALU_BIS;
                  `ORNOT_INST:  alu_func = `ALU_ORNOT;
                  `XOR_INST:    alu_func = `ALU_XOR;
                  `EQV_INST:    alu_func = `ALU_EQV;
                  default:      illegal = `TRUE;
                endcase // case(inst[11:5])
              `INTS_GRP:
                case (inst[11:5])
                  `SRL_INST:  alu_func = `ALU_SRL;
                  `SLL_INST:  alu_func = `ALU_SLL;
                  `SRA_INST:  alu_func = `ALU_SRA;
                  default:    illegal = `TRUE;
                endcase // case(inst[11:5])
              `INTM_GRP:
                case (inst[11:5])
                  `MULQ_INST:       alu_func = `ALU_MULQ;
                  default:          illegal = `TRUE;
                endcase // case(inst[11:5])
              `ITFP_GRP:       illegal = `TRUE;       // unimplemented
              `FLTV_GRP:       illegal = `TRUE;       // unimplemented
              `FLTI_GRP:       illegal = `TRUE;       // unimplemented
              `FLTL_GRP:       illegal = `TRUE;       // unimplemented
            endcase // case(inst[31:26])
          end
           
        6'h18:
          case (inst[31:26])
            `MISC_GRP:       illegal = `TRUE; // unimplemented
            `JSR_GRP:
               begin
                 // JMP, JSR, RET, and JSR_CO have identical semantics
                 opa_select = `ALU_OPA_IS_NOT3;
                 opb_select = `ALU_OPB_IS_REGB;
                 alu_func = `ALU_AND; // clear low 2 bits (word-align)
                 dest_reg = `DEST_IS_REGA;
                 uncond_branch = `TRUE;
               end
            `FTPI_GRP:       illegal = `TRUE;       // unimplemented
           endcase // case(inst[31:26])
           
        6'h08, 6'h20, 6'h28:
          begin
            opa_select = `ALU_OPA_IS_MEM_DISP;
            opb_select = `ALU_OPB_IS_REGB;
            alu_func = `ALU_ADDQ;
            dest_reg = `DEST_IS_REGA;
            case (inst[31:26])
              `LDA_INST:  /* defaults are OK */;
              `LDQ_INST:
                begin
                  rd_mem = `TRUE;
                  dest_reg = `DEST_IS_REGA;
                end // case: `LDQ_INST
              `LDQ_L_INST:
                begin
                  rd_mem = `TRUE;
                  ldl_mem = `TRUE;
                  dest_reg = `DEST_IS_REGA;
                end // case: `LDQ_L_INST
              `STQ_INST:
                begin
                  wr_mem = `TRUE;
                  dest_reg = `DEST_NONE;
                end // case: `STQ_INST
              `STQ_C_INST:
                begin
                  wr_mem = `TRUE;
                  stc_mem = `TRUE;
                  dest_reg = `DEST_IS_REGA;
                end // case: `STQ_INST
              default:       illegal = `TRUE;
            endcase // case(inst[31:26])
          end
           
        6'h30, 6'h38:
          begin
            opa_select = `ALU_OPA_IS_NPC;
            opb_select = `ALU_OPB_IS_BR_DISP;
            alu_func = `ALU_ADDQ;
            case (inst[31:26])
              `FBEQ_INST, `FBLT_INST, `FBLE_INST,
              `FBNE_INST, `FBGE_INST, `FBGT_INST:
                begin
                  // FP conditionals not implemented
                  illegal = `TRUE;
                end
                 
              `BR_INST, `BSR_INST:
                begin
                  dest_reg = `DEST_IS_REGA;
                  uncond_branch = `TRUE;
                end
  
              default:
                cond_branch = `TRUE; // all others are conditional
            endcase // case(inst[31:26])
          end
      endcase // case(inst[31:29] << 3)
    end // if(~valid_inst_in)
  end // always
   
endmodule // decoder


module id(// Inputs
          clock,
          reset,
          if_id_IR,
          if_id_valid_inst,

          // Outputs
          id_ra_reg_idx_out,
          id_rb_reg_idx_out,
          id_opa_select_out,
          id_opb_select_out,
          id_dest_reg_idx_out,
          id_alu_func_out,
          id_rd_mem_out,
          id_wr_mem_out,
          id_cond_branch_out,
          id_uncond_branch_out,
          id_halt_out,
          id_illegal_out,
          id_valid_inst_out
         );


  input         clock;                // system clock
  input         reset;                // system reset
  input  [31:0] if_id_IR;             // incoming instruction
  input         if_id_valid_inst;

  output  [4:0] id_ra_reg_idx_out;    // A register index
  output  [4:0] id_rb_reg_idx_out;    // B register index
  output  [1:0] id_opa_select_out;    // ALU opa mux select (ALU_OPA_xxx *)
  output  [1:0] id_opb_select_out;    // ALU opb mux select (ALU_OPB_xxx *)
  output  [4:0] id_dest_reg_idx_out;  // destination (writeback) register index
                                      // (ZERO_REG if no writeback)
  output  [4:0] id_alu_func_out;      // ALU function select (ALU_xxx *)
  output        id_rd_mem_out;        // does inst read memory?
  output        id_wr_mem_out;        // does inst write memory?


  output        id_cond_branch_out;   // is inst a conditional branch?
  output        id_uncond_branch_out; // is inst an unconditional branch 
                                      // or jump?
  output        id_halt_out;

  output        id_illegal_out;
  output        id_valid_inst_out;    // is inst a valid instruction to be 
                                      // counted for CPI calculations?
   
  wire    [1:0] dest_reg_select;
  reg     [4:0] id_ra_reg_idx_out;       // A register index
  reg     [4:0] id_rb_reg_idx_out;       // B register index
  reg     [4:0] id_dest_reg_idx_out;     // not state: behavioral mux output
   
  // instruction fields read from IF/ID pipeline register
  wire    [4:0] ra_idx = if_id_IR[25:21];   // inst operand A register index
  wire    [4:0] rb_idx = if_id_IR[20:16];   // inst operand B register index
  wire    [4:0] rc_idx = if_id_IR[4:0];     // inst operand C register index


  // instantiate the instruction decoder
  decoder decoder_0 (// Input
                     .inst(if_id_IR),
                     .valid_inst_in(if_id_valid_inst),

                     // Outputs
                     .opa_select(id_opa_select_out),
                     .opb_select(id_opb_select_out),
                     .alu_func(id_alu_func_out),
                     .dest_reg(dest_reg_select),
                     .rd_mem(id_rd_mem_out),
                     .wr_mem(id_wr_mem_out),
                     .ldl_mem(id_ldl_mem_out),
                     .stc_mem(id_stc_mem_out),
                     .cond_branch(id_cond_branch_out),
                     .uncond_branch(id_uncond_branch_out),
                     .halt(id_halt_out),
                     .cpuid(id_cpuid_out),
                     .illegal(id_illegal_out),
                     .valid_inst(id_valid_inst_out)
                    );

  // reg A mux
  always @*
  begin
    case (id_opa_select_out)
      `ALU_OPA_IS_REGA:     id_ra_reg_idx_out = ra_idx;
      `ALU_OPA_IS_MEM_DISP: id_ra_reg_idx_out = ra_idx;
      `ALU_OPA_IS_NPC:      id_ra_reg_idx_out = ra_idx;
      `ALU_OPA_IS_NOT3:     id_ra_reg_idx_out = `ZERO_REG;
    endcase
  end
  // reg B mux
  always @*
  begin
    id_rb_reg_idx_out = `ZERO_REG;
    case (id_opb_select_out)
      `ALU_OPB_IS_REGB:    id_rb_reg_idx_out = rb_idx;
      `ALU_OPB_IS_ALU_IMM: id_rb_reg_idx_out = `ZERO_REG;
      `ALU_OPB_IS_BR_DISP: id_rb_reg_idx_out = `ZERO_REG;
    endcase 
  end

  // mux to generate dest_reg_idx based on
  // the dest_reg_select output from decoder
  always @*
    begin
      case (dest_reg_select)
        `DEST_IS_REGC: id_dest_reg_idx_out = rc_idx;
        `DEST_IS_REGA: id_dest_reg_idx_out = ra_idx;
        `DEST_NONE:    id_dest_reg_idx_out = `ZERO_REG;
        default:       id_dest_reg_idx_out = `ZERO_REG; 
      endcase
    end

endmodule // module id_stage
