# MIPSfpga-plus makefile
CC = mips-mti-elf-gcc
LD = mips-mti-elf-gcc
OD = mips-mti-elf-objdump
OC = mips-mti-elf-objcopy
SZ = mips-mti-elf-size
GDB = mips-mti-elf-gdb

#OS dependent
# HEX splitter
HS = ../../scripts/utilities/ad_hoc_program_hex_splitter
# OpenOCD debugger
OCD = openocd
OCD_MPSSE = ../../scripts/load/mfp_mpsse.cfg
OCD_BUSB3 = ../../scripts/load/mfp_busbluster.cfg

ifeq ($(OS), Windows_NT)
	HS  = ../../scripts/utilities/ad_hoc_program_hex_splitter.exe
	OCD = openocd-0.9.2.exe
endif

# -EL           - Little-endian
# -march=m14kc  - MIPSfpga = MIPS microAptiv UP based on MIPS M14Kc
# -msoft-float  - should not use floating-point processor instructions
# -O2           - optimization level
# -std=c99		- C99 lang standard options enabled
CFLAGS  = -EL -march=m14kc -msoft-float -O2 -std=c99 
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
LDFLAGS += -Wl,--defsym,__stack=0x80040000
# Cautiously set the size of memory as the 2015.01 toolchain uses
# this size as the amount of free memory between the end of the
# program data and the lowest address that the stack will reach.
#
# Max 2K for stack (0x800)
# Max 128K for program code/data (0x20000)
# Leaving 126K heap (0x1f800)
LDFLAGS += -Wl,--defsym,__memory_size=0x1f800
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

#########################################################
# On Board Debug

# starting console debug session
debug:
	$(info )
	$(info Please check that OpenOCD is running and successfully connected to the CPU)
	$(info )

	$(GDB) --command=./commands.gdb

# runing OpenOCD with MPSSE debugger
ocd_mpsse:
	$(OCD) -f $(OCD_MPSSE)

# runing OpenOCD with BusBlaster3
ocd_busblaster:
	$(OCD) -f $(OCD_BUSB3)

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
