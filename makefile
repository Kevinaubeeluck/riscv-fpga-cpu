.PHONY: all sim wave clean

MODULE ?= cpu_top
RTL = $(wildcard rtl/*.sv)
TB = tb/tb_$(MODULE).sv
MODULES = alu regfile decoder extend instr_mem d_mem cpu_top

# ═══════════════════════════════════════
# Icarus Verilog (Verilog/SV testbench)
# ═══════════════════════════════════════
all: sim

sim:
	iverilog -g2012 -o sim/$(MODULE)_out $(RTL) $(TB)
	vvp sim/$(MODULE)_out

wave:
	gtkwave waves.vcd &

clean:
	rm -rf sim/*.out waves.vcd

test_all:
	@for m in $(MODULES); do \
		echo "\n===== Testing $$m ====="; \
		iverilog -g2012 -o sim/$${m}_out $(RTL) tb/tb_$${m}.sv && \
		vvp sim/$${m}_out || exit 1; \
	done
	@echo "\n===== ALL TESTS COMPLETE ====="