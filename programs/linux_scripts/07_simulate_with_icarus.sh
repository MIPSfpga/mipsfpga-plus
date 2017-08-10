## Simulate with Icarus Verilog
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/07_simulate_with_icarus.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 07_simulate_with_icarus.sh


rm -r sim
mkdir sim
cd sim
cp ../*.hex .

iverilog -g2005 -D SIMULATION -I ../../../core -I ../../../system_rtl -I ../../../system_rtl/uart16550 -I ../../../testbench -I ../../../testbench/sdr_sdram -s mfp_testbench ../../../core/*.v ../../../system_rtl/*.v ../../../system_rtl/uart16550/*.v ../../../testbench/*.v ../../../testbench/sdr_sdram/*.v

vvp a.out > a.lst

gtkwave dump.vcd
cd .. && rm -r sim 
