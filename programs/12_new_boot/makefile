# microAptiv_UP makefile for MIPSfpga

ifndef MIPS_ELF_ROOT
$(error MIPS_ELF_ROOT must be set to point to toolkit installation root)
endif

CC = mips-mti-elf-gcc
LD = mips-mti-elf-gcc
OD = mips-mti-elf-objdump
OC = mips-mti-elf-objcopy
SZ = mips-mti-elf-size

# Imagination CodeScape toolchain
ifneq (,$(wildcard $(MIPS_ELF_ROOT)/bin/mips-mti-elf-gcc))
    CC = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-gcc
    LD = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-gcc
    OD = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-objdump
    OC = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-objcopy
    SZ = $(MIPS_ELF_ROOT)/bin/mips-mti-elf-size
endif

# Mentor CodeSourcery toolchain
ifneq (,$(wildcard $(MIPS_ELF_ROOT)/bin/mips-sde-elf-gcc))
    CC = $(MIPS_ELF_ROOT)/bin/mips-sde-elf-gcc
    LD = $(MIPS_ELF_ROOT)/bin/mips-sde-elf-gcc
    OD = $(MIPS_ELF_ROOT)/bin/mips-sde-elf-objdump
    OC = $(MIPS_ELF_ROOT)/bin/mips-sde-elf-objcopy
    SZ = $(MIPS_ELF_ROOT)/bin/mips-sde-elf-size
endif

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
LIBFDCPATH="/opt/imgtec/Toolchains/mips-mti-elf/2016.05-03/share/mips/addons/libfdc/"
else
LIBFDCPATH="$(MIPS_ELF_ROOT)/share/mips/addons/libfdc/"
endif


CFLAGS  = -EL -g -march=m14kc -msoft-float -O1 -I$(LIBFDCPATH)
LDFLAGS = -EL -march=m14kc -msoft-float -nostartfiles -Wl,-Map=program.map -I$(LIBFDCPATH)

ifeq ($(TINY_MEMORY),1)
# Set the stack to the top of the Code/Data RAM
LDFLAGS += -Wl,--defsym,__stack=0x80000400
# Define a small amount of heap for symbol purposes
LDFLAGS += -Wl,--defsym,__memory_size=0x10
else
# Set the stack to the top of the Code/Data RAM
LDFLAGS += -Wl,--defsym,__stack=0x80040000
# Cautiously set the size of memory as the 2015.03 toolchain uses
# this size as the amount of free memory between the end of the
# program data and the lowest address that the stack will reach.
#
# Max 2K for stack (0x800)
# Max 128K for program code/data (0x20000)
# Leaving 126K heap (0x1f800)
LDFLAGS += -Wl,--defsym,__memory_size=0x1f800
endif

# common LDFLAGS
# Set up the link addresses for a bootable C program on MIPSfpga
LDFLAGS += -T uhi32.ld
# Place the boot code (physical address). The virtual address for
# boot code entry point is hard-wired to 0x9fc00000.
LDFLAGS += -Wl,--defsym,__flash_start=0xbfc00000
# Place the application code (physical address)
LDFLAGS += -Wl,--defsym,__flash_app_start=0x80000000
# Place the application code (virtual address)
LDFLAGS += -Wl,--defsym,__app_start=0x80000000
# Disable reserving space for ISR vectors
LDFLAGS += -Wl,--defsym,__isr_vec_count=0
# Set the entry point to the true hard-reset address
LDFLAGS += -Wl,-e,0xbfc00000

ASOURCES= \
boot.S \
crt0.S \
exceptions.S \
dummy.S

# Build crt0.o so that it ends up in the .boot section
crt0.o : CFLAGS += -D_BOOTCODE

CSOURCES= \
main.c

COBJECTS = $(CSOURCES:.c=.o)
CASMS    = $(CSOURCES:.c=.s)
AOBJECTS = $(ASOURCES:.S=.o)

all: program.elf $(CASMS)

program.elf : $(AOBJECTS) $(COBJECTS) 
	$(LD)  $(LDFLAGS) $(filter-out crt0.o,$(AOBJECTS)) $(COBJECTS) -o program.elf
	$(OC) --remove-section .MIPS.abiflags --remove-section .reginfo program.elf
	$(SZ) program.elf
	$(OD) -D -l -t program.elf > program.dis
	$(OC) program.elf -O verilog program.hex
	$(OC) program.elf -O srec program.rec

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.S.o:
	$(CC) -c $(CFLAGS) $< -o $@

.c.s:
	$(CC) -S $(CFLAGS) $< -o $@

clean:
	rm -f main.s
	rm -f *.o
	rm -f program.elf
	rm -f program.map
	rm -f program.dis
	rm -f program.hex
	rm -f program.rec
