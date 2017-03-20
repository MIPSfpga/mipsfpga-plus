
vlib work

set p0 -vlog01compat
set p1 +define+SIMULATION

set i0 +incdir+../../../../../MIPSfpga/rtl_up
set i1 +incdir+../../..
set i2 +incdir+../../../sdr_sdram
set i3 +incdir+../../../uart16550

set s0 ../../../../../MIPSfpga/rtl_up/*.v
set s1 ../../../*.v
set s2 ../../../sdr_sdram/*.v
set s3 ../../../uart16550/*.v

vlog $p0 $p1  $i0 $i1 $i2 $i3  $s0 $s1 $s2 $s3

vsim work.mfp_testbench

add wave -radix hex sim:/mfp_testbench/*

add wave -radix hex -label HADDR        sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HADDR 
add wave -radix hex -label HBURST       sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HBURST 
add wave -radix hex -label HMASTLOCK    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HMASTLOCK 
add wave -radix hex -label HPROT        sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HPROT 

add wave -radix hex -label HSEL_RST     {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[0]}
add wave -radix hex -label HSEL_MEM     {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[1]}
add wave -radix hex -label HSEL_GPIO    {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[2]}
add wave -radix hex -label HSEL_UART    {sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSEL[3]}

add wave -radix hex -label HSIZE    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HSIZE 
add wave -radix hex -label HTRANS   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HTRANS 
add wave -radix hex -label HWDATA   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HWDATA 
add wave -radix hex -label HWRITE   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HWRITE 
add wave -radix hex -label HRDATA   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HRDATA 
add wave -radix hex -label HREADY   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HREADY 
add wave -radix hex -label HRESP    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/HRESP 

add wave -radix hex -label UART_TX    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/UART_TX

add wave -radix hex -label ActionAddr   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/ActionAddr
add wave -radix hex -label WriteData    sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/WriteData
add wave -radix hex -label ReadData     sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/ReadData
add wave -radix hex -label WriteAction  sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/WriteAction
add wave -radix hex -label ReadAction   sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/ReadAction
add wave -radix hex -label UART_INT     sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/uart/UART_INT

run -all

wave zoom full
