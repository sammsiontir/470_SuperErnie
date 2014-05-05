# Given no targets, 'make' will default to building 'simv', the simulated version
# of the pipeline

# make          <- compile simv if needed (but do not run)

# As shortcuts, any of the following will build if necessary and then run the
# specified target

# make sim      <- runs simv (after compiling simv if needed)
# make vis      <- runs the "visual" debugger (visual/)
# make dve      <- runs int_simv interactively (after compiling it if needed)
# make syn      <- runs syn_simv (after synthesizing if needed then 
#                                 compiling synsimv if needed)
# make syn_dve  <- runs DVE on synthesized code


# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
# 

################################################################################
## CONFIGURATION
################################################################################

VCS = SW_VCS=2011.03 vcs +vcs+loopreport +v2k +vc -Mupdate -line -full64
LIB = /usr/caen/generic/mentor_lib-D.1/public/eecs470/verilog/lec25dscc25.v
INTFLAGS = -I +memcbk

SYNTH_DIR = ./synth

PROGRAM = test_progs/evens.s
ASSEMBLED = program.mem
ASSEMBLER = vs-asm

# SIMULATION CONFIG

HEADERS     = $(wildcard *.vh)
TESTBENCH   = $(wildcard testbench/*.v)
TESTBENCH  += $(wildcard testbench/*.c)
PIPEFILES   = $(wildcard verilog/*.v)
PIPEFILES   += $(wildcard verilog/*.vg)
DCACHEFILES  = $(wildcard verilog/dcache/*.vg)
ICACHEFILES  = $(wildcard verilog/icache/*.vg)

SIMFILES    = $(PIPEFILES) $(DCACHEFILES) $(ICACHEFILES)

# SYNTHESIS CONFIG

export HEADERS
export PIPEFILES
export DCACHEFILES
export ICACHEFILES

export DCACHE_NAME = cache
export ICACHE_NAME = icachemem
export PIPELINE_NAME = pipeline

PIPELINE  = $(SYNTH_DIR)/$(PIPELINE_NAME).vg
DCACHE     = $(SYNTH_DIR)/$(DCACHE_NAME).vg
ICACHE     = $(SYNTH_DIR)/$(ICACHE_NAME).vg

# Passed through to .tcl scripts:
export CLOCK_NET_NAME = clock
export RESET_NET_NAME = reset
export CLOCK_PERIOD = 20 # TODO: You will want to make this more aggresive

################################################################################
## RULES
################################################################################

# Default target:
all:    simv

.PHONY: all

# Simulation:

sim:	simv $(ASSEMBLED)
	./simv | tee sim_program.out

simv:	$(HEADERS) $(SIMFILES) $(TESTBENCH)
	$(VCS) $^ $(LIB) -o simv

.PHONY: sim

# Programs

$(ASSEMBLED):	$(PROGRAM)
	./$(ASSEMBLER) < $< > $@

# Synthesis

$(DCACHE): $(DCACHEFILES) $(SYNTH_DIR)/$(DCACHE_NAME).tcl
	cd $(SYNTH_DIR) && dc_shell-t -f ./$(DCACHE_NAME).tcl | tee $(DCACHE_NAME)_synth.out

$(ICACHE): $(ICACHEFILES) $(SYNTH_DIR)/$(ICACHE_NAME).tcl
	cd $(SYNTH_DIR) && dc_shell-t -f ./$(ICACHE_NAME).tcl | tee $(ICACHE_NAME)_synth.out

$(PIPELINE): $(SIMFILES) $(DCACHE) $(ICACHE) $(SYNTH_DIR)/$(PIPELINE_NAME).tcl
	cd $(SYNTH_DIR) && dc_shell-t -f ./$(PIPELINE_NAME).tcl | tee $(PIPELINE_NAME)_synth.out
	echo -e -n 'H\n1\ni\n`timescale 1ns/100ps\n.\nw\nq\n' | ed $(PIPELINE)

syn:	syn_simv $(ASSEMBLED)
	./syn_simv | tee syn_program.out

syn_simv:	$(HEADERS) $(PIPELINE) $(TESTBENCH)
	$(VCS) $^ $(LIB) -o syn_simv 

.PHONY: syn

# Debugging

dve_simv:	$(HEADERS) $(SIMFILES) $(TESTBENCH)
	$(VCS) +memcbk $^ $(LIB) -o $@ -R -gui

dve:	dve_simv $(ASSEMBLED)
#	./$<

dve_syn_simv:	$(HEADERS) $(PIPELINE) $(TESTBENCH)
	$(VCS) +memcbk $^ $(LIB) -o $@ -R -gui

dve_syn:	dve_syn_simv $(ASSEMBLED)
	./$<

# For visual debugger
VISFLAGS = -lncurses
VISTESTBENCH = $(TESTBENCH:testbench.v=visual/visual_testbench.v) \
		testbench/visual/visual_c_hooks.c
vis_simv:	$(HEADERS) $(SIMFILES) $(VISTESTBENCH)
	$(VCS) $(VISFLAGS) $^ -o vis_simv
vis:	vis_simv $(ASSEMBLED)
	./vis_simv

.PHONY: dve syn_dve vis

clean:
	rm -rf simv simv.daidir csrc vcs.key ucli.key
	rm -rf vis_simv vis_simv.daidir
	rm -rf syn_simv syn_simv.daidir
	rm -f *.out
	rm -rf int_simv int_simv.daidir syn_int_simv syn_int_simv.daidir
	rm -rf synsimv synsimv.daidir csrc vcdplus.vpd vcs.key synprog.out pipeline.out writeback.out vc_hdrs.h
	rm -rf dve_simv dve_syn_simv dve_simv.daidir DVEfiles dve_syn_simv.daidir

nuke:	clean
	rm -f $(SYNTH_DIR)/*.vg $(SYNTH_DIR)/*.rep $(SYNTH_DIR)/*.db $(SYNTH_DIR)/*.chk $(SYNTH_DIR)/command.log
	rm -f $(SYNTH_DIR)/*.out $(SYNTH_DIR)/*.ddc $(SYNTH_DIR)/*.log
	rm -f $(ASSEMBLED)

.PHONY: clean nuke dve
