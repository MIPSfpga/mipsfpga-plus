vlib work
vlog -vlog01compat +define+SIMULATION +incdir+../../../../../MIPSfpga/rtl_up +incdir+../../.. +incdir+../../../uart16550 ../../../../../MIPSfpga/rtl_up/*.v ../../../*.v ../../../testbench/sdr_sdram/*.v ../../../uart16550/*.v
vsim work.mfp_testbench
add wave sim:/mfp_testbench/*
run -all
