


vlib work
vlog -vlog01compat +define+SIMULATION +incdir+../../../../../MIPSfpga/rtl_up +incdir+../../.. ../../../../../MIPSfpga/rtl_up/*.v ../../../*.v
vsim work.mfp_testbench

add wave -radix hex sim:/mfp_testbench/*

add wave -radix hex -label HADDR    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HADDR 
add wave -radix hex -label HBURST   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HBURST 
add wave -radix hex -label HMASTLOCK sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HMASTLOCK 
add wave -radix hex -label HPROT    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HPROT 

add wave -radix hex -label HSEL_RST     {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[0]}
add wave -radix hex -label HSEL_MEM     {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[1]}
add wave -radix hex -label HSEL_GPIO    {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[2]}

add wave -radix hex -label HSIZE    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSIZE 
add wave -radix hex -label HTRANS   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HTRANS 
add wave -radix hex -label HWDATA   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HWDATA 
add wave -radix hex -label HWRITE   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HWRITE 
add wave -radix hex -label HRDATA   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HRDATA 
add wave -radix hex -label HREADY   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HREADY 
add wave -radix hex -label HRESP    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HRESP 

run -all

