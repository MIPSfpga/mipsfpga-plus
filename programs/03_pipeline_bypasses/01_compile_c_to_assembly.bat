rem -EL           - Little-endian
rem -march=m14kc  - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
rem -msoft-float  - should not use floating-point processor instructions
rem -O2           - optimization level
rem -S            - compile to assembly

mips-mti-elf-gcc -EL -march=m14kc -msoft-float -O1 -S main.c
