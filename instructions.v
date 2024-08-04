// Loads and Stores
`define LDA_IMM  8'h86 // Load Register A (Immediate Addressing)
`define LDA_DIR  8'h87 // Load Register A from memory (RAM or IO) (Direct Addressing)
`define LDB_IMM  8'h88 // Load Register B (Immediate Addressing)
`define LDB_DIR  8'h89 // Load Register B from memory (RAM or IO) (Direct Addressing)
`define STA_DIR  8'h96 // Store Register A to memory (RAM or IO)
`define STB_DIR  8'h97 // Store Register B to memory (RAM or IO)
`define STR_DIR  8'h98 // Store Result of Operation to memory (RAM or IO)

// Data Manipulations
`define ADD_AB  8'h42 // A <= A + B
`define SUB_AB  8'h43 // A <= A - B
`define AND_AB  8'h44 // A <= A & B
`define OR_AB   8'h45 // A <= A | B
`define INCA    8'h46 // A <= A + 1
`define DECA    8'h48 // A <= A - 1
`define XOR_AB  8'h4A // A <= A ^ B
`define NOTA    8'h4B // A <= ~A
`define INCB    8'h4C // B <= B + 1
`define DECB    8'h4D // B <= B - 1
`define NOTB    8'h4E // B <= ~B
`define SUB_BA  8'h4F // B <= B - A

// Branches
`define BRA     8'h20 // Branch Always to (ROM) Address
`define BMI     8'h21 // Branch if N == 1 to (ROM) Address
`define BPL     8'h22 // Branch if N == 0 to (ROM) Address
`define BEQ     8'h23 // Branch if Z == 1 to (ROM) Address
`define BNE     8'h24 // Branch if Z == 0 to (ROM) Address
`define BVS     8'h25 // Branch if V == 1 to (ROM) Address 
`define BVC     8'h26 // Branch if V == 0 to (ROM) Address
`define BCS     8'h27 // Branch if C == 1 to (ROM) Address
`define BCC     8'h28 // Branch if C == 0 to (ROM) Address
