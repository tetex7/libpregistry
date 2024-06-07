#
#Copyright (C) 2024  tete
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
NAME = libpregistry
SO = ${NAME}.so
DEBUG = 1
SYS_LIBS = 
LIBS =
#-lluacpp
LIB_INC = 
#BOND = 115200
#MCU = atmega168a

#include libabsl.mk

SCRTPTS = scripts

PROGER = arduino

SEX = 0
SEX_LIST=test,sym1,sym2,sym3

ifeq ($(DEBUG),1)
OP_FLAG = -g -O0
DFLAG += -DDEBUG 1
else
OP_FLAG = -O2
endif

SRC_DIRS :=



# Whether to hide commands or not
VERBOSE = 0
ifeq ($(VERBOSE),0)
  V := @
endif

# Whether to colorize build messages
COLOR = 1

#==============================================================================#
# Target Executable and Sources                                                #
#==============================================================================#
# BUILD_DIR is the location where all build artifacts are placed
BUILD_DIR := bin
# Directories containing source files
SRC_DIR = src
SRC_DIRS += $(SRC_DIR) $(wildcard $(SRC_DIR)/**)
#src/Log4x \
#src/DSS \

C_FILES           := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
CXX_FILES         := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
IXX_FILES         := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.ixx))
CC_FILES          := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cc))
ASM_FILES           := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.asm))
#S_FILES           := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.s))
SS_FILES          := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.S))
F90_FILES         := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.f90))
RS_FILES         := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.rs))

# Object files
O_FILES := $(foreach file,$(F90_FILES),$(BUILD_DIR)/$(file:=.o)) \
		   $(foreach file,$(C_FILES),$(BUILD_DIR)/$(file:=.o))   \
		   $(foreach file,$(CXX_FILES),$(BUILD_DIR)/$(file:=.o)) \
		   $(foreach file,$(IXX_FILES),$(BUILD_DIR)/$(file:=.o)) \
		   $(foreach file,$(CC_FILES),$(BUILD_DIR)/$(file:=.o))  \
		   $(foreach file,$(ASM_FILES),$(BUILD_DIR)/$(file:=.o))  \
		   $(foreach file,$(SS_FILES),$(BUILD_DIR)/$(file:=.o))  \
		   $(foreach file,$(RS_FILES),$(BUILD_DIR)/$(file:=.o)) 
		   

# tools
PRINT = printf

ifeq ($(COLOR),1)
NO_COL  := \033[0m
RED     := \033[0;31m
GREEN   := \033[0;32m
BLUE    := \033[0;34m
YELLOW  := \033[0;33m
BLINK   := \033[33;5m
MAGENTA := \033[0;35m
endif

# Common build print status function
define print
  @$(PRINT) "$(GREEN)$(1) $(YELLOW)$(2)$(GREEN) -> $(BLUE)$(3)$(NO_COL)\n"
endef

#==============================================================================#
# Main Targets                                                                 #
#==============================================================================#
# Default target
default: so

all: default

info: boot

install: boot
	$(V)./install.sh

boot:
	$(V)$(BASH) $(SCRTPTS)/KROM.sh $(COLOR)

pak: boot
	@$(PRINT) "$(GREEN)paking :  $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/pak.sh $(NAME) $(COLOR)

pak_p: boot
	@$(PRINT) "$(GREEN)paking :  $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/pak_p.sh $(NAME) $(COLOR)

flas: boot
	@$(PRINT) "$(GREEN)flasing$(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/avr_install.sh $(PROGER) $(BOND) $(MCU) $(NAME) $(COLOR)

zip: boot
	@$(PRINT) "$(GREEN)ziping :  $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/ziper.sh $(NAME) 0 $(COLOR) $(DEBUG)

zip-c: boot
	@$(PRINT) "$(GREEN)ziping : -c $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/ziper.sh $(NAME) 1 $(COLOR) $(DEBUG)

lib: boot $(LIB)

hex: boot $(HEX)

elf: boot $(ELF)

so: boot $(SO)

exe: boot ${EXE}

win: exe

size:
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $1 $(COLOR)

dll: boot $(DLL)

disasm: boot
	@$(PRINT) "$(GREEN)disasming :  $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/disasm.sh $(TOOL_PREFIX) $(DLL)

sym: boot
	@$(PRINT) "$(GREEN)dumping sym :  $(BLUE)$(NAME) $(NO_COL)\n"
	$(V)$(BASH) $(SCRTPTS)/dumpsym.sh $(TOOL_PREFIX) $(DLL)

clean: boot
	@$(PRINT) "$(RED)cleaning lib :  $(YELLOW)$(NAME) $(NO_COL)\n"
	$(V)$(RM) -r $(BUILD_DIR) $(NAME) $(NAME)*.zip

ALL_DIRS := $(BUILD_DIR) $(addprefix $(BUILD_DIR)/,$(SRC_DIRS))

# Make sure build directory exists before compiling anything
DUMMY != mkdir -p $(ALL_DIRS)

#==============================================================================#
# Compilation Recipes                                                          #
#==============================================================================#

ifeq ($(WIN32),1)
TOOL_PREFIX = x86_64-w64-mingw32-
else
TOOL_PREFIX = 
endif

CC = $(TOOL_PREFIX)gcc
CXX = $(TOOL_PREFIX)g++
ASM = $(TOOL_PREFIX)as
LD = $(TOOL_PREFIX)ld
AR = $(TOOL_PREFIX)ar
SIZE = $(TOOL_PREFIX)size
OBJCOPY = $(TOOL_PREFIX)objcopy
STRIP = $(TOOL_PREFIX)strip
ADDR2LINE = $(TOOL_PREFIX)addr2line
RANLIB = $(TOOL_PREFIX)ranlib
CPP_FILT = $(TOOL_PREFIX)c++filt
GF = $(TOOL_PREFIX)gfortran
BASH = /bin/bash
PY3 = /bin/python3
RUSTC = rustc
SIZEFLAGS=-d --common
NASM = nasm

ifneq (, $(shell command -v gnumfmt 2> /dev/null))
	SIZES_NUMFMT:=| gnumfmt --field=-4 --header $(NUMFMTFLAGS)
else
ifneq (, $(shell command -v numfmt 2> /dev/null))
	SIZES_NUMFMT:=| numfmt --field=-4 --header $(NUMFMTFLAGS)
else
	SIZES_NUMFMT:=
endif
endif

ifneq (, $(shell command -v sed 2> /dev/null))
SIZES_SED:=| sed -e 's/  dec/total/'
else
SIZES_SED:=
endif

NODEFAULTLIBS = 0

# Include directories
INCS := -I./include
PLAS := -J./include

# Optimization compiler flags
GCCFLAG = -fPIC -Wno-sizeof-pointer-div -fno-strict-aliasing -fpermissive
DFLAG =
BFLAG = 

OPTFLAGS ?= $(OP_FLAG)

# Warning compiler flags
WARNFLAGS ?= -Wall

# C compiler flags
CFLAGS := $(BFLAG) $(DFLAG) $(GCCFLAG) $(OPTFLAGS) $(WARNFLAGS) -std=gnu99

# C++ compiler flags
CXXFLAGS := $(BFLAG) $(BFLAG) $(DFLAG) $(GCCFLAG) $(OPTFLAGS)  $(WARNFLAGS) -std=gnu++2a

GFFLAG := $(OPTFLAGS) $(WARNFLAGS)

# Linker flags
LDFLAGS :=

# Assembler flags
ASFLAGS := $(WARNFLAGS)

# Default link file
#ifeq ($(LINKFILE),)
#EE_LINKFILE := $(PS2SDK)/ee/startup/linkfile
#endif

$(BUILD_DIR)/%.c.o: %.c
	$(call print,Compiling:,$<,$@)
	$(V)$(CC) -c $(CFLAGS) $(INCS)  $< -o $@
	$(V)if [ ${SEX} = 1 ]; then \
	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
	fi 
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $@ $(COLOR)

$(BUILD_DIR)/%.cc.o: %.cc
	$(call print,Compiling:,$<,$@)
	$(V)$(EE_CXX) -c $(CXXFLAGS) $(INCS)  $< -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	$(call print,Compiling:,$<,$@)
	$(V)$(CXX) -c $(CXXFLAGS) $(INCS)  $< -o $@
	$(V)if [ ${SEX} = 1 ]; then \
	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
	fi 
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $@ $(COLOR)

$(BUILD_DIR)/%.rs.o: %.rs
	$(call print,Compiling:,$<,$@)
	$(V)$(RUSTC) --emit obj $< -o $@
	$(V)if [ ${SEX} = 1 ]; then \
	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
	fi 


$(BUILD_DIR)/%.ixx.o: %.ixx
	$(call print,Compiling:,$<,$@)-T
	$(V)$(CXX) -c $(CXXFLAGS) $(INCS)  $< -o $@

$(BUILD_DIR)/%.f90.o: %.f90
	$(call print,Compiling:,$<,$@)
	$(V)$(GF) -c $(GFFLAG) $(PLAS) $(INCS)  $< -o $@
	$(V)if [ ${SEX} = 1 ]; then \
	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
	fi 
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $@ $(COLOR)

COMMA:=,
#$(BUILD_DIR)/%.S.o: %.S
#	$(call print,Assembling:,$<,$@)
#	$(V)$(CC) -c $(GFLAGS) $(ASFLAGS) $(patsubst %,-Wa$(COMMA)%,$(INCS))  $< -o $@
#	$(V)if [ ${SEX} = 1 ]; then \
#	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
#	fi 
#	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$@ $(COLOR)*

$(BUILD_DIR)/%.asm.o: %.asm
	$(call print,Assembling:,$<,$@)
	$(V)$(NASM) -O0 -g -F dwarf -f elf64  $< -o $@
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $@ $(COLOR)

$(BUILD_DIR)/%.S.o: %.S
	$(call print,Assembling:,$<,$@)
	$(V)$(NASM) -felf64 $(OP_FLAGS) $(ASFLAGS) -o $@ $<
	$(V)if [ ${SEX} = 1 ]; then \
	$(BASH) ./$(SCRTPTS)/bstrip.sh $@ $(SEX_LIST); \
	fi 
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $@ $(COLOR)

#$(BUILD_DIR)/%.s.o: %.s
#	$(call print,Assembling:,$<,$@)
#	$(V)$(AS) $(ASFLAGS) $< -o $@
EE_LINKFILE := $(PS2SDK)/ee/startup/linkfile
$(DLL): $(O_FILES)
	@$(PRINT) "$(GREEN)Linking DLL file:  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(CXX) -shared $(OPTFLAGS) -o $(BUILD_DIR)/$(DLL) $(O_FILES) $(LDFLAGS) $(LDTIMEOBJ) $(LIBS) -Wl,--out-implib $(BUILD_DIR)/$(DLL).lib $(EXTRA_LDFLAGS)
#$(V)$(AR) cru $(BUILD_DIR)/$(DLL).lib  ./x46FWlogo.png
#line 191 is for x46FW
#ELF = ${NAME}.elf

$(EXE): $(O_FILES)
	@$(PRINT) "$(GREEN)Linking ELF file:  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(CXX) $(OPTFLAGS) -o $(BUILD_DIR)/$(EXE) $(O_FILES) $(GCCFLAG) $(LIBS) $(LDFLAGS) $(EXTRA_LDFLAGS)
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$(EXE) $(COLOR)
#@$(PRINT) "$(GREEN)Section sizes:$(NO_COL)\n"

$(ELF): $(O_FILES)
	@$(PRINT) "$(GREEN)Linking ELF file:  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(CXX) $(OPTFLAGS) -o $(BUILD_DIR)/$(ELF) $(O_FILES) $(GCCFLAG) $(LIBS) $(LDFLAGS) $(EXTRA_LDFLAGS)
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$(ELF) $(COLOR)
#@$(PRINT) "$(GREEN)Section sizes:$(NO_COL)\n"
#$(V)$(SIZE) $(SIZEFLAGS) $(BUILD_DIR)/$@ $(SIZES_SED) $(SIZES_NUMFMT)


$(SO): $(O_FILES)
	@$(PRINT) "$(GREEN)Linking SO file:  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(CXX) -shared $(OPTFLAGS) -o $(BUILD_DIR)/$(SO) $(O_FILES) $(GCCFLAG) $(LIBS) $(LDFLAGS) $(EXTRA_LDFLAGS)
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$(ELF) $(COLOR)

$(HEX): $(ELF)
	@$(PRINT) "$(GREEN)Makeing HEX :  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(OBJCOPY) -O ihex -R .eeprom $(BUILD_DIR)/$(ELF) $(BUILD_DIR)/$(HEX)
	$(V)./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$@
	

$(LIB): $(O_FILES)
	@$(PRINT) "$(GREEN)Makeing LIB :  $(BLUE)$@ $(NO_COL)\n"
	$(V)$(AR) crD $(BUILD_DIR)/$(LIB) $(O_FILES)
	$(V)$(PY3) ./$(SCRTPTS)/get_file_size $(BUILD_DIR)/$@ $(COLOR)
