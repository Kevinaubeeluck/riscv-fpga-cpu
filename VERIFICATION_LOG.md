```markdown
# Verification Log

This is a record of every single bug i found testing each unit individually and as a full cpu. I have it setup in a regular symptom, cause, detection, fix for it, lesson to learn 
---

## Bug #1 — x0 Hardwire Test Logic Inverted

| | |
|---|---|
| **Symptom** | x0 Writable |
| **Root Cause** | Testbench had a test which wrote to x0 that passed if x0 was succesfully written to making the error invisible from running the module tests. |
| **Detection** | Code review |
| **Fix** | `check("x0 hardwired", rd2, 32'h00000000)` |
| **Lesson** | Run through the logic of each test, after this issue i tried being more verbose in why i expect what output |

---

## Bug #2 — rd1 Always Reads 0

| | |
|---|---|
| **Symptom** | Writing 0xDEADBEEF to x5, reading back from rd1 returns 0 |
| **Root Cause** | `if(ra1=='0)` / `else if(ra2=='0)` / `else` chain meant only one branch executes. When ra2==0, rd1 is never assigned → inferred latch at 0. Two independent ports were incorrectly coupled in one if/else chain. |
| **Detection** | Regfile unit test: write-then-read |
| **Fix** | Separate into independent ternaries: `rd1 = (ra1=='0) ? '0 : registers[ra1];` |
| **Lesson** | Every signal must be assigned in every branch of `always_comb`. Independent outputs must never share an if/else chain. Defaults-first pattern prevents this class of bug entirely. |

---

## Bug #3 — Array Name Typo (`register` vs `registers`)

| | |
|---|---|
| **Symptom** | Elaboration failed |
| **Root Cause** | Used singular `register[ra1]` but array declared as `registers` |
| **Detection** | Icarus error: "Unable to bind wire/reg/memory `register[ra1]`" |
| **Fix** | Match array name to declaration |
| **Lesson** | Pay more attention to the error messages!!! Spend ages on a minor spelling error because i didn't take the time to read it carefully and notice i had an extra 's' |

---

## Bug #4 — Simulation Binaries Committed to Git

| | |
|---|---|
| **Symptom** | Committed way too many lines obsuring my actual code changes |
| **Root Cause** | `git add .` included `sim/alu_out` (2361 lines), `sim/regfile_out` (2138 lines), `waves.vcd` |
| **Detection** | `git diff --stat HEAD~1` |
| **Fix** | `.gitignore` with `sim/`, `*.vcd`, then `git rm --cached` |
| **Lesson** | Use `git diff --stat` before pushing from now on and any file that my program generates i add to git ignore. |

---

## Bug #5 — `test_all` Target Missing `-g2012` Flag

| | |
|---|---|
| **Symptom** | "syntax error / I give up." on line 1 of testbench |
| **Root Cause** | Makefile `test_all` target omitted `-g2012`, so Icarus treated file as Verilog-2005. `logic` keyword is SystemVerilog-only. |
| **Detection** | `make test_all` — first module compiled fine (had flag), second didn't |
| **Fix** | Add `-g2012` to the iverilog command in test_all loop |
| **Lesson** | This is less of a lesson for remembering the "I give up" keyword and more for searching up error messages SPECIFIC to the tool i'm using which in this case was icarus verilog. |

---

## Bug #6 — J-type Immediate Doubled

| | |
|---|---|
| **Symptom** | JAL with offset 0x4C produces ImmExt = 0x98 (exactly 2×) |
| **Root Cause** | When i was coding extend.sv, i saw the fact that any branch/jump instruction has an implicit 0 at the bottom of it so i thought i would just have to shift it. I however, concatenated a 0 at the bottom aswell meaning i had already got out my immediate and also shifted it|
| **Detection** | CPU integration test: JAL landed at wrong PC target |
| **Fix** | Remove the extra shift — just concatenate `1'b0`, the encoding already accounts for alignment |
| **Lesson** | Walk through the logic bit by bit if needed and having somewhere to write WHY i did a step logically would have prevented this error as immediately as you put it words, it becomes a lot clearer why this is stupid |

---

## Bug #7 — ResultSrc Wire Width Mismatch in cpu_top

| | |
|---|---|
| **Symptom** | ResultSrc shows XXX (red) in waveform during LUI |
| **Root Cause** | Decoder output widened to 2+ bits, but `cpu_top.sv` wire still declared as 1-bit. MSB floats → X propagates into Result MUX. |
| **Detection** | Waveform inspection: ResultSrc=XXX when it should be 2'b10 |
| **Fix** | Match wire width in cpu_top to decoder output port width |
| **Lesson** | Do a search for every appearance of a variable so you can understand its connections and dependencies |

---

## Bug #8 — Register File wd=X Despite Valid Result

| | |
|---|---|
| **Symptom** | `Result = 0x12345000` but `wd = XXXXXXXX` going into regfile in gtkwave |
| **Root Cause** | Regfile `.wd()` port connected to `RegDataWire` which was either unassigned or assigned from a stale signal. It occured because i refactored my code to use less signals and muxes but i forgot to update dependencies |
| **Detection** | Waveform: traced Result → wd, found disconnect |
| **Fix** | Wire `.wd(Result)` directly, remove unnecessary intermediate signal |
| **Lesson** | ALWAYS trace the full signal out before you make any modifications.  |

---

## Bug #9 — always_comb Ordering: Signals Used Before Computed

| | |
|---|---|
| **Symptom** | PCTarget and Result gave me XXXX in gtkwave despite correct inputs |
| **Root Cause** | `case(ResultSrc)` and `case(PCSrc)` used PCTarget and PCPlus4, but those were assigned AFTER the case statements. `always_comb` is sequential top-to-bottom — reading before assigning gives the previous evaluation's value. |
| **Detection** | Waveform: values lagged by one cycle |
| **Fix** | Move `PCTarget = Pc + ImmExt;` and `PCPlus4 = Pc + 4;` to the TOP of the always_comb block |
| **Lesson** | In an always_comb block, ALWAYS compute dependencies before you use them otherwise you assign garbage which won't update when the dependencies resolve later. It's the same thing as using a variable without initialisation.  |


---

## Bug #11 — Testbench Wire Width Truncates Decoder Outputs

| | |
|---|---|
| **Symptom** | AUIPC ResultSrc expected 4 (3'b100), got 0. JAL PCSrc expected 2 (2'b10), got 0. |
| **Root Cause** | TB declared `logic PCSrc` (1-bit) and `logic [1:0] ResultSrc` (2-bit). Decoder outputs are `[1:0]` PCSrc and `[2:0]` ResultSrc. i used a `.*` port connection which doesn't warn when theres a bit width mismatch (SILENT FAILS KILL VERIFICATION ENGINEERS :( ))  |
| **Detection** | Decoder unit test: systematic failures on newly-added opcodes only |
| **Fix** | Match TB wire declarations to decoder port widths |
| **Lesson** | ALWAYS look at bit widths when adjusting the signals  |

---

## Bug #12 — JALR Test Drives Wrong Opcode

| | |
|---|---|
| **Symptom** | JALR PCSrc expected 3 (2'b11), got 2 |
| **Root Cause** | TB stimulus line: `op = jal` but the checks expect JALR behaviour |
| **Detection** | Decoder unit test: JALR checks fail with JAL values |
| **Fix** | Change stimulus to `op = jalr` and fix expected ImmSrc (should be I-type, not J-type) |
| **Lesson** | I need to set up templates for copying and pasting to make copy and paste errors less frequent |

---

## Bug #13 — JAL PCSrc Routes to Wrong MUX Input

| | |
|---|---|
| **Symptom** | PC jumps to raw immediate value instead of PC-relative target |
| **Root Cause** | `PCSrc = 2'b10` in decoder mapped to `PcNext = ImmExt` in cpu_top. But JAL needs `PcNext = PCTarget` (which is PC + ImmExt). Wrong encoding. |
| **Detection** | Waveform: PC jumped to 0x48 instead of PC+0x48 |
| **Fix** | JAL should select the PCTarget mux input (2'b01), not the ImmExt input |
| **Lesson** | Draw out a block diagram and cross reference it with the top level module  |

---

## Bug #15 — GTKWave Number Format Mismatch (Non-bug)

| | |
|---|---|
| **Symptom** | Result = 305418240 but ImmExt = 12345000 — appear different |
| **Root Cause** | Not a bug. 305418240 (decimal) = 0x12345000 (hex). Signals displayed in different radixes. |
| **Detection** | Visual inspection of waveform |
| **Fix** | Right-click signal → Data Format → Hex |
| **Lesson** | Before i panic and read through every single line of logic make sure my data is all displayed in the exact same format to prevent false positives |

---

## Bug #16 — Result MUX Missing Case Entries

| | |
|---|---|
| **Symptom** | Result=X when ResultSrc selects new values (2'b10, 2'b11, 3'b100) |
| **Root Cause** | cpu_top Result MUX only handled `00` (ALU) and `01` (Memory). Adding LUI/AUIPC/JAL required new ResultSrc values, but the MUX wasn't expanded. |
| **Detection** | Waveform: Result goes X on LUI despite valid ImmExt |
| **Fix** | Expand to full `case(ResultSrc)` with all 5 options + default |
| **Lesson** | Changing the decoder output means changing all muxes that are linked to that output, again this is a tracing the datapath issue |

---


## Patterns 

### Most Common Root Causes
1. **Width mismatches**  — Look at the entire datapath before you update the width of something to keep track of dependencies 
2. **always_comb semantics** — Imagine always comb to be more like an programming language with sequential execution, you'd never assign a variable with an unintialised variable and it's the same for an always comb block
3. **Test quality**  — Write a good reliable format with justifications that is easily modifable(like tb_temple.sv)


### How i'm going to code differently 
- **Defaults-first pattern** — prevents inferred latches and undriven signals
- **Inline bug comments** — documented mistakes at the code site for future reference
- **Self-checking testbenches** — pass/fail framework catches regressions immediately
- **Waveform debugging protocol** — only open GTKWave after a test fails, trace from symptom to source
```