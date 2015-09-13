rd /s /q sim
md sim
cd sim

vlib work
vlog +define+MFP_INITIALIZE_MEMORY_FROM_TXT_FILE -vlog01compat +incdir+.. ../*.v >> z
type z
vsim -c -do "run -all" mfp_ahb_lite_matrix
