# Copyright (c) 2021 Alex Forencich
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

TOPLEVEL_LANG = verilog

SIM ?= icarus
WAVES ?= 0

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

DUT      = axis_async_fifo_adapter
TOPLEVEL = $(DUT)
MODULE   = test_$(DUT)
VERILOG_SOURCES += ../../rtl/$(DUT).f

# handle file list files
process_f_file = $(call process_f_files,$(addprefix $(dir $1),$(shell cat $1)))
process_f_files = $(foreach f,$1,$(if $(filter %.f,$f),$(call process_f_file,$f),$f))
uniq_base = $(if $1,$(call uniq_base,$(foreach f,$1,$(if $(filter-out $(notdir $(lastword $1)),$(notdir $f)),$f,))) $(lastword $1))
VERILOG_SOURCES := $(call uniq_base,$(call process_f_files,$(VERILOG_SOURCES)))

# module parameters
export PARAM_S_DATA_WIDTH := 8
export PARAM_S_KEEP_ENABLE := $(shell echo $$(( $(PARAM_S_DATA_WIDTH) > 8 )))
export PARAM_S_KEEP_WIDTH := $(shell echo $$(( ( $(PARAM_S_DATA_WIDTH) + 7 ) / 8 )))
export PARAM_M_DATA_WIDTH := 8
export PARAM_M_KEEP_ENABLE := $(shell echo $$(( $(PARAM_M_DATA_WIDTH) > 8 )))
export PARAM_M_KEEP_WIDTH := $(shell echo $$(( ( $(PARAM_M_DATA_WIDTH) + 7 ) / 8 )))
export PARAM_DEPTH := $(shell echo $$(( 1024 * ($(PARAM_S_KEEP_WIDTH) > $(PARAM_M_KEEP_WIDTH) ? $(PARAM_S_KEEP_WIDTH) : $(PARAM_M_KEEP_WIDTH)) )))
export PARAM_ID_ENABLE := 1
export PARAM_ID_WIDTH := 8
export PARAM_DEST_ENABLE := 1
export PARAM_DEST_WIDTH := 8
export PARAM_USER_ENABLE := 1
export PARAM_USER_WIDTH := 1
export PARAM_RAM_PIPELINE := 1
export PARAM_OUTPUT_FIFO_ENABLE := 0
export PARAM_FRAME_FIFO := 1
export PARAM_USER_BAD_FRAME_VALUE := 1
export PARAM_USER_BAD_FRAME_MASK := 1
export PARAM_DROP_OVERSIZE_FRAME := $(PARAM_FRAME_FIFO)
export PARAM_DROP_BAD_FRAME := $(PARAM_DROP_OVERSIZE_FRAME)
export PARAM_DROP_WHEN_FULL := 0
export PARAM_MARK_WHEN_FULL := 0
export PARAM_PAUSE_ENABLE := 1
export PARAM_FRAME_PAUSE := 1

ifeq ($(SIM), icarus)
	PLUSARGS += -fst

	COMPILE_ARGS += $(foreach v,$(filter PARAM_%,$(.VARIABLES)),-P $(TOPLEVEL).$(subst PARAM_,,$(v))=$($(v)))

	ifeq ($(WAVES), 1)
		VERILOG_SOURCES += iverilog_dump.v
		COMPILE_ARGS += -s iverilog_dump
	endif
else ifeq ($(SIM), verilator)
	COMPILE_ARGS += -Wno-SELRANGE -Wno-WIDTH

	COMPILE_ARGS += $(foreach v,$(filter PARAM_%,$(.VARIABLES)),-G$(subst PARAM_,,$(v))=$($(v)))

	ifeq ($(WAVES), 1)
		COMPILE_ARGS += --trace-fst
	endif
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

iverilog_dump.v:
	echo 'module iverilog_dump();' > $@
	echo 'initial begin' >> $@
	echo '    $$dumpfile("$(TOPLEVEL).fst");' >> $@
	echo '    $$dumpvars(0, $(TOPLEVEL));' >> $@
	echo 'end' >> $@
	echo 'endmodule' >> $@

clean::
	@rm -rf iverilog_dump.v
	@rm -rf dump.fst $(TOPLEVEL).fst
