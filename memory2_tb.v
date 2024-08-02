`timescale 1ns/1ps
`include "memory2.v"
module memory2_tb;

    reg [7:0] address;
    reg [7:0] data_in;
    reg write;
    reg clk;
    reg reset;
    wire [7:0] data_out;
    reg [7:0] port_in_00, port_in_01, port_in_02, port_in_03, port_in_04, port_in_05, port_in_06, port_in_07, port_in_08, port_in_09, port_in_10, port_in_11, port_in_12, port_in_13, port_in_14, port_in_15;
    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03, port_out_04, port_out_05, port_out_06, port_out_07, port_out_08, port_out_09, port_out_10, port_out_11, port_out_12, port_out_13, port_out_14, port_out_15;

    memory2 DUT (
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
        .data_out(data_out),
        .address(address),
        .data_in(data_in),
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
        .write(write),
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        // Iniciar inputs
        address = 0;
        data_in = 0;
        write = 0;
        clk = 0;
        reset = 0;
        port_in_00 = 8'hA0;
        port_in_01 = 8'hA1;
        port_in_02 = 8'hA2;
        port_in_03 = 8'hA3;
        port_in_04 = 8'hA4;
        port_in_05 = 8'hA5;
        port_in_06 = 8'hA6;
        port_in_07 = 8'hA7;
        port_in_08 = 8'hA8;
        port_in_09 = 8'hA9;
        port_in_10 = 8'hAA;
        port_in_11 = 8'hAB;
        port_in_12 = 8'hAC;
        port_in_13 = 8'hAD;
        port_in_14 = 8'hAE;
        port_in_15 = 8'hAF;

        $dumpfile("memory2_tb.vcd");
        $dumpvars(0, memory2_tb);

        // Reset
        reset = 0;
        #10;
        reset = 1;
        #10;

        // Ler ROM
        address = 8'd0;
        #10;
        address = 8'd1;
        #10;

        // Escrever e ler na RAM
        write = 1;
        address = 8'd128;
        data_in = 8'h55;
        #10;
        write = 0;
        address = 8'd128;
        #10;

        // Escrever e ler porta de saída
        write = 1;
        address = 8'hE0;
        data_in = 8'hAA;
        #10;
        write = 0;
        address = 8'hE0;
        #10;

        // Reset
        reset = 0;
        #10;
        reset = 1;
        #10;

        $finish;
    end



endmodule
