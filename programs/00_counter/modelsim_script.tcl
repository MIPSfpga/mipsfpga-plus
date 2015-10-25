vlib work
vlog -vlog01compat +define+MFP_USE_WORD_MEMORY +incdir+../../../../../MIPSfpga/rtl_up +incdir+../../.. ../../../../../MIPSfpga/rtl_up/*.v ../../../*.v
vsim work.mfp_testbench
add wave sim:/mfp_testbench/*
run -all
