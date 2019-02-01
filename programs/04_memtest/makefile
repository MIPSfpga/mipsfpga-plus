# MIPSfpga-plus makefile
# Stanislav Zhelnio, 2017
#
# based on:
#      microAptiv_UP makefile for MIPSfpga
#      Andrea Guerrieri scripts

help:
	$(info make help       - show this message)
	$(info make all        - alternative for: compile program size disasm readmemh srecord)
	$(info make program    - build program.elf from sources)
	$(info make compile    - compile all C sources to ASM)
	$(info make size       - show program size information)
	$(info make disasm     - disassemble program.elf )
	$(info make readmemh   - create verilog memory init file for simulation)
	$(info make srecord    - create Motorola S-record file to use it with UART loader)
	$(info make clean      - delete all created files)
	$(info make load       - load program into the device memory, run it and detach gdb)
	$(info make debug      - load program into the device memory, wait for gdb commands)
	$(info make attach     - attach to the device, wait for gdb commands)
	$(info make modelsim   - simulate program and device using Modelsim)
	$(info make icarus     - simulate program and device using Icarus Verilog)
	$(info make gtkwave    - show the result of Icarus Verilog simulation in GTKWave)
	@true

#########################################################
# Path and program settings

CC = mips-mti-elf-gcc
LD = mips-mti-elf-gcc
OD = mips-mti-elf-objdump
OC = mips-mti-elf-objcopy
SZ = mips-mti-elf-size
GDB = mips-mti-elf-gdb

#OS dependent
# HEX splitter
HS = ../../scripts/utilities/ad_hoc_program_hex_splitter
ifeq ($(OS), Windows_NT)
	HS  = ../../scripts/utilities/ad_hoc_program_hex_splitter.exe
endif

# OpenOCD debugger
OCD = openocd
OCD_CONF = ../../scripts/load/openocd.cfg

# UART interface for memory programming
UART_MEM_LOADER_DEV=/dev/ttyUSB0

#########################################################
# Compile settings and tasks

# -EL           - Little-endian
# -march=m14kc  - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
# -msoft-float  - should not use floating-point processor instructions
# -O1           - optimization level
# -std=c99		- C99 lang standard options enabled
CFLAGS  = -EL -march=m14kc -msoft-float -O1 -std=c99 
LDFLAGS = -EL -march=m14kc -msoft-float -Wl,-Map=program.map

# -g -gdwarf-2  - debug symbols to use with gdb
DBFLAGS = -g -gdwarf-2 

# Set up the link addresses for a bootable C program on MIPSfpga
LDFLAGS += -T program.ld
# Place the boot code (physical address). The virtual address for
# boot code entry point is hard-wired to 0x9fc00000.
LDFLAGS += -Wl,--defsym,__flash_start=0xbfc00000
# Place the application code (physical address)
LDFLAGS += -Wl,--defsym,__flash_app_start=0x80000000
# Place the application code (virtual address)
LDFLAGS += -Wl,--defsym,__app_start=0x80000000

# Set the stack to the top of the Code/Data RAM
# stack depends on available mem size:
#     256K -> 0x80040000 (simulation)
#       8M -> 0x80800000 
#      64M -> 0x84000000 (de10-lite)
STACK   = 0x84000000
LDFLAGS += -Wl,--defsym,__stack=$(STACK)

# Cautiously set the size of memory as the 2015.01 toolchain uses
# this size as the amount of free memory between the end of the
# program data and the lowest address that the stack will reach.
#
# Max 2K for stack (0x800)
# Max 128K for program code/data (0x20000)
# Leaving 126K heap (0x1f800)
#LDFLAGS += -Wl,--defsym,__memory_size=0x1f800

# Set the entry point to the true hard-reset address
LDFLAGS += -Wl,-e,0xbfc00000

ASOURCES= \
boot.S

CSOURCES= \
main.c

COBJECTS = $(CSOURCES:.c=.o)
CASMS    = $(CSOURCES:.c=.s)
AOBJECTS = $(ASOURCES:.S=.o)

.PHONY: clean sim

all: compile program size disasm readmemh srecord

program : $(AOBJECTS) $(COBJECTS) 
	$(LD)  $(LDFLAGS) $(AOBJECTS) $(COBJECTS) $(DBFLAGS) -o program.elf

.c.o:
	$(CC) -c $(CFLAGS) $(DBFLAGS) $< -o $@

.S.o:
	$(CC) -c $(CFLAGS) $(DBFLAGS) $< -o $@

.c.s:
	$(CC) -S $(CFLAGS) $< -o $@

compile: $(CASMS)

size:
	$(SZ) program.elf

disasm:
	$(OD) -D -l program.elf > program.dis

readmemh:
	$(OC) program.elf -O verilog program.hex
	$(HS)

srecord:
	$(OC) program.elf -O srec program.rec

clean:
	rm -rf sim
	rm -f main.s
	rm -f *.o
	rm -f program.elf
	rm -f program.map
	rm -f program.dis
	rm -f program*.hex
	rm -f program.rec
	rm -f *.log

#########################################################
# On Board Debug

GDBCMD_ATTACH  = --silent
GDBCMD_ATTACH += -ex "set pagination off"
GDBCMD_ATTACH += -ex "file program.elf"
GDBCMD_ATTACH += -ex "target remote | $(OCD) -f $(OCD_CONF) -p -c 'log_output openocd.log'"

GDBCMD_LOAD   += -ex "monitor reset halt"
GDBCMD_LOAD   += -ex "load"
GDBCMD_LOAD   += -ex "compare-sections"

GDBCMD_BREAK  += -ex "b main"
GDBCMD_BREAK  += -ex "continue"

GDBCMD_INT    += -ex "interrupt"

GDBCMD_RESRUN += -ex "monitor reset run"

attach:
	$(GDB) $(GDBCMD_ATTACH) $(GDBCMD_INT)

load:
	$(GDB) --batch $(GDBCMD_ATTACH) $(GDBCMD_LOAD) $(GDBCMD_RESRUN)

debug:
	$(GDB) $(GDBCMD_ATTACH) $(GDBCMD_LOAD) $(GDBCMD_BREAK)

#########################################################
# UART programming

uart:
	stty -F $(UART_MEM_LOADER_DEV) raw speed 115200 -crtscts cs8 -parenb -cstopb
	cat program.rec > $(UART_MEM_LOADER_DEV)

#########################################################
# Modelsim simulation

modelsim:
	rm -rf sim
	mkdir sim
	cp *.hex sim
	cd sim && vsim -do ../modelsim_script.tcl

#########################################################
# Icarus verilog simulation

TOPMODULE=mfp_testbench
IVARG = -g2005 
IVARG += -D SIMULATION
IVARG += -I ../../../core
IVARG += -I ../../../system_rtl
IVARG += -I ../../../system_rtl/uart16550
IVARG += -I ../../../testbench
IVARG += -I ../../../testbench/sdr_sdram
IVARG += -s $(TOPMODULE)
IVARG += ../../../core/*.v
IVARG += ../../../system_rtl/*.v
IVARG += ../../../system_rtl/uart16550/*.v
IVARG += ../../../testbench/*.v
IVARG += ../../../testbench/sdr_sdram/*.v

icarus:
	rm -rf sim
	mkdir sim
	cp *.hex sim
	cd sim && iverilog $(IVARG)
	cd sim && vvp -la.lst a.out -n
	
gtkwave:
	cd sim && gtkwave dump.vcd

#########################################################
# How to make a bat replacement
#  make --no-print-directory -n debug > debug.bat
#  make --no-print-directory -n debug > attach.bat
