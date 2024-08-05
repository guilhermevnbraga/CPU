`timescale 1ns/1ps
`include "control_unit2.v"

module tb_control_unit;

  reg [7:0] IR;
  reg [3:0] CCR_Result;
  reg Clk, Reset;
  wire IR_Load, MAR_Load, PC_Load, PC_Inc;
  wire A_Load, B_Load, CCR_Load;
  wire [2:0] ALU_Sel;
  wire [1:0] Bus1_Sel, Bus2_Sel;
  wire write;

  // Instancia a unidade de controle
  control_unit uut (
    .IR_Load(IR_Load),
    .MAR_Load(MAR_Load),
    .PC_Load(PC_Load),
    .PC_Inc(PC_Inc),
    .A_Load(A_Load),
    .B_Load(B_Load),
    .CCR_Load(CCR_Load),
    .ALU_Sel(ALU_Sel),
    .Bus1_Sel(Bus1_Sel),
    .Bus2_Sel(Bus2_Sel),
    .write(write),
    .IR(IR),
    .CCR_Result(CCR_Result),
    .Clk(Clk),
    .Reset(Reset)
  );

  // Gera o clock
  initial begin
    Clk = 0;
    forever #5 Clk = ~Clk;
  end

  // Sequência de instruções
  reg [7:0] instruction_sequence [0:35];
  integer i;

  initial begin
    // Inicializa a sequência de instruções
    instruction_sequence[0]  = 8'h86; // LDA_IMM
    instruction_sequence[1]  = 8'h87; // LDA_DIR
    instruction_sequence[2]  = 8'h88; // LDB_IMM
    instruction_sequence[3]  = 8'h89; // LDB_DIR
    instruction_sequence[4]  = 8'h96; // STA_DIR
    instruction_sequence[5]  = 8'h97; // STB_DIR
    instruction_sequence[6]  = 8'h98; // STR_DIR
    instruction_sequence[7]  = 8'h42; // ADD_AB
    instruction_sequence[8]  = 8'h43; // SUB_AB
    instruction_sequence[9]  = 8'h44; // AND_AB
    instruction_sequence[10] = 8'h45; // OR_AB
    instruction_sequence[11] = 8'h46; // INCA
    instruction_sequence[12] = 8'h48; // DECA
    instruction_sequence[13] = 8'h4A; // XOR_AB
    instruction_sequence[14] = 8'h4B; // NOTA
    instruction_sequence[15] = 8'h4C; // INCB
    instruction_sequence[16] = 8'h4D; // DECB
    instruction_sequence[17] = 8'h4E; // NOTB
    instruction_sequence[18] = 8'h4F; // SUB_BA
    instruction_sequence[19] = 8'h20; // BRA
    instruction_sequence[20] = 8'h21; // BMI True
    instruction_sequence[21] = 8'h21; // BMI False
    instruction_sequence[22] = 8'h22; // BPL True
    instruction_sequence[23] = 8'h22; // BPL False
    instruction_sequence[24] = 8'h23; // BEQ True
    instruction_sequence[25] = 8'h23; // BEQ False
    instruction_sequence[26] = 8'h24; // BNE True
    instruction_sequence[27] = 8'h24; // BNE False
    instruction_sequence[28] = 8'h25; // BVS True
    instruction_sequence[29] = 8'h25; // BVS  False
    instruction_sequence[30] = 8'h26; // BVC  True
    instruction_sequence[31] = 8'h26; // BVC  False
    instruction_sequence[32] = 8'h27; // BCS  True
    instruction_sequence[33] = 8'h27; // BCS  False
    instruction_sequence[34] = 8'h28; // BCC  True
    instruction_sequence[35] = 8'h28; // BCC  False

    // Inicializa os sinais
    Reset = 1;
    IR = 8'b0;
    CCR_Result = 4'b0;

    // Abre o arquivo de dump
    $dumpfile("control_unit_tb.vcd");
    $dumpvars(0, tb_control_unit);

    // Aplica o reset
    #10 Reset = 0;
    #10 Reset = 1;

    // Atribui valores ao IR quando IR_Load é ativado
    for (i = 0; i < 30; i = i + 1) begin
      @(posedge IR_Load);
      IR = instruction_sequence[i];
      case (i)
        20: CCR_Result = 4'b1000; // BMI True
        21: CCR_Result = 4'b0000; // BMI False
        22: CCR_Result = 4'b0000; // BPL True
        23: CCR_Result = 4'b1000; // BPL False
        24: CCR_Result = 4'b0100; // BEQ True
        25: CCR_Result = 4'b0000; // BEQ False
        26: CCR_Result = 4'b0000; // BNE True
        27: CCR_Result = 4'b0100; // BNE False
        28: CCR_Result = 4'b0010; // BVS True
        29: CCR_Result = 4'b0000; // BVS False
        30: CCR_Result = 4'b0000; // BVC True
        31: CCR_Result = 4'b0010; // BVC False
        32: CCR_Result = 4'b0001; // BCS True
        33: CCR_Result = 4'b0000; // BCS False
        34: CCR_Result = 4'b0000; // BCC True
        35: CCR_Result = 4'b0001; // BCC False
      endcase
    end

    // Finaliza a simulação
    $finish;
  end

endmodule
