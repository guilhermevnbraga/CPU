`timescale 1ns/1ps
`include "rom_128x8_sync.v"
`include "rw_96x8_sync.v"
`include "port_out8_sync.v"

module memory2 (
    output wire [7:0] port_out_00,
    output wire [7:0] port_out_01,
    output wire [7:0] port_out_02,
    output wire [7:0] port_out_03,
    output wire [7:0] port_out_04,
    output wire [7:0] port_out_05,
    output wire [7:0] port_out_06,
    output wire [7:0] port_out_07,
    output wire [7:0] port_out_08,
    output wire [7:0] port_out_09,
    output wire [7:0] port_out_10,
    output wire [7:0] port_out_11,
    output wire [7:0] port_out_12,
    output wire [7:0] port_out_13,
    output wire [7:0] port_out_14,
    output wire [7:0] port_out_15,
    output reg [7:0] data_out,
    input wire [7:0] address,
    input wire [7:0] data_in,
    input wire [7:0] port_in_00,
    input wire [7:0] port_in_01,
    input wire [7:0] port_in_02,
    input wire [7:0] port_in_03,
    input wire [7:0] port_in_04,
    input wire [7:0] port_in_05,
    input wire [7:0] port_in_06,
    input wire [7:0] port_in_07,
    input wire [7:0] port_in_08,
    input wire [7:0] port_in_09,
    input wire [7:0] port_in_10,
    input wire [7:0] port_in_11,
    input wire [7:0] port_in_12,
    input wire [7:0] port_in_13,
    input wire [7:0] port_in_14,
    input wire [7:0] port_in_15,
    input wire write,
    input wire clk,
    input wire reset
);
    wire [7:0] rom_data_out, rw_data_out;
    
    // Instanciando os módulos
    rom_128x8_sync rom (
        .data_out(rom_data_out),
        .address(address),
        .clk(clk)
    );

    rw_96x8_sync ram (
        .data_out(rw_data_out),
        .data_in(data_in),
        .address(address),
        .WE(write),
        .clk(clk)
    );

    port_out8_sync ports (
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
        .address(address),
        .data_in(data_in),
        .write(write),
        .clk(clk),
        .reset(reset)
    );

    // Multiplexação dos dados de saída
    always @(*) begin
        if (address < 8'd128)
            data_out = rom_data_out;
        else if (address < 8'd224)
            data_out = rw_data_out;
        else case (address)
            8'hF0: data_out = port_in_00;
            8'hF1: data_out = port_in_01;
            8'hF2: data_out = port_in_02;
            8'hF3: data_out = port_in_03;
            8'hF4: data_out = port_in_04;
            8'hF5: data_out = port_in_05;
            8'hF6: data_out = port_in_06;
            8'hF7: data_out = port_in_07;
            8'hF8: data_out = port_in_08;
            8'hF9: data_out = port_in_09;
            8'hFA: data_out = port_in_10;
            8'hFB: data_out = port_in_11;
            8'hFC: data_out = port_in_12;
            8'hFD: data_out = port_in_13;
            8'hFE: data_out = port_in_14;
            8'hFF: data_out = port_in_15;
            default: data_out = 8'h00;
        endcase
    end

    

endmodule
