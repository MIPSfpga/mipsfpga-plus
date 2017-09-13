
# make all          - builds all for all programs subdirs
# make clean        - cleans all for all programs subdirs
# make init_linux   - replaces all programs/*/*.bat and /boards/*/.bat
#                     make wrapper scripts with *.sh analogs
# make init_windows - replaces all programs/*/*.sh and /boards/*/.sh
#                     make wrapper scripts with *.bat analogs
# make init_clean   - clears all programs/*/*.sh and programs/*/*.bat
#                     make wrapper scripts
# make init_vscode  - replaces current VSCode config (.vscode folder)
#                     with copy of scripts/vscode

TOPTARGETS := all clean init_linux init_windows init_clean
PROGRAMS   := $(wildcard */.)
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
