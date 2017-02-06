rem -EL           - Little-endian
rem -march=m14kc  - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
rem -msoft-float  - should not use floating-point processor instructions
rem -O2           - optimization level
rem -S            - compile to assembly
rem -std=c99        - C99 lang standard features enabled

mips-mti-elf-gcc -std=c99 -EL -march=m14kc -msoft-float -O2 -S main.c
