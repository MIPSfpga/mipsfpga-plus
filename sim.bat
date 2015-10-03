rd /s /q sim
md sim
cd sim

vlib work
vlog +define+MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION -vlog01compat +incdir+.. +incdir+../../../MIPSfpga/rtl_up ../../../MIPSfpga/rtl_up/*.v ../*.v >> z
type z

copy C:\MIPSfpga\rtl_up\initfiles\1_IncrementLEDs\*.txt .

vsim -c -do "run -all" mfp_testbench
