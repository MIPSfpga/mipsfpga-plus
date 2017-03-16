
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

run -all

wave zoom full
