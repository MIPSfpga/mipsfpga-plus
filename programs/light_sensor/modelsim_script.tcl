vlib work
vlog -vlog01compat +define+MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION +incdir+../../../../../MIPSfpga/rtl_up +incdir+../../.. ../../../../../MIPSfpga/rtl_up/*.v ../../../*.v
vsim work.mfp_testbench
add wave sim:/mfp_testbench/*
run -all
