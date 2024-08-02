I. I. I module data_path 
	(output reg [7:0] address,
	 output reg [7:0] to_memory,
	 output reg [7:0] IR_out,
	 output reg [3:0] CCR_Result, 
	 input wire [7:0] from_memory,
	 input wire [2:0] ALU_Sel,
	 input wire [1:0] Bus1_Sel, Bus2_Sel,
	 input wire IR_Load, MAR_Load, PC_Load, A_Load, B_Load, CCR_Load,  
     input wire Clk, Reset);
     
     wire [7:0] Bus1, Bus2;
     wire [7:0] PC, MAR, A, B, ALU_Result;
     
     always @ (Bus1_Sel, PC, A, B) 
     	begin: MUX_BUS1
			case (Bus1_Sel)
				2'b00 : Bus1 = PC;
				2'b01 : Bus1 = A;
				2'b10 : Bus1 = B; 
				default : Bus1 = 8'hXX;
			endcase 
		end
		
	 always @ (Bus2_Sel, ALU_Result, Bus1, from_memory) 
		begin: MUX_BUS2
			case (Bus2_Sel)
				2'b00 : Bus2 = ALU_Result;
				2'b01 : Bus2 = Bus1;
				2'b10 : Bus2 = from_memory; 
				default : Bus2 = 8'hXX;
			endcase 
		end	
		
	 always @ (Bus1, MAR) 
	 	begin
			to_memory = Bus1;
			address = MAR; 
		end
  
	always @ (MAR_Load, address, Bus2)	
		begin
			if (MAR_Load) 
				MAR = Bus2;
			else
				MAR = address;
		end

	always @ (IR_Load, Bus2) 
		begin
			if (IR_Load) 
				IR_out = Bus2;
		end

	always @ (PC_Load, PC, Bus2)
		begin
			if (PC_Load) 
				PC = Bus2;
			else
				PC = PC;
		end
	
	always @ (A_Load, A, Bus1)
		begin
			if (A_Load) 
				A = Bus1;
			else
				A = A;
		end

	always @ (B_Load, B, Bus1)
		begin
			if (B_Load) 
				B = Bus1;
			else
				B = B;
		end

	always @ (ALU_Sel, A, B)
		begin
			case (ALU_Sel)
				3'b000 : ALU_Result = A + B;
				3'b001 : ALU_Result = A - B;
				3'b010 : ALU_Result = A & B;
				3'b011 : ALU_Result = A | B;
				3'b100 : ALU_Result = A ^ B;
				3'b101 : ALU_Result = A << 1;
				3'b110 : ALU_Result = A >> 1;
				3'b111 : ALU_Result = ~A;
				default : ALU_Result = 8'hXX;
			endcase
		end

	always @ (CCR_Load, ALU_Result)
		begin
			if (ALU_Result == 0)
				CCR_Result = 4'b0000;
			else if (ALU_Result < 0)
				CCR_Result = 4'b1000;
			else
				CCR_Result = 4'b0001;
		end
	
  
endmodule