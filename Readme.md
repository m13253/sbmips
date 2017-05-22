# sbmips

Naïve MIPS32-like CPU design on a Xilinx FPGA

## Features

- Five-stage pipeline
- Data forwarding
- One-instruction delay slot

- No branch prediction
- No privileged instructions
- No interruptions or exceptions

Academic reference purpose only, contains bugs, not suitable for production.

## Implemented instructions

### R-Type

- `sll` - Logical left shift
- `srl` - Logical right shift
- `sra` - Arithmetical right shift
- `sllv` - Logical left shift by value
- `srlv` - Logical right shift by value
- `srav` - Arithmetical right shift by value
- `jr` - Jump by register
- `jalr` - Jump and link by register
- `add` - Add
- `addu` - Add without overflow check
- `sub` - Subtract
- `subu` - Subtract without overflow check
- `and` - Bitwise and
- `or` - Bitwise or
- `xor` - Bitwise exclusive or
- `nor` - Bitwise not or
- `slt` - Set if less than
- `sltu` - Set if unsigned less than

### I-Type

- `beq` - Branch if equal
- `bne` - Branch if not equal
- `addi` - Add immediate value
- `addiu` - Add immediate value without overflow check
- `slti` - Set if less than immediate value
- `sltiu` - Set if less than unsigned immediate value
- `andi` - Bitwise and immediate value
- `ori` - Bitwise or immediate value
- `xori` - Bitwise exclusive or immediate value
- `lui` - Load immediate value as upper half-word
- `lw` - Load word from memory
- `sw` - Store word from memory

### J-Type

- `j` - Jump
- `jal` - Jump and link

### Available pseudo-instructions

- `la` - Load address
- `li` - Load immediate value
- `move` - Move register
- `negu` - Negation
- `nop` - No operation
- `not` - Bitwise not
- `b` - Branch
- `bal` - Branch and link
- `beqz` - Branch if equal to zero
- `bnez` - Branch if not equal to zero

## Model

Development board: Digilent Exynos 3

FPGA chip: Xilinx Spartan-6 `xc6slx16-3csg324`

## I/O

`clk` and `rst` are controlled by two buttons, so you can single-step over the program.

`gclk` is driven by 100 MHz quartz crystal resonator.

`led_sel` is bond to 8 switches.

`led` powers the 4-digit seven-segmented display, showing values of different registers according to `led_sel`.

## License

Released under GNU General Public License version 3 (GPLv3).

See [COPYING](COPYING) for more information.
