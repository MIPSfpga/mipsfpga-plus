
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

add wave -radix hex sim:/mfp_testbench/system/SI_TimerInt
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/compare
add wave -height 74 -radix hex -format analog-step -scale 0.015 sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/count

add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_Interrupt
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_Offset
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_Present
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_ShadowSet
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_Vector
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_IAck
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_IPL
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_IVN
add wave -radix hex sim:/mfp_testbench/system/matrix_loader/matrix/eic/EIC_ION

add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/cpz_vectoroffset

add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/cause32
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/badva
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/status32
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz/cpz_eretpc 
add wave -radix hex sim:/mfp_testbench/system/m14k_top/cpu/core/cpz_epc_w 

run -all

wave zoom full
