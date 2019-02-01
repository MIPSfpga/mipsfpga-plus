
# MIPSfpga-plus makefile
# Stanislav Zhelnio, 2019

help: info
	$(info make help   - show this message)
	$(info make all    - clean, create the board project and run the synthesis)
	$(info make clean  - delete synth folder)
	$(info make create - create the board project)
	$(info make open   - open the board project)
	$(info make build  - build the board project)
	$(info make load   - program the FPGA board)
	@true

BUILD_DIR    ?= project
PROJECT_NAME ?= system
OPT_VIVADO    = -mode batch
BIN_VIVADO    = cd $(BUILD_DIR) && vivado

all: create build

info:
	@echo "Be careful, the MFP_USE_SLOW_CLOCK_AND_CLOCK_MUX is enabled in the Digilent board top module."
	@echo "To disable it add the PLL IP to the design and change the board top source"
	@echo ""

clean:
	rm -rf $(BUILD_DIR)

create: info
	rm -rf $(BUILD_DIR)
	mkdir  $(BUILD_DIR)
	$(BIN_VIVADO) $(OPT_VIVADO) -source $(CURDIR)/system_create.tcl

open:
	$(BIN_VIVADO) $(PROJECT_NAME).xpr &

build:
	$(BIN_VIVADO) $(OPT_VIVADO) -source $(CURDIR)/system_synth.tcl

load:
	$(BIN_VIVADO) $(OPT_VIVADO) -source $(CURDIR)/system_load.tcl
