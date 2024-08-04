`timescale 1ns/1ps
`include "control_unit.v"

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

  // Testbench
  initial begin
    // Abre o arquivo de dump
    $dumpfile("control_unit_tb.vcd");
    $dumpvars(0, tb_control_unit);

    // Inicializa os sinais
    Reset = 1;
    IR = 8'b0;
    CCR_Result = 4'b0;

    // Aplica o reset
    #10 Reset = 0;
    #10 Reset = 1;

    // Testa as instruções
    // Fetch
    #10 IR = 8'h86; // LDA_IMM
    #30 IR = 8'h87; // LDA_DIR
    #30 IR = 8'h88; // LDB_IMM
    #30 IR = 8'h89; // LDB_DIR
    #30 IR = 8'h96; // STA_DIR
    #30 IR = 8'h97; // STB_DIR
    #30 IR = 8'h98; // STR_DIR
    #30 IR = 8'h42; // ADD_AB
    #30 IR = 8'h43; // SUB_AB
    #30 IR = 8'h44; // AND_AB
    #30 IR = 8'h45; // OR_AB
    #30 IR = 8'h46; // INCA
    #30 IR = 8'h48; // DECA
    #30 IR = 8'h4A; // XOR_AB
    #30 IR = 8'h47; // NOTA
    #30 IR = 8'h49; // INCB
    #30 IR = 8'h50; // DECB
    #30 IR = 8'h51; // NOTB
    #30 IR = 8'h52; // SUB_BA

    // Testa instruções de desvio com diferentes condições de CCR_Result
    #30 IR = 8'h20; CCR_Result = 4'b0001; // BCS
    #30 IR = 8'h20; CCR_Result = 4'b0000; // BCC
    #30 IR = 8'h21; CCR_Result = 4'b0010; // BEQ
    #30 IR = 8'h21; CCR_Result = 4'b0000; // BNE
    #30 IR = 8'h22; CCR_Result = 4'b0100; // BMI
    #30 IR = 8'h22; CCR_Result = 4'b0000; // BPL
    #30 IR = 8'h23; CCR_Result = 4'b1000; // BVS
    #30 IR = 8'h23; CCR_Result = 4'b0000; // BVC

    // Finaliza a simulação
    #50 $finish;
  end

endmodule
