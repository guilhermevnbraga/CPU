`include "instructions.v"

module control_unit 
	(output reg IR_Load, 
	 output reg MAR_Load, 
	 output reg PC_Load, PC_Inc, 
	 output reg A_Load, B_Load,
	 output reg CCR_Load,
	 output reg [2:0] ALU_Sel,
	 output reg [1:0] Bus1_Sel, Bus2_Sel,
	 output reg write, 
	 input wire [7:0] IR, 
	 input wire [3:0] CCR_Result,
     input wire Clk, Reset);
             
  	reg [7:0] current_state, next_state;

  	parameter S0_FETCH = 0,
          S1_FETCH = 1,
          S2_FETCH = 2,
          S3_DECODE = 3,
          
          S4_LDA_IMM = 4, S5_LDA_IMM = 5, S6_LDA_IMM = 6,
          S4_LDA_DIR = 7, S5_LDA_DIR = 8, S6_LDA_DIR = 9, S7_LDA_DIR = 10, S8_LDA_DIR = 11,
          
          S4_LDB_IMM = 12, S5_LDB_IMM = 13, S6_LDB_IMM = 14,
          S4_LDB_DIR = 15, S5_LDB_DIR = 16, S6_LDB_DIR = 17, S7_LDB_DIR = 18, S8_LDB_DIR = 19,
          
          S4_STA_DIR = 20, S5_STA_DIR = 21, S6_STA_DIR = 22, S7_STA_DIR = 71, S8_STA_DIR = 72,
          S4_STB_DIR = 23, S5_STB_DIR = 24, S6_STB_DIR = 25, S7_STB_DIR = 73, S8_STB_DIR = 74,
          S4_STR_DIR = 26, S5_STR_DIR = 27, S6_STR_DIR = 28, S7_STR_DIR = 75, S8_STR_DIR = 76,
          
          S4_ADD_AB = 29, S5_ADD_AB = 30,
          S4_SUB_AB = 31, S5_SUB_AB = 32,
          S4_AND_AB = 33, S5_AND_AB = 34,
          S4_OR_AB  = 35, S5_OR_AB  = 36,
          S4_INCA   = 37, S5_INCA   = 38,
          S4_DECA   = 39, S5_DECA   = 40,
          S4_XOR_AB = 41, S5_XOR_AB = 42,
          S4_NOTA   = 43, S5_NOTA   = 44,
          S4_INCB   = 45, S5_INCB   = 46,
          S4_DECB   = 47, S5_DECB   = 48,
          S4_NOTB   = 49, S5_NOTB   = 50,
          S4_SUB_BA = 51, S5_SUB_BA = 52,
          
          S4_BRA    = 53, S5_BRA    = 54,
          S4_BMI    = 55, S5_BMI    = 56,
          S4_BPL    = 57, S5_BPL    = 58,
          S4_BEQ    = 59, S5_BEQ    = 60,
          S4_BNE    = 61, S5_BNE    = 62,
          S4_BVS    = 63, S5_BVS    = 64,
          S4_BVC    = 65, S5_BVC    = 66,
          S4_BCS    = 67, S5_BCS    = 68,
          S4_BCC    = 69, S5_BCC    = 70;
            
  	initial
  		begin
    		current_state = S0_FETCH;
    		next_state = S0_FETCH;
    		IR_Load = 0;
    		MAR_Load = 1;
    		PC_Load = 0;
    		PC_Inc = 0;
    		A_Load = 0;
    		B_Load = 0;
    		CCR_Load = 0;
    		ALU_Sel = 3'b000;
    		Bus1_Sel = 2'b00;
    		Bus2_Sel = 2'b01;
    		write = 0;
    	end          
  
  	always @ (posedge Clk or negedge Reset)
  		begin: STATE_MEMORY
  			if (!Reset)
  				current_state <= S0_FETCH;
  			else
  				current_state <= next_state;
  		end
  	
  	always @ (current_state or IR)
		begin: NEXT_STATE_LOGIC
			case (current_state)
				S0_FETCH: next_state = S1_FETCH;
				S1_FETCH: next_state = S2_FETCH;
				S2_FETCH: next_state = S3_DECODE;
				
				S3_DECODE:
					case (IR)
						`LDA_IMM: next_state = S4_LDA_IMM;
						`LDA_DIR: next_state = S4_LDA_DIR;
						`LDB_IMM: next_state = S4_LDB_IMM;
						`LDB_DIR: next_state = S4_LDB_DIR;
						`STA_DIR: next_state = S4_STA_DIR;
						`STB_DIR: next_state = S4_STB_DIR;
						`STR_DIR: next_state = S4_STR_DIR;
						`ADD_AB: next_state = S4_ADD_AB;
						`SUB_AB: next_state = S4_SUB_AB;
						`AND_AB: next_state = S4_AND_AB;
						`OR_AB: next_state = S4_OR_AB;
						`INCA: next_state = S4_INCA;
						`DECA: next_state = S4_DECA;
						`XOR_AB: next_state = S4_XOR_AB;
						`NOTA: next_state = S4_NOTA;
						`INCB: next_state = S4_INCB;
						`DECB: next_state = S4_DECB;
						`NOTB: next_state = S4_NOTB;
						`SUB_BA: next_state = S4_SUB_BA;
						`BRA: next_state = S4_BRA;
						`BMI: next_state = S4_BMI;
						`BPL: next_state = S4_BPL;
						`BEQ: next_state = S4_BEQ;
						`BNE: next_state = S4_BNE;
						`BVS: next_state = S4_BVS;
						`BVC: next_state = S4_BVC;
						`BCS: next_state = S4_BCS;
						`BCC: next_state = S4_BCC;
						default: next_state = S3_DECODE;
					endcase

				S4_LDA_IMM: next_state = S5_LDA_IMM;
				S5_LDA_IMM: next_state = S6_LDA_IMM;
				S6_LDA_IMM: next_state = S0_FETCH;

				S4_LDA_DIR: next_state = S5_LDA_DIR;
				S5_LDA_DIR: next_state = S6_LDA_DIR;
				S6_LDA_DIR: next_state = S7_LDA_DIR;
				S7_LDA_DIR: next_state = S8_LDA_DIR;
				S8_LDA_DIR: next_state = S0_FETCH;

				S4_LDB_IMM: next_state = S5_LDB_IMM;
				S5_LDB_IMM: next_state = S6_LDB_IMM;
				S6_LDB_IMM: next_state = S0_FETCH;

				S4_LDB_DIR: next_state = S5_LDB_DIR;
				S5_LDB_DIR: next_state = S6_LDB_DIR;
				S6_LDB_DIR: next_state = S7_LDB_DIR;
				S7_LDB_DIR: next_state = S8_LDB_DIR;
				S8_LDB_DIR: next_state = S0_FETCH;

				S4_STA_DIR: next_state = S5_STA_DIR;
				S5_STA_DIR: next_state = S6_STA_DIR;
				S6_STA_DIR: next_state = S7_STA_DIR;
				S7_STA_DIR: next_state = S8_STA_DIR;
				S8_STA_DIR: next_state = S0_FETCH;

				S4_STB_DIR: next_state = S5_STB_DIR;
				S5_STB_DIR: next_state = S6_STB_DIR;
				S6_STB_DIR: next_state = S7_STB_DIR;
				S7_STB_DIR: next_state = S8_STB_DIR;
				S8_STB_DIR: next_state = S0_FETCH;

				S4_STR_DIR: next_state = S5_STR_DIR;
				S5_STR_DIR: next_state = S6_STR_DIR;
				S6_STR_DIR: next_state = S7_STR_DIR;
				S7_STR_DIR: next_state = S8_STR_DIR;
				S8_STR_DIR: next_state = S0_FETCH;

				S4_ADD_AB: next_state = S5_ADD_AB;
				S5_ADD_AB: next_state = S0_FETCH;

				S4_SUB_AB: next_state = S5_SUB_AB;
				S5_SUB_AB: next_state = S0_FETCH;

				S4_AND_AB: next_state = S5_AND_AB;
				S5_AND_AB: next_state = S0_FETCH;

				S4_OR_AB: next_state = S5_OR_AB;
				S5_OR_AB: next_state = S0_FETCH;

				S4_INCA: next_state = S5_INCA;
				S5_INCA: next_state = S0_FETCH;

				S4_DECA: next_state = S5_DECA;
				S5_DECA: next_state = S0_FETCH;

				S4_XOR_AB: next_state = S5_XOR_AB;
				S5_XOR_AB: next_state = S0_FETCH;

				S4_NOTA: next_state = S5_NOTA;
				S5_NOTA: next_state = S0_FETCH;

				S4_INCB: next_state = S5_INCB;
				S5_INCB: next_state = S0_FETCH;

				S4_DECB: next_state = S5_DECB;
				S5_DECB: next_state = S0_FETCH;

				S4_NOTB: next_state = S5_NOTB;
				S5_NOTB: next_state = S0_FETCH;

				S4_SUB_BA: next_state = S5_SUB_BA;
				S5_SUB_BA: next_state = S0_FETCH;

				S4_BRA: next_state = S5_BRA;
				S5_BRA: next_state = S0_FETCH;

				S4_BMI: next_state = S5_BMI;
				S5_BMI: next_state = S0_FETCH;

				S4_BPL: next_state = S5_BPL;
				S5_BPL: next_state = S0_FETCH;

				S4_BEQ: next_state = S5_BEQ;
				S5_BEQ: next_state = S0_FETCH;

				S4_BNE: next_state = S5_BNE;
				S5_BNE: next_state = S0_FETCH;

				S4_BVS: next_state = S5_BVS;
				S5_BVS: next_state = S0_FETCH;

				S4_BVC: next_state = S5_BVC;
				S5_BVC: next_state = S0_FETCH;

				S4_BCS: next_state = S5_BCS;
				S5_BCS: next_state = S0_FETCH;

				S4_BCC: next_state = S5_BCC;
				S5_BCC: next_state = S0_FETCH;

				default: next_state = S0_FETCH;
			endcase
		end
  	
  	always @ (current_state)
		begin: OUTPUT_LOGIC
			case (current_state)
				S0_FETCH:
					begin
						IR_Load = 0;
						MAR_Load = 1;
						PC_Load = 0;
						PC_Inc = 0;
						A_Load = 0;
						B_Load = 0;
						CCR_Load = 0;
						ALU_Sel = 3'b000;
						Bus1_Sel = 2'b00;
						Bus2_Sel = 2'b01;
						write = 0;
					end

				S1_FETCH:
					begin
						IR_Load = 0;
						MAR_Load = 0;
						PC_Load = 0;
						PC_Inc = 1;
						A_Load = 0;
						B_Load = 0;
						CCR_Load = 0;
						ALU_Sel = 3'b000;
						Bus1_Sel = 2'b00;
						Bus2_Sel = 2'b01;
						write = 0;
					end

				S2_FETCH:
					begin
						IR_Load = 1;
						MAR_Load = 0;
						PC_Load = 0;
						PC_Inc = 0;
						A_Load = 0;
						B_Load = 0;
						CCR_Load = 0;
						ALU_Sel = 3'b000;
						Bus1_Sel = 2'b00;
						Bus2_Sel = 2'b01;
						write = 0;
					end

				S3_DECODE:
					begin
						IR_Load = 0;
						MAR_Load = 0;
						PC_Load = 0;
						PC_Inc = 0;
						A_Load = 0;
						B_Load = 0;
						CCR_Load = 0;
						ALU_Sel = 3'b000;
						Bus1_Sel = 2'b00;
						Bus2_Sel = 2'b01;
						write = 0;
					end

				// Saída para LDA_IMM
				S4_LDA_IMM:
					begin
						MAR_Load = 1;
					end
				S5_LDA_IMM:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_LDA_IMM:
					begin
						A_Load = 1;
						PC_Inc = 1;
					end

				// Saída para LDA_DIR
				S4_LDA_DIR:
					begin
						MAR_Load = 1;
					end
				S5_LDA_DIR:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_LDA_DIR:
					begin
						MAR_Load = 1;
					end
				S7_LDA_DIR:
					begin
						MAR_Load = 0;
					end
				S8_LDA_DIR:
					begin
						A_Load = 1;
						PC_Inc = 1;
					end

				// Saída para LDB_IMM
				S4_LDB_IMM:
					begin
						MAR_Load = 1;
					end
				S5_LDB_IMM:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_LDB_IMM:
					begin
						B_Load = 1;
						PC_Inc = 1;
					end

				// Saída para LDB_DIR
				S4_LDB_DIR:
					begin
						MAR_Load = 1;
					end
				S5_LDB_DIR:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_LDB_DIR:
					begin
						MAR_Load = 1;
					end
				S7_LDB_DIR:
					begin
						MAR_Load = 0;
					end
				S8_LDB_DIR:
					begin
						B_Load = 1;
						PC_Inc = 1;
					end

				// Saída para STA_DIR
				S4_STA_DIR:
					begin
						MAR_Load = 1;
					end
				S5_STA_DIR:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_STA_DIR:
					begin
						MAR_Load = 1;
					end
				S7_STA_DIR:
					begin
						MAR_Load = 0;
						Bus1_Sel = 2'b01;
						write = 1;
					end
				S8_STA_DIR:
					begin
						write = 0;
						PC_Inc = 1;
					end

				// Saída para STB_DIR
				S4_STB_DIR:
					begin
						MAR_Load = 1;
					end
				S5_STB_DIR:
					begin
						MAR_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_STB_DIR:
					begin
						MAR_Load = 1;
					end
				S7_STB_DIR:
					begin
						MAR_Load = 0;
						Bus1_Sel = 2'b10;
						write = 1;
					end
				S8_STB_DIR:
					begin
						write = 0;
						PC_Inc = 1;
					end

				// Saída para STR_DIR
				S4_STR_DIR:
					begin
						Bus2_Sel = 2'b01;
						MAR_Load = 1;
						A_Load = 1;
					end
				S5_STR_DIR:
					begin
						MAR_Load = 0;
						A_Load = 0;
						Bus2_Sel = 2'b10;
					end
				S6_STR_DIR:
					begin
						MAR_Load = 1;
					end
				S7_STR_DIR:
					begin
						MAR_Load = 0;
						Bus1_Sel = 2'b01;
						write = 1;
					end
				S8_STR_DIR:
					begin
						write = 0;
						PC_Inc = 1;
					end

				// Saída para ADD_AB
				S4_ADD_AB:
					begin
						ALU_Sel = 3'b000;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_ADD_AB:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para SUB_AB
				S4_SUB_AB:
					begin
						ALU_Sel = 3'b010;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_SUB_AB:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para AND_AB
				S4_AND_AB:
					begin
						ALU_Sel = 3'b100;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_AND_AB:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para OR_AB
				S4_OR_AB:
					begin
						ALU_Sel = 3'b101;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_OR_AB:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para INCA
				S4_INCA:
					begin
						ALU_Sel = 3'b001;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_INCA:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para DECA
				S4_DECA:
					begin
						ALU_Sel = 3'b011;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_DECA:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para XOR_AB
				S4_XOR_AB:
					begin
						ALU_Sel = 3'b110;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_XOR_AB:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para NOTA
				S4_NOTA:
					begin
						ALU_Sel = 3'b111;
						Bus2_Sel = 2'b00;
						A_Load = 1;
					end
				S5_NOTA:
					begin
						A_Load = 0;
						PC_Inc = 1;
					end

				// Saída para INCB
				S4_INCB:
					begin
						ALU_Sel = 3'b110;
						B_Load = 1;
					end
				S5_INCB:
					begin
						B_Load = 0;
						PC_Inc = 1;
					end

				// Saída para DECB
				S4_DECB:
					begin
						ALU_Sel = 3'b111;
						B_Load = 1;
					end
				S5_DECB:
					begin
						B_Load = 0;
						PC_Inc = 1;
					end

				// Saída para NOTB
				S4_NOTB:
					begin
						ALU_Sel = 3'b001;
						B_Load = 1;
					end
				S5_NOTB:
					begin
						B_Load = 0;
						PC_Inc = 1;
					end

				// Saída para SUB_BA
				S4_SUB_BA:
					begin
						ALU_Sel = 3'b011;
						B_Load = 1;
					end
				S5_SUB_BA:
					begin
						B_Load = 0;
						PC_Inc = 1;
					end

				// Saída para BRA
				S4_BRA:
					begin
						MAR_Load = 1;
						PC_Load = 1;
					end
				S5_BRA:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BMI
				S4_BMI:
					begin
						if (CCR_Result[2])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BMI:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BPL
				S4_BPL:
					begin
						if (!CCR_Result[2])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BPL:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BEQ
				S4_BEQ:
					begin
						if (CCR_Result[1])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BEQ:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BNE
				S4_BNE:
					begin
						if (!CCR_Result[1])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BNE:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BVS
				S4_BVS:
					begin
						if (CCR_Result[3])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BVS:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BVC
				S4_BVC:
					begin
						if (!CCR_Result[3])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BVC:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BCS
				S4_BCS:
					begin
						if (CCR_Result[0])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BCS:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				// Saída para BCC
				S4_BCC:
					begin
						if (!CCR_Result[0])
							MAR_Load = 1;
							PC_Load = 1;
					end
				S5_BCC:
					begin
						MAR_Load = 0;
						PC_Load = 0;
					end

				default:
					begin
						IR_Load = 0;
						MAR_Load = 0;
						PC_Load = 0;
						PC_Inc = 0;
						A_Load = 0;
						B_Load = 0;
						CCR_Load = 0;
						ALU_Sel = 3'b000;
						Bus1_Sel = 2'b00;
						Bus2_Sel = 2'b01;
						write = 0;
					end
			endcase
		end
  			   				
  
endmodule