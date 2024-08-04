`timescale 1ns/1ps
`include "cpu.v"
`include "memory2.v"

module computer 
	(output reg [7:0] port_out_00,
	 output reg [7:0] port_out_01,
	 output reg [7:0] port_out_02,
	 output reg [7:0] port_out_03,
	 output reg [7:0] port_out_04,
	 output reg [7:0] port_out_05,
	 output reg [7:0] port_out_06,
	 output reg [7:0] port_out_07,
	 output reg [7:0] port_out_08,
	 output reg [7:0] port_out_09,
	 output reg [7:0] port_out_10,
	 output reg [7:0] port_out_11,
	 output reg [7:0] port_out_12,
	 output reg [7:0] port_out_13,
	 output reg [7:0] port_out_14,
	 output reg [7:0] port_out_15,
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
	 input wire clk, reset);

    wire [7:0] data_out;
    wire [7:0] address;
    wire [7:0] data_in;
    wire write;

	cpu uut (
		.address(address),
		.to_memory(data_in),
		.write(write),
		.from_memory(data_out),
		.clk(clk),
		.reset(reset)
	);

	memory2 memory (
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
	 		
endmodule