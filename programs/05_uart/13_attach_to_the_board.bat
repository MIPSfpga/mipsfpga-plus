mips-mti-elf-gdb --silent -ex "set pagination off" -ex "file program.elf" -ex "target remote | openocd-0.9.2.exe -f ../../scripts/load/mfp_mpsse.cfg -p -c 'log_output openocd.log'" -ex "interrupt"
