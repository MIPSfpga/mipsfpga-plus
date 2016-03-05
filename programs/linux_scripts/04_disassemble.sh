## Disassemble program
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/04_disassemble.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 04_disassemble.sh

mips-mti-elf-objdump -D program.elf > program.dis
