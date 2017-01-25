rem -EL             - Little-endian
rem -march=m14kc    - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
rem -msoft-float    - should not use floating-point processor instructions
rem -o program.elf  - output file name
rem -O2             - optimization level
rem -T, -Wl         - linked options

mips-mti-elf-gcc -EL -march=m14kc -msoft-float -O2 -Wl,-Map=program.map -T program.ld -Wl,--defsym,__flash_start=0xbfc00000 -Wl,--defsym,__flash_app_start=0x80000000 -Wl,--defsym,__app_start=0x80000000 -Wl,--defsym,__stack=0x80040000 -Wl,--defsym,__memory_size=0x1f800 -Wl,-e,0xbfc00000 boot.S main.c -o program.elf
