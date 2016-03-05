## Generate Motorola S record file
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/08_generate_motorola_s_record_file.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 08_generate_motorola_s_record_file.sh


mips-mti-elf-objcopy program.elf -O srec program.rec
