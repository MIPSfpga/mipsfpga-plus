rd /s /q sim
md sim
cd sim

copy ..\*.hex .

\iverilog\bin\iverilog -g2005 -D MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION  -D MFP_RAM_RESET_INIT_FILENAME=\"program_bfc00000.hex\" -D MFP_RAM_INIT_FILENAME=\"program_80000000.hex\" -I ../../.. -I ../../../../../MIPSfpga/rtl_up ../../../../../MIPSfpga/rtl_up/mvp*.v ../../../../../MIPSfpga/rtl_up/RAM*.v  ../../../../../MIPSfpga/rtl_up/*xilinx.v ../../../../../MIPSfpga/rtl_up/m14k*.v ../../../*.v
\iverilog\bin\vvp a.out
\iverilog\gtkwave\bin\gtkwave.exe dump.vcd
