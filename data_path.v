`timescale 1ns/1ps
`include "alu.v"

module data_path 
	(
		output reg [7:0] address,
		output reg [7:0] to_memory,
		output reg [7:0] IR_out,
		output reg [3:0] CCR_Result, 
		input wire [7:0] from_memory,
		input wire [2:0] ALU_Sel,
		input wire [1:0] Bus1_Sel, Bus2_Sel,
		input wire IR_Load, MAR_Load, PC_Load, A_Load, B_Load, CCR_Load, PC_Inc, Reset, Clk
	);
     
	reg [7:0] Bus1, Bus2;
	reg [7:0] PC, MAR, A, B, ALU_Result;
	reg [3:0] NZVC; // Registrador para os flags NZVC
	wire [7:0] Result;
	wire [3:0] flags;

	// Mux para selecionar a entrada do Bus1
	always @ (Bus1_Sel, PC, A, B) 
	begin: MUX_BUS1
		case (Bus1_Sel)
			2'b00 : Bus1 = PC;
			2'b01 : Bus1 = A;
			2'b10 : Bus1 = B; 
			default : Bus1 = 8'hXX;
		endcase 
	end
		
	// Mux para selecionar a entrada do Bus2
	always @ (Bus2_Sel, ALU_Result, Bus1, from_memory) 
	begin: MUX_BUS2
		case (Bus2_Sel)
			2'b00 : Bus2 = ALU_Result;
			2'b01 : Bus2 = Bus1;
			2'b10 : Bus2 = from_memory; 
			default : Bus2 = 8'hXX;
		endcase 
	end	
		
	// Atualização dos sinais para memória
	always @ (Bus1, MAR) 
	begin
		to_memory = Bus1;
		address = MAR; 
	end
  
	// Carregamento do registrador MAR
	always @ (posedge Clk or posedge Reset)	
	begin
		if (Reset)
			MAR <= 8'b0;
		else if (MAR_Load) 
			MAR <= Bus2;
	end

	// Carregamento do registrador IR
	always @ (posedge Clk or posedge Reset) 
	begin
		if (Reset)
			IR_out <= 8'b0;
		else if (IR_Load) 
			IR_out <= Bus2;
	end

	// Carregamento e incremento do registrador PC
	always @ (posedge Clk or posedge Reset)
	begin
		if (Reset)
			PC <= 8'b0;
		else if (PC_Load) 
			PC <= Bus2;
		else if (PC_Inc) 
			PC <= PC + 1;
	end
	
	// Carregamento do registrador A
	always @ (posedge Clk or posedge Reset)
	begin
		if (Reset)
			A <= 8'b0;
		else if (A_Load) 
			A <= Bus2;
	end

	// Carregamento do registrador B
	always @ (posedge Clk or posedge Reset)
	begin
		if (Reset)
			B <= 8'b0;
		else if (B_Load) 
			B <= Bus2;
	end

	// Instanciação da ALU
	alu alu0 (
		.Result(Result),
		.NZVC(flags),
		.A(A),
		.B(B),
		.ALU_Sel(ALU_Sel)
	);

	always @ (Result or flags)
	begin
		ALU_Result = Result;
		NZVC = flags;
	end

	// Atualização do registrador CCR
	always @ (posedge Clk or posedge Reset)
	begin
		if (Reset)
			CCR_Result <= 4'b0000;
		else if (CCR_Load)
			CCR_Result <= NZVC;
	end

endmodule
