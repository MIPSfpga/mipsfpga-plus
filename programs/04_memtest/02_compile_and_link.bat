rem -EL             - Little-endian
rem -march=m14kc    - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
rem -msoft-float    - should not use floating-point processor instructions
rem -o program.elf  - output file name
rem -O2             - optimization level
rem -T, -Wl         - linked options
rem -std=c99        - C99 support

mips-mti-elf-gcc -std=c99 -EL -march=m14kc -msoft-float -O2 -Wl,-Map=program.map -T program.ld -Wl,--defsym,__flash_start=0xbfc00000 -Wl,--defsym,__flash_app_start=0x80000000 -Wl,--defsym,__app_start=0x80000000 -Wl,--defsym,__stack=0x80400000 -Wl,--defsym,__memory_size=0x3df800 -Wl,-e,0xbfc00000 -I%MIPS_ELF_ROOT%\share\mips\hal  boot.S main.c -o program.elf


rem %MIPS_ELF_ROOT%\share\mips\hal\cache_ops.S %MIPS_ELF_ROOT%\share\mips\hal\m32cache_ops.S %MIPS_ELF_ROOT%\share\mips\hal\cache.S