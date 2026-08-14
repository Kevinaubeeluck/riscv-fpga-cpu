# RISC-V Pipelined 32I CPU with hazard control

>  **[Full Verification Log — 19 bugs with root-cause analysis](VERIFICATION_LOG.md)**

Most student CPU projects neglect verification and the actual testing of hardware but my aim with this project was to make that the central focus. Overall, i have 137 self-checking tests with 19 bugs found with root causes documented for each. The CPU itself is a pipelined RV32I cpu with hazard control supporting the base ISA. 

## Verification

### Methodology
- 137 self-checking assertions across 10 module-level testbenches
- Automated regression: `make test_all` with pass/fail summary
- Directed tests that aimed to stress logic(e.g. write to reg x0, simultaneous RAW hazards etc.)
- Integration tests: fibonacci, function call/return, full ISA exercise

### Bugs Caught (Highlights)
| Bug | Root Cause | Detection |
|-----|-----------|-----------|
| rd1 always 0 | Independent ports coupled in if/else → latch | Unit test |
| J-type imm doubled | Extra shift on top of implicit LSB=0 | Integration test |
| AluOp='x poisons block | X on case select destabilises entire always_comb | Unit test |
| ResultSrc truncated | TB wire 2-bit, decoder output 3-bit, .* silent | Unit test |
| ForwardBE missed| Same coupling pattern in hazard unit (3rd time)| Reasoning before sim|
| StallD = X| Don't-care on control signal poisons stall logic| Waveform trace|
| TB timing race | #1 delay causes extra PC increment in pipeline | Unit test|

> Full verification log with 19 bugs, root causes, and analysis:
> [VERIFICATION_LOG.md](VERIFICATION_LOG.md)

### Lessons & Design-for-Test Patterns(highlights)
- Defaults-first in `always_comb` prevents inferred latches
- Never use 'x on signals feeding case selects in simulation
- Independent outputs must not share if/else chains
- Documented inline as comments at bug sites for future reference

### Testing Architecture
| Module | Tests | What is tested |
|--------|-------|---------------|
| ALU | 12 | All 10 ops, signed overflow, zero flag |
| Decoder | 67 | Every opcode tested with control signal(relevant to instruction), branch taken/not-taken |
| Regfile | 5 | Dual-port, x0 hardwire, write-before-read |
| Extend | 10 | All 5 immediate types, sign extension |
| Instr Mem | 9 | Sequential fetch, word alignment |
| Data Mem | 2 | Write + readback |
| Fetch Top | 7 | PC mux select, reset, PC+4 increment |
| Execute Top | 3 | ALU source mux, PCSrc logic |
| Hazard Unit | 23 | Forwarding M/W priority, load-use stall, branch flush |
| Pipeline Top | 0 | Integration via .mem programs (waveform-verified instead of testing) |

## Architecture

- 5-stage pipeline (IF → ID → EX → MEM → WB)
- Hazard unit: M→E / W→E forwarding, load-use stalling, branch flushing
- Write-through register file
- 32×32-bit register file (2 read ports, 1 write port, x0 hardwired to zero)
- Separate instruction and data memories
- Combinational ALU (10 operations)
- Full branch logic with eq_check inversion for all 6 branch types
- Parameterised immediate generator (I, S, B, U, J types)

## Supported Instructions

| Type | Instructions |
|------|-------------|
| R-type | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND |
| I-type (ALU) | ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI |
| I-type (Load) | LW |
| I-type (Jump) | JALR |
| S-type | SW |
| B-type | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| U-type | LUI, AUIPC |
| J-type | JAL |



## Build & Run

Running `make` runs the tb_cpu_top testbench producing a waves.vcd which can then be analyse by gtkwave

Running `make test_all` runs every icarus verilog test for each submodule 

Running `make MODULE=(module)` runs the icarus verilog test for the (module)

## Tools
- **Simulation:** Icarus Verilog (iverilog + vvp)
- **Waveforms:** GTKWave
- **Synthesis:** Vivado ML Edition (targeting Xilinx Artix-7)
- **Board:** Basys 3 (planned)

## Roadmap
- [x] Single-cycle CPU (full RV32I)
- [x] 104-test regression suite
- [x] 5-stage pipeline + forwarding
- [ ] UVM testbench for ALU/Decoder
- [ ] Formal assertions (SVA) for control logic
- [ ] FPGA synthesis + board demo
