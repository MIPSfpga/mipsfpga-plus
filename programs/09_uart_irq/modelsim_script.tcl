
vlib work

set p0 -vlog01compat
set p1 +define+SIMULATION

set i0 +incdir+../../../core
set i1 +incdir+../../../system_rtl
set i2 +incdir+../../../system_rtl/uart16550
set i3 +incdir+../../../testbench
set i4 +incdir+../../../testbench/sdr_sdram

set s0 ../../../core/*.v
set s1 ../../../system_rtl/*.v
set s2 ../../../system_rtl/uart16550/*.v
set s3 ../../../testbench/*.v
set s4 ../../../testbench/sdr_sdram/*.v

vlog $p0 $p1  $i0 $i1 $i2 $i3 $i4  $s0 $s1 $s2 $s3 $s4

vsim work.mfp_testbench

add wave -radix hex sim:/mfp_testbench/*

add wave -radix hex -label HADDR        sim:/mfp_testbench/system/matrix_loader/matrix/HADDR 
add wave -radix hex -label HBURST       sim:/mfp_testbench/system/matrix_loader/matrix/HBURST 
add wave -radix hex -label HMASTLOCK    sim:/mfp_testbench/system/matrix_loader/matrix/HMASTLOCK 
add wave -radix hex -label HPROT        sim:/mfp_testbench/system/matrix_loader/matrix/HPROT 

add wave -radix hex -label HSEL_RST     {sim:/mfp_testbench/system/matrix_loader/matrix/HSEL[0]}
add wave -radix hex -label HSEL_MEM     {sim:/mfp_testbench/system/matrix_loader/matrix/HSEL[1]}
add wave -radix hex -label HSEL_GPIO    {sim:/mfp_testbench/system/matrix_loader/matrix/HSEL[2]}
add wave -radix hex -label HSEL_UART    {sim:/mfp_testbench/system/matrix_loader/matrix/HSEL[3]}

add wave -radix hex -label HSIZE    sim:/mfp_testbench/system/matrix_loader/matrix/HSIZE 
add wave -radix hex -label HTRANS   sim:/mfp_testbench/system/matrix_loader/matrix/HTRANS 
add wave -radix hex -label HWDATA   sim:/mfp_testbench/system/matrix_loader/matrix/HWDATA 
add wave -radix hex -label HWRITE   sim:/mfp_testbench/system/matrix_loader/matrix/HWRITE 
add wave -radix hex -label HRDATA   sim:/mfp_testbench/system/matrix_loader/matrix/HRDATA 
add wave -radix hex -label HREADY   sim:/mfp_testbench/system/matrix_loader/matrix/HREADY 
add wave -radix hex -label HRESP    sim:/mfp_testbench/system/matrix_loader/matrix/HRESP 

add wave -radix hex -label UART_TX    sim:/mfp_testbench/system/matrix_loader/matrix/UART_TX

add wave -radix hex -label ActionAddr   sim:/mfp_testbench/system/matrix_loader/matrix/uart/ActionAddr
add wave -radix hex -label WriteData    sim:/mfp_testbench/system/matrix_loader/matrix/uart/WriteData
add wave -radix hex -label ReadData     sim:/mfp_testbench/system/matrix_loader/matrix/uart/ReadData
add wave -radix hex -label WriteAction  sim:/mfp_testbench/system/matrix_loader/matrix/uart/WriteAction
add wave -radix hex -label ReadAction   sim:/mfp_testbench/system/matrix_loader/matrix/uart/ReadAction
add wave -radix hex -label UART_INT     sim:/mfp_testbench/system/matrix_loader/matrix/uart/UART_INT

run -all

wave zoom full
