rd /s /q sim
md sim
cd sim

vlib work
vlog +define+MFP_INITIALIZE_MEMORY_FROM_TXT_FILE -vlog01compat +incdir+.. +incdir+../../../MIPSfpga/rtl_up ../../../MIPSfpga/rtl_up/*.v ../*.v >> z
type z

copy ..\*.txt .
vsim

