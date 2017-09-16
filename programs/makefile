# MIPSfpga-plus makefile
# Stanislav Zhelnio, 2017
#
# based on:
#      microAptiv_UP makefile for MIPSfpga
#      Andrea Guerrieri scripts

help:
	$(info make help         - show this message)
	$(info make all          - build all in programs subdirs)
	$(info make init_linux   - replace all programs/*/*.bat and /boards/*/.bat)
	$(info `                   wrapper scripts with *.sh analogs)
	$(info make init_windows - replace all programs/*/*.sh and /boards/*/.sh)
	$(info `                   wrapper scripts with *.bat analogs)
	$(info make init_clean   - clear all programs/*/*.sh and programs/*/*.bat)
	$(info `                   wrapper scripts)
	$(info make init_vscode  - create VSCode config folder (.vscode))
	$(info `                   as a copy of scripts/vscode)
	@true

TOPTARGETS := all clean init_linux init_windows init_clean

PROGRAMS   := $(wildcard */.)
PROGRAMS   := $(filter-out 10_linux/., $(PROGRAMS))

BOARDS	   := $(wildcard ../boards/*/.)


.PHONY: $(TOPTARGETS) $(PROGRAMS) $(BOARDS) init_vscode

$(TOPTARGETS): $(PROGRAMS) $(BOARDS)

$(PROGRAMS):
ifeq ($(MAKECMDGOALS), all)
	$(MAKE) -C $@ $(MAKECMDGOALS)
endif

ifeq ($(MAKECMDGOALS), clean)
	$(MAKE) -C $@ $(MAKECMDGOALS)
endif

ifeq ($(MAKECMDGOALS), init_linux)
	rm -f $@/*.bat
	cp ../scripts/make_wrappers/program/*.sh $@
endif

ifeq ($(MAKECMDGOALS), init_windows)
	rm -f $@/*.sh
	cp ../scripts/make_wrappers/program/*.bat $@
endif

ifeq ($(MAKECMDGOALS), init_clean)
	rm -f $@/*.sh
	rm -f $@/*.bat
endif

$(BOARDS):
ifeq ($(MAKECMDGOALS), init_linux)
	rm -f $@/*.bat
	cp ../scripts/make_wrappers/board/*.sh $@
endif

ifeq ($(MAKECMDGOALS), init_windows)
	rm -f $@/*.sh
	cp ../scripts/make_wrappers/board/*.bat $@
endif

init_vscode:
	rm -rf ../.vscode
	cp -fr ../scripts/vscode ../.vscode
