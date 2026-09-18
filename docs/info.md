## Introduction

This project is a small 4-bit stack-based computer with:

* 7 instructions
* 16 × 8-bit program memory
* 8 × 4-bit stack memory

The CPU is designed to execute simple arithmetic, logic, stack, and conditional jump operations using a compact instruction set.

## How it works

This project implements a small 4-bit stack-based CPU. Every instruction is encoded as a single 8-bit word:

```text
[7:4] — opcode
[3:0] — operand / data
```

The supported instructions are:

| Opcode | Instruction | Description                                                        |
| ------ | ----------- | ------------------------------------------------------------------ |
| `1000` | `NAND`      | Performs a NAND operation                                          |
| `1001` | `NOR`       | Performs a NOR operation                                           |
| `1010` | `XOR`       | Performs an XOR operation                                          |
| `1011` | `ADD`       | Adds two stack values                                              |
| `1101` | `PUSH_COMP` | Pushes a comparison value onto the stack                           |
| `1110` | `PUSH`      | Pushes the 4-bit operand onto the stack                            |
| `0010` | `JMPC`      | Conditionally jumps depending on the value at the top of the stack |

Each instruction requires only one 8-bit instruction word.

For example:

```text
1110 0101
```

means:

```text
1110 → PUSH
0101 → value 5
```

So this instruction pushes the value `5` onto the stack.

> **Note:** `PUSH_COMP` is used together with `JMPC` to provide simple conditional program flow. The comparison result is placed on the stack, and `JMPC` uses that value to decide whether the program counter should jump to another instruction.

## How to test

Use the following sample program:

```text
PUSH_COMP 1001
PUSH      0001
ADD       0001
JMPC      0010
PUSH      0001
```

To test the CPU:

1. Reset the chip.
2. Load each instruction into program memory one by one using `program_mem_write_button` and `program_in`.
3. After each instruction is loaded, `program_stack` should increase, indicating the next program memory address.
4. After all instructions have been loaded, press `start_button` to start CPU execution.
5. After execution finishes, press `read_result_button`.
6. Read the result from the `after_compute` output.

For this sample program, the expected output is:

```text
after_compute = 0001
```

## External hardware

* LEDs for output signals such as `after_compute` and `program_stack`.
* Push buttons for:

  * `read_result_button`
  * `start_button`
  * `program_mem_write_button`
* Switches for `program_in` (the switch values should remain stable while loading the instruction).

