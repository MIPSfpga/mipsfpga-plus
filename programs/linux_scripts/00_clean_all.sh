## Clean dir from compile files
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/00_clean_all.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 00_clean_all.sh

rmdir sim

rm *.o
rm main.s
rm program.elf
rm program.map
rm program.dis
rm program*.hex
rm program.rec
rm FPGA_Ram.elf

