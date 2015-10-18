rd /s /q sim
md sim
cd sim

copy C:\MIPSfpga\rtl_up\initfiles\1_IncrementLEDs\ram_reset_init.txt .

vsim -do ../modelsim_script.tcl
