## Program Description
```
  00_counter           simple counter with the output to 7-segment and LED indicators
  01_light_sensor      example of working with Digilent Pmod ALS sensor (SPI protocol)
  02_cache_misses      CPU Cache Misses Lab
  03_pipeline_bypasses CPU Pipeline Bypasses Lab
  04_memtest           Memory test for SDRAM module
  05_uart              UART16550 module usage example
  06_timer_irq         CPU timer and interrupt usage example
  07_eic               MIPSfpga-plus External Interrupt Controller (IEC) usage example
  08_uart_irq          UART16550 interrupt mode usage example
  09_adc               Altera MAX10 ADC module usage example
```

## Program Make Wrapper Scripts
```
  00_clean_all                       - delete all created files, alternative for 'make clean'
  01_compile_c_to_assembly           - compile all C sources to ASM, alternative for 'make compile'
  02_compile_and_link                - build program.elf from sources, alternative for 'make program'
  03_check_program_size              - show program size information, alternative for 'make size'
  04_disassemble                     - disassemble program.elf, alternative for 'make disasm'
  05_generate_verilog_readmemh_file  - create verilog memory init file for simulation
                                       alternative for 'make readmemh'
  06_simulate_with_modelsim          - imulate program and device using Modelsim
                                       alternative for 'make modelsim'
  07_simulate_with_icarus            - simulate program and device using Icarus Verilog 
                                       and show results with GTKWave 
                                       alternative for 'make icarus' and 'make gtkwave'
  08_generate_motorola_s_record_file - create Motorola S-record file to use it 
                                       with UART loader, alternative for 'make srecord'
  09_check_which_com_port_is_used    - show the list of COM ports available in Windows system
                                       (no make alternative, windows only)
  10_upload_to_the_board_using_uart  - upload the program to MIPSfpga-plus system using UART loader, 
                                       (no make alternative)
  11_upload_to_the_board             - load program into the MIPSfpga-plus memory, run it and detach gdb,
                                       alternative for 'make load'
  12_debug_on_the_board              - load program into the MIPSfpga-plus memory, wait for gdb commands,
                                       alternative for 'make debug' on linux, separate script on windows
  13_attach_to_the_board             - attach to the MIPSfpga-plus device, wait for gdb commands
                                       alternative for 'make attach' on linux, separate script for windows
```

## Top Make parameters
Those make commands can be run program directory
```
  make help            - show this message
  make all             - builds all in programs subdirs
  make init_linux      - replaces all programs/*/*.bat and /boards/*/.bat wrapper scripts with *.sh analogs
  make init_windows    - replaces all programs/*/*.sh and /boards/*/.sh wrapper scripts with *.bat analogs
  make init_clean      - clears all programs/*/*.sh and programs/*/*.bat wrapper scripts
  make init_vscode     - creates VSCode config folder (.vscode) as a copy of scripts/vscode
  make init_busblaster - change scripts/load/openocd.cfg to use BusBlaster 3 for hardware debug
  make init_mpsse      - change scripts/load/openocd.cfg to use FTDI MPSSE based board for hardware debug
```

## Program Make parameters
Those make commands can be run in program/* directories
```
  make help       - show this message
  make all        - alternative for: compile program size disasm readmemh srecord
  make program    - build program.elf from sources
  make compile    - compile all C sources to ASM
  make size       - show program size information
  make disasm     - disassemble program.elf
  make readmemh   - create verilog memory init file for simulation
  make srecord    - create Motorola S-record file to use it with UART loader
  make clean      - delete all created files
  make load       - load program into the device memory, run it and detach gdb
  make debug      - load program into the device memory, wait for gdb commands
  make attach     - attach to the device, wait for gdb commands
  make modelsim   - simulate program and device using Modelsim
  make icarus     - simulate program and device using Icarus Verilog
  make gtkwave    - show the result of Icarus Verilog simulation with GTKWave
```

## Scripts Prerequisites
  - MIPS SDK is installed and properly configured (for program build)
  - Modelsim is installed, the directory with 'vsim' is added to $PATH (for simulation)
  - Icarus Verilog installed, the directories with 'icarus' and 'gtkwave' are added to $PATH (for simulation)
  - OpenOCD installed, the directory with 'openocd' is added to $PATH (for onboard debug)
  - Bus blaster or MPSSE debugger is connected and configured (for onboard debug)
  - USB-UART converted (for UART program load only)
