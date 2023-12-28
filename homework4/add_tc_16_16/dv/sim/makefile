.PHONY : default help clean regress_clean sim verdi


default: sim 

mkfile_lastword := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_path := $(dir $(mkfile_lastword))
SIMDIR := $(patsubst %/,%,$(mkfile_path))
export SIMDIR
export PROJ_PATH=$(mkfile_path)../..

# DESIGN_PATH is used for separating ASIC design and FPGA design
export DESIGN_PATH=$(PROJ_PATH)/design

WAVE_DIR   = $(SIMDIR)/wave
COV_DIR   = $(SIMDIR)/coverage
LOG_DIR   = $(SIMDIR)/log

FSDB = $(fsdb)
SEED = $(seed)
WAVE = $(wave)


#=============== These maybe modified manually for your new project ============
# RTL_PATH is used for filelist
export RTL_PATH=$(DESIGN_PATH)/add_tc_16_16
export TB_SRC_DIR=$(SIMDIR)/../tb

TOP := add_tc_16_16_tb
DUT_SRC := -f $(DESIGN_PATH)/filelist/add_tc_16_16.lst
TB_SRC 	:= -f $(TB_SRC_DIR)/filelist/tb.lst

TB_CMP_OPTIONS += -full64 +lint=TFIPC-L \
				  -lca +v2k -v2005 -sverilog \
				  -fsdb -timescale=1ns/10ps \
				  -R \
				  -debug_all -debug_acc+dmptf \
				  -debug_region+cell+encrypt \
				  +notimingcheck +nospecify

TB_CMP_OPTIONS += -j16

# parameter transfer to rtl when siaddate
#TB_SIM_OPTIONS :=+=firmware=$(IMGDIR)/$(UNI_TC_NAME).hex
TB_SIM_OPTIONS := -ucli -i $(SIMDIR)/cmd.ucli

# define transfer to rtl when compile
#TB_CMP_DEF_OPTIONS := define+RTL

#===============================================================================

TB_SIM_EXEC += ./simv  +vcs+loopreport+1000

ifneq ($(TOP),)
	TB_CMP_OPTIONS += -top $(TOP)
endif


DIR_MK_OPT     += @mkdir -p log wave output


# Generate a random id for this compile or siaddate operation.
ifeq ($(SEED),)
  SEED=$(shell $(SIMDIR)/../bin/rand.pl )
  export SEED
endif
TB_TEST_ID = $(strip $(TOP))_$(strip $(SEED))

export WAVE_NAME = $(WAVE_DIR)/$(TB_TEST_ID).fsdb

TB_CMP_LOG = $(SIMDIR)/log/$(TB_TEST_ID)_compile.log
TB_CMP_OPTIONS += -l $(TB_CMP_LOG)


compile :
	$(DIR_MK_OPT)
	vcs $(TB_CMP_OPTIONS)  \
	$(TB_CMP_DEF_OPTIONS)  \
	$(DUT_SRC) \
	$(TB_SRC) 

run     :
	$(TB_SIM_EXEC) \
	$(TB_SIM_OPTIONS)

sim : compile run

verdi : 
	verdi -ssv -ssy -2012  \
		-lca $(DUT_SRC) $(TB_SRC) $(TB_CMP_DEF_OPTIONS) -l $(SIMDIR)/log/verdi.log \
		-top $(TOP) &

clean : 
	rm -rf ./csrc
	rm -rf ./wave
	rm -rf ./log
	rm -rf ./output
	rm -rf ./simv.daidir
	rm -rf ./verdiLog
	rm -rf ./simv
	rm -rf ./novas*
	rm -rf ./ucli.key
	rm -rf ./log/*
	rm -rf ./*.log
	rm -rf ./AN.DB ./simv.cst ./simv.vdb vc_hdrs.h ucli.key
	rm -rf log.*











