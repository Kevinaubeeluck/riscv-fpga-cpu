.PHONY: all sim wave clean

MODULE ?= fetch_top
RTL = $(wildcard rtl/*.sv)
TB = tb/tb_$(MODULE).sv
MODULES = alu regfile decoder extend instr_mem d_mem cpu_top

# ═══════════════════════════════════════
# Icarus Verilog (Verilog/SV testbench)
# ═══════════════════════════════════════
all: sim

sim:
	verilator --lint-only -Wall rtl/* --top-module cpu_top -Wno-UNUSEDSIGNAL
	iverilog -g2012 -o sim/$(MODULE)_out $(RTL) $(TB)
	vvp sim/$(MODULE)_out

wave:
	gtkwave waves.vcd &

clean:
	rm -rf sim/*.out waves.vcd

MODULES = alu regfile decoder extend instr_mem d_mem cpu_top

# test_all: loops every module, filters warnings (keeps errors), sums pass/fail
# - 2>/dev/null on iverilog hides "sorry:" compile warnings
# - grep -v filters runtime noise (Loading, WARNING, VCD lines)
# - grep -oP extracts the numbers from "N passed, M failed"
# - ${pass:-0} defaults to 0 if grep found nothing (no Results line)

test_all:
	@total_pass=0; total_fail=0; \
	for mod in $(MODULES); do \
		echo "\n===== Testing $$mod ====="; \
		iverilog -g2012 -o sim/$${mod}_out $(RTL) tb/tb_$${mod}.sv 2>/dev/null; \
		vvp sim/$${mod}_out | grep -v "^Loading\|^WARNING\|^VCD"; \
		pass=$$(vvp sim/$${mod}_out 2>/dev/null | grep -oP '\d+ passed' | grep -oP '\d+'); \
		fail=$$(vvp sim/$${mod}_out 2>/dev/null | grep -oP '\d+ failed' | grep -oP '\d+'); \
		total_pass=$$((total_pass + $${pass:-0})); \
		total_fail=$$((total_fail + $${fail:-0})); \
	done; \
	echo "\n===== ALL TESTS: $$total_pass passed, $$total_fail failed ====="
