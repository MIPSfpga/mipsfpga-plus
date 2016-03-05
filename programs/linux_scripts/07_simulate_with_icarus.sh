## Simulate with Icarus Verilog
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/07_simulate_with_icarus.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 07_simulate_with_icarus.sh


rm -r sim
mkdir sim
cd sim
cp ../*.hex .

iverilog -g2005 -I ../../../ -I ../../../../MIPSfpga/rtl_up ../../../../MIPSfpga/rtl_up/mvp*.v ../../../../MIPSfpga/rtl_up/RAM*.v  ../../../../MIPSfpga/rtl_up/*xilinx.v ../../../../MIPSfpga/rtl_up/m14k*.v ../../../*.v

vvp a.out > a.lst

gtkwave dump.vcd
cd .. && rm -r sim 
