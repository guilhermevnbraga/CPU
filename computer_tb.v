// testbench.v
`timescale 1ns/1ps
`include "computer.v"

module computer_tb;

    // Declarar sinais para o módulo DUT (Device Under Test)
    reg [7:0] port_in_00, port_in_01, port_in_02, port_in_03, port_in_04, port_in_05, port_in_06, port_in_07;
    reg [7:0] port_in_08, port_in_09, port_in_10, port_in_11, port_in_12, port_in_13, port_in_14, port_in_15;
    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03, port_out_04, port_out_05, port_out_06, port_out_07;
    wire [7:0] port_out_08, port_out_09, port_out_10, port_out_11, port_out_12, port_out_13, port_out_14, port_out_15;
    reg clk, reset;

    // Instanciar o módulo DUT
    computer uut (
        .port_out_00(port_out_00),
        .port_out_01(port_out_01),
        .port_out_02(port_out_02),
        .port_out_03(port_out_03),
        .port_out_04(port_out_04),
        .port_out_05(port_out_05),
        .port_out_06(port_out_06),
        .port_out_07(port_out_07),
        .port_out_08(port_out_08),
        .port_out_09(port_out_09),
        .port_out_10(port_out_10),
        .port_out_11(port_out_11),
        .port_out_12(port_out_12),
        .port_out_13(port_out_13),
        .port_out_14(port_out_14),
        .port_out_15(port_out_15),
        .port_in_00(port_in_00),
        .port_in_01(port_in_01),
        .port_in_02(port_in_02),
        .port_in_03(port_in_03),
        .port_in_04(port_in_04),
        .port_in_05(port_in_05),
        .port_in_06(port_in_06),
        .port_in_07(port_in_07),
        .port_in_08(port_in_08),
        .port_in_09(port_in_09),
        .port_in_10(port_in_10),
        .port_in_11(port_in_11),
        .port_in_12(port_in_12),
        .port_in_13(port_in_13),
        .port_in_14(port_in_14),
        .port_in_15(port_in_15),
        .clk(clk),
        .reset(reset)
    );

    // Gerar clock
    always begin
        #5 clk = ~clk; // Clock period de 10ns
    end

    // Inicializar sinais
    initial begin
        // Inicializar sinais
        clk = 0;
        reset = 1;
        port_in_00 = 8'h00;
        port_in_01 = 8'h00;
        port_in_02 = 8'h00;
        port_in_03 = 8'h00;
        port_in_04 = 8'h00;
        port_in_05 = 8'h00;
        port_in_06 = 8'h00;
        port_in_07 = 8'h00;
        port_in_08 = 8'h00;
        port_in_09 = 8'h00;
        port_in_10 = 8'h00;
        port_in_11 = 8'h00;
        port_in_12 = 8'h00;
        port_in_13 = 8'h00;
        port_in_14 = 8'h00;
        port_in_15 = 8'h00;

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;

        // Finalizar simulação
        #1300 $finish;
    end

    // Dump file para GTKWave
    initial begin
        $dumpfile("computer_tb.vcd");
        $dumpvars(0, computer_tb);
    end

endmodule
