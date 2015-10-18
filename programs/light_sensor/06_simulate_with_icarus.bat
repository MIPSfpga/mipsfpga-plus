rd /s /q sim
md sim
cd sim

copy C:\MIPSfpga\rtl_up\initfiles\1_IncrementLEDs\ram_reset_init.txt .

\iverilog\bin\iverilog -g2005 -D MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION -I ../../.. -I ../../../../../MIPSfpga/rtl_up ../../../../../MIPSfpga/rtl_up/mvp*.v ../../../../../MIPSfpga/rtl_up/RAM*.v  ../../../../../MIPSfpga/rtl_up/*xilinx.v ../../../../../MIPSfpga/rtl_up/m14k*.v ../../../*.v
\iverilog\bin\vvp a.out
\iverilog\gtkwave\bin\gtkwave.exe dump.vcd
