`include "instructions.v"

module rom_128x8_sync (
    output reg [7:0] data_out,
    input wire [7:0] address,
    input wire clk
);
    reg [7:0] ROM[0:127];
    reg EN;  // Correção aqui

    initial begin: PROGRAM_CODE
        // Nulificador de contas (torna o resultado de uma operação em 0)
        ROM[0] = `LDA_IMM;    // Carrega o registrador A com um valor imediato
        ROM[1] = 8'h07;      // Valor para A
        ROM[2] = `LDB_IMM;    // Carrega o registrador B com um valor imediato
        ROM[3] = 8'h09;      // Valor para B
        ROM[4] = `SUB_AB;     // Subtrai B de A, resultado em A
        ROM[5] = `STR_DIR;    // Armazena o resultado em um endereço da RAM
        ROM[6] = 8'h80;      // Endereço na RAM para armazenar o resultado
        ROM[7] = `BEQ;        // Se o resultado for zero, salta para End
        ROM[8] = 8'h14;      // Endereço para salto (End)
        ROM[9] = `BMI;        // Se o resultado for negativo, salta para Neg
        ROM[10] = 8'h0D;     // Endereço para salto (Neg)
        ROM[11] = `DECA;      // Se o resultado for positivo, decrementa A
        ROM[12] = `BRA;       // Salta de volta para armazenar o valor decrementado
        ROM[13] = 8'h05;     // Endereço de volta para STR_DIR
        ROM[14] = `INCA;      // Neg: Incrementa A
        ROM[15] = `BRA;       // Salta de volta para armazenar o valor incrementado
        ROM[16] = 8'h05;     // Endereço de volta para STR_DIR
        ROM[17] = `LDA_DIR;   // End: Carrega o valor final de A da RAM
        ROM[18] = 8'h80;     // Endereço na RAM onde o resultado foi armazenado
        ROM[19] = `STA_DIR;   // Armazena o valor final em um endereço de saída
        ROM[20] = 8'hE0;     // Endereço da saída
        ROM[21] = `BRA;       // Salta para o início do programa (loop infinito)
        ROM[22] = 8'h00;     // Endereço do início do programa
    end

    always @ (address) begin: ADDRESS_LIMITS
        EN = ((address >= 0) && (address <= 127));
    end

    always @ (posedge clk) begin
        if (EN)
            data_out = ROM[address]; 
    end

endmodule
