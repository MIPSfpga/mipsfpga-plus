
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

add wave -radix hex sim:/mfp_testbench/system/SI_TimerInt
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/compare
add wave -height 74 -radix hex -format analog-step -scale 0.015 sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/count

add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_Interrupt
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_Offset
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_Present
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_ShadowSet
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_Vector
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_IAck
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_IPL
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_IVN
add wave -radix hex sim:/mfp_testbench/system/ahb_lite_matrix/ahb_lite_matrix/eic/EIC_ION

add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/cpz_vectoroffset

run -all

wave zoom full
