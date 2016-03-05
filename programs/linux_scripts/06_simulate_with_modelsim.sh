## Simulate with modelsim
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/06_simulate_with_modelsim.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 06_simulate_with_modelsim.sh


rm -r sim
mkdir sim
cd sim

cp ../*.hex .
vsim -do ../modelsim_script.tcl

cd .. && rm -r sim
