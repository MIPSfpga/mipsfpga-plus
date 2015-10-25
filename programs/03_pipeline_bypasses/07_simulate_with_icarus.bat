rd /s /q sim
md sim
cd sim

copy ..\*.hex .

\iverilog\bin\iverilog -g2005 -D MFP_USE_WORD_MEMORY -I ../../.. -I ../../../../../MIPSfpga/rtl_up ../../../../../MIPSfpga/rtl_up/mvp*.v ../../../../../MIPSfpga/rtl_up/RAM*.v  ../../../../../MIPSfpga/rtl_up/*xilinx.v ../../../../../MIPSfpga/rtl_up/m14k*.v ../../../*.v
\iverilog\bin\vvp a.out > a.lst
\iverilog\gtkwave\bin\gtkwave.exe dump.vcd
