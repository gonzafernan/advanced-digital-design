# The simulator we want to run our tests with.
SIM = icarus

# The top-level language of the design (verilog or vhdl).
TOPLEVEL_LANG = verilog

# List of Verilog source files.
VERILOG_SOURCES = $(PWD)/src/gp01_ex2.v

# The name of the toplevel module/entity in your design.
COCOTB_TOPLEVEL = gp01_ex2

# The Python modules which contain your testcases.
# The current directory is included in the Python path,
# so you can just specify the module name without the .py extension.
COCOTB_TEST_MODULES = sim.tb_gp01_ex2

# Enable waveform generation.
WAVES = 1

# Includes cocotb's Makefiles which define the build and simulation flows for each supported simulator.
# This must be included *after* all of the variables above are defined.
include $(shell cocotb-config --makefiles)/Makefile.sim
