TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/top_pwm.v $(PWD)/reg_if.v $(PWD)/pwm_core.v
TOPLEVEL = top_pwm
MODULE = test_pwm

SIM = iverilog

include $(shell cocotb-config --makefiles)/Makefile.sim
