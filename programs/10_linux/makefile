# MIPSfpga-plus makefile
# Stanislav Zhelnio, 2017
#

#########################################################
# Path and program settings

GDB = mips-mti-elf-gdb

# OpenOCD debugger
OCD = openocd
OCD_CONF = ../../scripts/load/openocd.cfg

#########################################################
# Compile settings and tasks

clean:
	rm -f *.log

#########################################################
# On Board Debug

GDB_FILE_IMAGE = --se=image/vmlinuz
GDB_FILE_NEW   = --se=kernel/vmlinux

GDBCMD  = --silent
GDBCMD += -ex "set pagination off"
GDBCMD += -ex "target remote | $(OCD) -f $(OCD_CONF) -p -c 'log_output openocd.log'"
GDBCMD += -ex "monitor reset halt"
GDBCMD += -ex "load"
GDBCMD += -ex "continue"

debug_image:
	$(GDB) $(GDB_FILE_IMAGE) $(GDBCMD)

debug_new:
	$(GDB) $(GDB_FILE_NEW) $(GDBCMD)
