
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

# These files were generated from QSYS interface of ADC core module 
# in "board/de10_lite/project/de10_lite_adc" project and then copied to testbench/adc_max10 folder.
# Run "board/de10_lite/make_project.bat" to create this project
set s5 ../../../testbench/adc_max10/*.v

vlog $p0 $p1  $i0 $i1 $i2 $i3 $i4  $s0 $s1 $s2 $s3 $s4 $s5

set L0 altera_mf_ver
set L1 fiftyfivenm_ver

vsim -L $L0 -L $L1 work.mfp_testbench 

add wave -radix hex sim:/mfp_testbench/*

add wave -radix hex sim:/mfp_testbench/system/SI_TimerInt
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/compare
add wave -height 74 -radix hex -format analog-step -scale 0.015 sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/count

run -all

wave zoom full
