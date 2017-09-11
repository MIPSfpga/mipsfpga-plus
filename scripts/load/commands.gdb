
file program.elf
target remote localhost:3333
set endian little
monitor reset halt
load
compare-sections
b main

