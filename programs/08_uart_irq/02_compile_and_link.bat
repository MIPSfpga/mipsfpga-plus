rem -EL             - Little-endian
rem -march=m14kc    - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
rem -msoft-float    - should not use floating-point processor instructions
rem -o program.elf  - output file name
rem -O2             - optimization level
rem -T, -Wl         - linked options
rem -g -gdwarf-2    - debug symbols to use with gdb
rem -std=c99        - C99 lang standard features enabled

rem stack depends on available mem size:
rem     256K -> 0x80040000 (simulation)
rem       8M -> 0x80800000 
rem      64M -> 0x84000000 (de10-lite)
set stack=0x80040000

mips-mti-elf-gcc -g -gdwarf-2 -std=c99 -EL -march=m14kc -msoft-float -O1 -Wl,-Map=program.map -T program.ld -Wl,--defsym,__flash_start=0xbfc00000 -Wl,--defsym,__flash_app_start=0x80000000 -Wl,--defsym,__app_start=0x80000000 -Wl,--defsym,__stack=%stack% -Wl,-e,0xbfc00000 boot.S exceptions.S main.c -o program.elf

