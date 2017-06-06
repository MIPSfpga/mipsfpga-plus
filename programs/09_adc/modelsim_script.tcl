
vlib work

# Please set your path to Quartus dir before script running
set QUARTUS_INSTALL_DIR "D:/altera_lite/16.1/quartus/"

if ![file isdirectory $QUARTUS_INSTALL_DIR] {   
    echo "Quartus not found! Check run settings in .tcl script"
}

vlib work

# Quartus files that are used for ADC simulation
vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib//altera_mf.v"
vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/fiftyfivenm_atoms.v"
vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/fiftyfivenm_atoms_ncrypt.v"

# These files can be generated from QSYS interface of ADC core module 
# in "board/de10_lite/project/de10_lite_adc" project
# Run "board/de10_lite/make_project.bat" to create this project
vlog     ../../../testbench/adc_max10/altera_modular_adc_control.v
vlog     ../../../testbench/adc_max10/altera_modular_adc_control_avrg_fifo.v
vlog     ../../../testbench/adc_max10/altera_modular_adc_control_fsm.v
vlog     ../../../testbench/adc_max10/chsel_code_converter_sw_to_hw.v
vlog     ../../../testbench/adc_max10/fiftyfivenm_adcblock_primitive_wrapper.v
vlog     ../../../testbench/adc_max10/fiftyfivenm_adcblock_top_wrapper.v
vlog     ../../../testbench/adc_max10/adc_core_modular_adc_0.v
vlog     ../../../testbench/adc_max10/adc_core.v

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
