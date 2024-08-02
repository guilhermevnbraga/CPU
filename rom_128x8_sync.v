module rom_128x8_sync (
    output reg [7:0] data_out,
    input wire [7:0] address,
    input wire clk
);
    reg [7:0] ROM[0:127];
    reg EN;  // Correção aqui

    // Mnemonics of Instruction Set
    // Feel free to add other

    // Loads and Stores
    parameter LDA_IMM = 8'h86; // Load Register A (Immediate Addressing)
    parameter LDA_DIR = 8'h87; // Load Register A from memory (RAM or IO) (Direct Addressing)
    parameter LDB_IMM = 8'h88; // Load Register B (Immediate Addressing)
    parameter LDB_DIR = 8'h89; // Load Register B from memory (RAM or IO) (Direct Addressing)
    parameter STA_DIR = 8'h96; // Store Register A to memory (RAM or IO)
    parameter STB_DIR = 8'h97; // Store Register B to memory (RAM or IO)
    parameter STR_DIR = 8'h98; // Store Result of Operation to memory (RAM or IO)
    

    // Data Manipulations, Connect reg A (B) to Input A (B) of ALU (Easier)
    parameter ADD_AB  = 8'h42; // A <= A + B
    parameter SUB_AB  = 8'h43; // A <= A - B
    parameter AND_AB  = 8'h44; // A <= A & B
    parameter OR_AB   = 8'h45; // A <= A | B
    parameter INCA    = 8'h46; // A <= A + 1
    parameter DECA    = 8'h48; // A <= A - 1
    parameter XOR_AB  = 8'h4A; // A <= A ^ B
    parameter NOTA    = 8'h4B; // A <= ~A
    parameter INCB    = 8'h4C; // B <= B + 1
    parameter DECB    = 8'h4D; // B <= B - 1
    parameter NOTB    = 8'h4E; // B <= ~B
    parameter SUB_BA  = 8'h4F; // B <= B - A

    // Feel free to include more like INCB, DECB, NOTB, SUB_BA etc

    // Branches
    parameter BRA     = 8'h20; // Branch Always to (ROM) Address
    parameter BMI     = 8'h21; // Branch if N == 1 to (ROM) Address
    parameter BPL     = 8'h22; // Branch if N == 0 to (ROM) Address
    parameter BEQ     = 8'h23; // Branch if Z == 1 to (ROM) Address
    parameter BNE     = 8'h24; // Branch if Z == 0 to (ROM) Address
    parameter BVS     = 8'h25; // Branch if V == 1 to (ROM) Address 
    parameter BVC     = 8'h26; // Branch if V == 0 to (ROM) Address
    parameter BCS     = 8'h27; // Branch if C == 1 to (ROM) Address
    parameter BCC     = 8'h28; // Branch if C == 0 to (ROM) Address

    initial begin: PROGRAM_CODE
        // Nulificador de contas (torna o resultado de uma operação em 0)
        ROM[0] = LDA_IMM;    // Carrega o registrador A com um valor imediato
        ROM[1] = 8'h07;      // Valor para A
        ROM[2] = LDB_IMM;    // Carrega o registrador B com um valor imediato
        ROM[3] = 8'h09;      // Valor para B
        ROM[4] = SUB_AB;     // Subtrai B de A, resultado em A
        ROM[5] = STR_DIR;    // Armazena o resultado em um endereço da RAM
        ROM[6] = 8'h80;      // Endereço na RAM para armazenar o resultado
        ROM[7] = BEQ;        // Se o resultado for zero, salta para End
        ROM[8] = 8'h14;      // Endereço para salto (End)
        ROM[9] = BMI;        // Se o resultado for negativo, salta para Neg
        ROM[10] = 8'h0D;     // Endereço para salto (Neg)
        ROM[11] = DECA;      // Se o resultado for positivo, decrementa A
        ROM[12] = BRA;       // Salta de volta para armazenar o valor decrementado
        ROM[13] = 8'h05;     // Endereço de volta para STR_DIR
        ROM[14] = INCA;      // Neg: Incrementa A
        ROM[15] = BRA;       // Salta de volta para armazenar o valor incrementado
        ROM[16] = 8'h05;     // Endereço de volta para STR_DIR
        ROM[17] = LDA_DIR;   // End: Carrega o valor final de A da RAM
        ROM[18] = 8'h80;     // Endereço na RAM onde o resultado foi armazenado
        ROM[19] = STA_DIR;   // Armazena o valor final em um endereço de saída
        ROM[20] = 8'hE0;     // Endereço da saída
        ROM[21] = BRA;       // Salta para o início do programa (loop infinito)
        ROM[22] = 8'h00;     // Endereço do início do programa
    end

    always @ (address) begin: ADDRESS_LIMITS
        if ((address >= 0) && (address <= 127))
            EN = 1'b1;
        else
            EN = 1'b0;
    end

    always @ (posedge clk) begin
        if (EN)
            data_out = ROM[address]; 
    end

endmodule
