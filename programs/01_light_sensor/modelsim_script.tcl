
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

run -all

wave zoom full
