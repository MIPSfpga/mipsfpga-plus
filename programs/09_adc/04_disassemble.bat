rem for -O1 and -Og - add source code
mips-mti-elf-objdump -SD program.elf > program.dis

rem for -O2 - just disas
rem mips-mti-elf-objdump -D program.elf > program.dis
