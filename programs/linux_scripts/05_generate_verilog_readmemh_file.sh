## Generate Verilog Readmemh file
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/05_generate_verilog_readmemh_file.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 05_generate_verilog_readmemh_file.sh


mips-mti-elf-objcopy program.elf -O verilog program.hex
#..\utilities\ad_hoc_program_hex_splitter
../utilities/ad_hoc_program_hex_splitter
