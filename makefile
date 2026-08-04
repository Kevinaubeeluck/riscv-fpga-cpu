.PHONY: all sim wave clean

MODULE = instr_mem
RTL = $(wildcard rtl/*.sv)
TB = tb/tb_d_mem.sv

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