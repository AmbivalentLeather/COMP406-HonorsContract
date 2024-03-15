# Modules

Parts of the cpu that I think should be modules in Verilog

I think both the control unit and the ALU will need to know what the opcodes mean

__Note: Every single byte value here is unsigned__

__Note 2: I think everywhere that should output to Rd can actually be handled by the CU and only needs to be an 'output' so to speak. Does not need to output directly to input__

Should there be an "instruction register" as the way to store the instruction?

- Program Counter
    -   IN: clk, rst
    -   OUT: PC
- Control Unit (CU) (A set of switch-case statements)
    -   IN: Instruction, output from ALU
    -   OUT: Rs, Rd, imm, opcode
- Registers (Each one byte, stored in CU[?])
    -   IN: New value
    -   OUT: Stored value
- Memory
    -   Read only
    -   OUT: A byte of an array at the position (PC)
- Arithmatic Logic Unit (ALU)
    -   IN: Opcode, Rs, Rd
    -   OUT: Rd

## Sub-modules in ALU

- Add
    -   IN: Rs, Rd
    -   OUT: Rd
- Sub
    -   IN: Rs, Rd
    -   OUT: Rd
- Dec (Sub a constant 1 from Rd)
    -   IN: Rd
    -   OUT: Rd - 1
- Inc (Add a constant 1 to Rd)
    -   IN: Rd
    -   OUT: Rd + 1

## Sub-modules in CU

- LOAD
    -   IN: Rs, Rd
    -   OUT: Rd
- STORE
    -   IN: Rs, Rd
    -   OUT: Rd
- SKIPZ & SKIPNZ
    -   IN: Rs, Rd, PC
    -   OUT: Rd
- JALR
    -   IN: Rs, Rd, PC
    -   OUT: Rd
- SLI
    -   IN: Rd, IMM
    -   OUT: Rd
- NAND
    -   IN: Rs, Rd
    -   OUT: Rd
- OUT
    -   IN: Rd
    -   OUT: Prints Rd somehow
- IN
    -   IN: Takes input somehow (dip switches?)
    -   OUT: Rd
- HALT
    -   Stop???
- NOP
    -   Do nothing I guess?

Should there be a logical operator ALU?

If there is:
- NAND
- SKIPZ & SKIPNZ(?)
- JALR(?)
- ???
