# microAptiv_UP makefile for MIPSfpga

ifndef MIPS_ELF_ROOT
$(error MIPS_ELF_ROOT must be set to point to toolkit installation root)
endif

# Imagination CodeScape MIPS SDK
#GCC_PREFIX = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-
GCC_PREFIX = mips-mti-elf-

# Mentor Sourcery CodeBench Lite Edition for MIPS ELF
#GCC_PREFIX = /usr/local/mips-2014.05/bin/mips-sde-elf-

CC=$(GCC_PREFIX)gcc
LD=$(GCC_PREFIX)gcc
OD=$(GCC_PREFIX)objdump
OC=$(GCC_PREFIX)objcopy
SZ=$(GCC_PREFIX)size

#CFLAGS = -O0 -g -EL -c -msoft-float -march=m14kc
CFLAGS = -O2 -g -EL -c -msoft-float -march=m14kc
LDFLAGS = -EL -msoft-float -march=m14kc -Wl,-Map=FPGA_Ram_map.txt

# Set up the link addresses for a bootable C program on MIPSfpga
LDFLAGS += -T boot-uhi32.ld
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

all: FPGA_RAM

COBJECTS=$(CSOURCES:.c=.o)
AOBJECTS=$(ASOURCES:.S=.o)

FPGA_RAM : $(AOBJECTS) $(COBJECTS)
	$(LD)  $(LDFLAGS) $(AOBJECTS) $(COBJECTS) -o FPGA_Ram.elf
	$(SZ) FPGA_Ram.elf
	$(OD) -D -S -l FPGA_Ram.elf > FPGA_Ram_dasm.txt
	$(OD) -D -z FPGA_Ram.elf > FPGA_Ram_modelsim.txt
	$(OC) FPGA_Ram.elf -O srec FPGA_Ram.rec

.c.o:
	$(CC) $(CFLAGS) $< -o $@

.S.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f FPGA_Ram_dasm.txt
	rm -f FPGA_Ram_modelsim.txt
	rm -f FPGA_Ram_map.txt
	rm -f FPGA_Ram.rec
	rm -f FPGA_Ram.elf
	rm -f *.o
	rm -rf MemoryFiles
