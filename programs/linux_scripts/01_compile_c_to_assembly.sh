## Compile C to ASM
## Usage: in sub-programs directory (eg. 00_counter) type "sh ../linux_scripts/01_compile_c_to_assembly.sh"
## @author Andrea Guerrieri - andrea.guerrieri@studenti.polito.it ing.guerrieri.a@gmail.com
## @file 01_compile_c_to_assembly.sh

#rem -EL           - Little-endian
#rem -march=m14kc  - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
#rem -msoft-float  - should not use floating-point processor instructions
#rem -O2           - optimization level
#rem -S            - compile to assembly

mips-mti-elf-gcc -EL -march=m14kc -msoft-float -O2 -S main.c
