# RISC-V Single cycle 32I cpu

Hello, welcome to my project repo!! This is my implementation of RISC-V single cycle cpu that supports the base integer ISA. This has 104 unit tests total with each module having its own testbench and verbose enough commenting to understand the reasoning behind the decisions made

## Verification

### Methodology
- 104 self-checking assertions across 7 module-level testbenches
- Automated regression: `make test_all` with pass/fail summary
- Directed tests for architectural corner cases
- Integration tests: fibonacci, function call/return, full ISA exercise

### Bugs Caught (Highlights)
| Bug | Root Cause | Detection |
|-----|-----------|-----------|
| rd1 always 0 | Independent ports coupled in if/else → latch | Unit test |
| J-type imm doubled | Extra shift on top of implicit LSB=0 | Integration test |
| AluOp='x poisons block | X on case select destabilises entire always_comb | Unit test |
| ResultSrc truncated | TB wire 2-bit, decoder output 3-bit, .* silent | Unit test |

> Full verification log with 14 bugs, root causes, and analysis:
> [VERIFICATION_LOG.md](VERIFICATION_LOG.md)

### Testing Architecture
| Module | Tests | Coverage Focus |
|--------|-------|---------------|
| ALU | 12 | All 10 ops, signed overflow, zero flag |
| Decoder | 45 | Every opcode tested with control signal(relevant to instruction), branch taken/not-taken |
| Regfile | 5 | Dual-port, x0 hardwire, write-before-read |
| Extend | 10 | All 5 immediate types, sign extension |
| Instr Mem | 9 | Sequential fetch, word alignment |
| Data Mem | 2 | Write + readback |
| CPU Top | 21 | Multi-instruction integration programs |

### Lessons & Design-for-Test Patterns
- Defaults-first in `always_comb` prevents inferred latches
- Never use 'x on signals feeding case selects in simulation
- Independent outputs must not share if/else chains
- Documented inline as comments at bug sites for future reference

## Build & Run

Running `make` runs the tb_cpu_top testbench producing a waves.vcd which can then be analyse by gtkwave

Running `make test_all` runs every icarus verilog test for each submodule 

Running `make MODULE=(module)` runs the icarus verilog test for the (module)


## Roadmap
- [x] Single-cycle CPU (full RV32I)
- [x] 104-test regression suite
- [ ] 5-stage pipeline + forwarding
- [ ] UVM testbench for ALU/Decoder
- [ ] Formal assertions (SVA) for control logic
- [ ] FPGA synthesis + board demo