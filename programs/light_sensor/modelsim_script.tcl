vlib work
vlog -vlog01compat +define+MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION +define+MFP_RAM_RESET_INIT_FILENAME="program_bfc00000.hex" +define+MFP_RAM_INIT_FILENAME="program_80000000.hex" +incdir+../../../../../MIPSfpga/rtl_up +incdir+../../.. ../../../../../MIPSfpga/rtl_up/*.v ../../../*.v
vsim work.mfp_testbench
add wave sim:/mfp_testbench/*
run -all
