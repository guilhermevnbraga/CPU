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
    wire Press;

parameter S0_FETCH = 0, S1_FETCH = 1, S2_FETCH = 2,
          S3_DECODE = 3,
          
          S4_LDA_IMM = 4, S5_LDA_IMM = 5, S6_LDA_IMM = 6,

          S4_LDA_DIR = 7, S5_LDA_DIR = 8, S6_LDA_DIR = 9, S7_LDA_DIR = 10, S8_LDA_DIR = 11,

          S4_LDB_IMM = 12, S5_LDB_IMM = 13, S6_LDB_IMM = 14,

          S4_LDB_DIR = 15, S5_LDB_DIR = 16, S6_LDB_DIR = 17, S7_LDB_DIR = 18, S8_LDB_DIR = 19,

          S4_STA_DIR = 20, S5_STA_DIR = 21, S6_STA_DIR = 22, S7_STA_DIR = 23,

          S4_STB_DIR = 24, S5_STB_DIR = 25, S6_STB_DIR = 26, S7_STB_DIR = 27,

          S4_STR_DIR = 86, S5_STR_DIR = 87, S6_STR_DIR = 88, S7_STR_DIR = 89,

          S4_ADD_AB = 28, S5_ADD_AB = 29,

          S4_SUB_AB = 30, S5_SUB_AB = 31,

          S4_AND_AB = 32, S5_AND_AB = 33,

          S4_OR_AB = 34, S5_OR_AB = 35,

          S4_INCA = 36, S5_INCA = 37,

          S4_DECA = 38, S5_DECA = 39,

          S4_XOR_AB = 40, S5_XOR_AB = 41,

          S4_NOTA = 42, S5_NOTA = 43,

          S4_INCB = 44, S5_INCB = 45,

          S4_DECB = 46, S5_DECB = 47,

          S4_NOTB = 48, S5_NOTB = 49,

          S4_SUB_BA = 50, S5_SUB_BA = 51,

          S4_BRA = 52, S5_BRA = 53, S6_BRA = 54,

          S4_BMI = 55, S5_BMI = 56, S6_BMI = 57, S7_BMI = 58,

          S4_BPL = 59, S5_BPL = 60, S6_BPL = 61, S7_BPL = 62,

          S4_BEQ = 63, S5_BEQ = 64, S6_BEQ = 65, S7_BEQ = 66,

          S4_BNE = 67, S5_BNE = 68, S6_BNE = 69, S7_BNE = 70,

          S4_BVS = 71, S5_BVS = 72, S6_BVS = 73, S7_BVS = 74,

          S4_BVC = 75, S5_BVC = 76, S6_BVC = 77, S7_BVC = 78,

          S4_BCS = 79, S5_BCS = 80, S6_BCS = 81, S7_BCS = 82,

          S4_BCC = 83, S5_BCC = 84, S6_BCC = 85, S7_BCC = 86;
            
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
    
    always @ (current_state or Press)
        begin: NEXT_STATE_LOGIC
            case (current_state)
                S0_FETCH : next_state = S1_FETCH;
                S1_FETCH : next_state = S2_FETCH;
                S2_FETCH : next_state = S3_DECODE;
                
                S3_DECODE : 
                    case (IR)
                        `LDA_IMM : next_state = S4_LDA_IMM;
                        `LDA_DIR : next_state = S4_LDA_DIR;
                        `LDB_IMM : next_state = S4_LDB_IMM;
                        `LDB_DIR : next_state = S4_LDB_DIR;
                        `STA_DIR : next_state = S4_STA_DIR;
                        `STB_DIR : next_state = S4_STB_DIR;
                        `STR_DIR : next_state = S4_STR_DIR;
                        `ADD_AB  : next_state = S4_ADD_AB;
                        `SUB_AB  : next_state = S4_SUB_AB;
                        `AND_AB  : next_state = S4_AND_AB;
                        `OR_AB   : next_state = S4_OR_AB;
                        `INCA    : next_state = S4_INCA;
                        `DECA    : next_state = S4_DECA;
                        `XOR_AB  : next_state = S4_XOR_AB;
                        `NOTA    : next_state = S4_NOTA;
                        `INCB    : next_state = S4_INCB;    
                        `DECB    : next_state = S4_DECB;
                        `NOTB    : next_state = S4_NOTB;
                        `SUB_BA  : next_state = S4_SUB_BA;
                        `BRA     : next_state = S4_BRA;
                        `BMI     : if (CCR_Result[3] == 1'b1)
                                    next_state = S4_BMI;
                                  else
                                    next_state = S7_BMI;
                        `BPL     : if (CCR_Result[3] == 1'b0)
                                    next_state = S4_BPL;
                                  else
                                  next_state = S7_BPL;
                        `BEQ     : if (CCR_Result[2] == 1'b1)
                                    next_state = S4_BEQ;
                                  else
                                    next_state = S7_BEQ;  
                        `BNE     : if (CCR_Result[2] == 1'b0)
                                    next_state = S4_BNE;
                                  else
                                  next_state = S7_BNE;
                        `BVS     : if (CCR_Result[1] == 1'b1)
                                    next_state = S4_BVS;
                                  else
                                    next_state = S7_BVS;
                        `BVC     : if (CCR_Result[1] == 1'b0)
                                    next_state = S4_BVC;
                                  else
                                    next_state = S7_BVC;
                        `BCS     : if (CCR_Result[0] == 1'b1)
                                    next_state = S4_BCS;
                                  else
                                    next_state = S7_BCS;
                        `BCC     : if (CCR_Result[0] == 1'b0)
                                    next_state = S4_BCC;
                                  else
                                    next_state = S7_BCC;
                        default : next_state = S0_FETCH;
                    endcase
             
                S4_LDA_IMM : next_state = S5_LDA_IMM;
                S5_LDA_IMM : next_state = S6_LDA_IMM;
                S6_LDA_IMM : next_state = S0_FETCH;
                           
                S4_LDA_DIR : next_state = S5_LDA_DIR;
                S5_LDA_DIR : next_state = S6_LDA_DIR;
                S6_LDA_DIR : next_state = S7_LDA_DIR;
                S7_LDA_DIR : next_state = S8_LDA_DIR;
                S8_LDA_DIR : next_state = S0_FETCH;

                S4_LDB_IMM : next_state = S5_LDB_IMM;
                S5_LDB_IMM : next_state = S6_LDB_IMM;
                S6_LDB_IMM : next_state = S0_FETCH;
                           
                S4_LDB_DIR : next_state = S5_LDB_DIR;
                S5_LDB_DIR : next_state = S6_LDB_DIR;
                S6_LDB_DIR : next_state = S7_LDB_DIR;
                S7_LDB_DIR : next_state = S8_LDB_DIR;
                S8_LDB_DIR : next_state = S0_FETCH;
                
                S4_STA_DIR : next_state = S5_STA_DIR;
                S5_STA_DIR : next_state = S6_STA_DIR;
                S6_STA_DIR : next_state = S7_STA_DIR;
                S7_STA_DIR : next_state = S0_FETCH;
            
                S4_STB_DIR : next_state = S5_STB_DIR;
                S5_STB_DIR : next_state = S6_STB_DIR;
                S6_STB_DIR : next_state = S7_STB_DIR;
                S7_STB_DIR : next_state = S0_FETCH;

                S4_STR_DIR : next_state = S5_STR_DIR;
                S5_STR_DIR : next_state = S6_STR_DIR;
                S6_STR_DIR : next_state = S7_STR_DIR;
                S7_STR_DIR : next_state = S0_FETCH;

                S4_ADD_AB : next_state = S0_FETCH;
                S4_SUB_AB : next_state = S0_FETCH;
                S4_AND_AB : next_state = S0_FETCH;
                S4_OR_AB : next_state =  S0_FETCH;
                S4_INCA : next_state =   S0_FETCH;
                S4_DECA : next_state =   S0_FETCH;
                S4_XOR_AB : next_state = S0_FETCH;
                S4_NOTA : next_state =   S0_FETCH;
                S4_INCB : next_state =   S0_FETCH;
                S4_DECB : next_state =   S0_FETCH;
                S4_NOTB : next_state =   S0_FETCH;
                S4_SUB_BA : next_state = S0_FETCH;
                
                S4_BRA    : next_state = S5_BRA;
                S5_BRA    : next_state = S6_BRA;
                S6_BRA    : next_state = S0_FETCH;

                S4_BMI    : next_state = S5_BMI;
                S5_BMI    : next_state = S6_BMI;
                S6_BMI    : next_state = S0_FETCH;
                S7_BMI    : next_state = S0_FETCH;

                S4_BPL    : next_state = S5_BPL;
                S5_BPL    : next_state = S6_BPL;
                S6_BPL    : next_state = S0_FETCH;
                S7_BPL    : next_state = S0_FETCH; 

                S4_BEQ    : next_state = S5_BEQ;
                S5_BEQ    : next_state = S6_BEQ;
                S6_BEQ    : next_state = S0_FETCH;
                S7_BEQ    : next_state = S0_FETCH;

                S4_BNE    : next_state = S5_BNE;
                S5_BNE    : next_state = S6_BNE;
                S6_BNE    : next_state = S0_FETCH;
                S7_BNE    : next_state = S0_FETCH;

                S4_BVS    : next_state = S5_BVS;
                S5_BVS    : next_state = S6_BVS;
                S6_BVS    : next_state = S0_FETCH;
                S7_BVS    : next_state = S0_FETCH;

                S4_BVC    : next_state = S5_BVC;
                S5_BVC    : next_state = S6_BVC;
                S6_BVC    : next_state = S0_FETCH;
                S7_BVC    : next_state = S0_FETCH; 

                S4_BCS    : next_state = S5_BCS;
                S5_BCS    : next_state = S6_BCS;
                S6_BCS    : next_state = S0_FETCH;
                S7_BCS    : next_state = S0_FETCH;

                S4_BCC    : next_state = S5_BCC;
                S5_BCC    : next_state = S6_BCC;
                S6_BCC    : next_state = S0_FETCH;
                S7_BCC    : next_state = S0_FETCH;       

                default : next_state = S0_FETCH;
            endcase
        end
    
    always @ (current_state)
        begin: OUTPUT_LOGIC
            case (current_state)
                S0_FETCH : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S1_FETCH : 
                    begin  
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S2_FETCH :
                    begin 
                        IR_Load = 1;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S3_DECODE : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S4_LDA_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_LDA_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_LDA_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S4_LDA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_LDA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_LDA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S7_LDA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S8_LDA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S4_LDB_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_LDB_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_LDB_IMM : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 1;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S4_LDB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_LDB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_LDB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S7_LDB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S8_LDB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 1;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S4_STA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_STA_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_STA_DIR : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S7_STA_DIR : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b01; 
                        write = 1;
                    end

                S4_STB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                    
                S5_STB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end
                    
                S6_STB_DIR : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end
                    
                S7_STB_DIR : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b10; 
                        Bus2_Sel = 2'b01; 
                        write = 1;
                    end

                S4_STR_DIR :
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b01;
                        write = 0;
                    end
                
                S5_STR_DIR :
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end
                
                S6_STR_DIR :
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b01;
                        write = 0;
                    end
                
                S7_STR_DIR :
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b10;
                        Bus2_Sel = 2'b01;
                        write = 1;
                    end
                    
                S4_ADD_AB : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_SUB_AB : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b010;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_AND_AB : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b100;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_OR_AB : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b101;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_INCA : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b001;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_DECA : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b011; 
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_XOR_AB : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b110;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_NOTA : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 1;
                        B_Load = 0;
                        ALU_Sel = 3'b111;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_INCB :
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 1;
                        ALU_Sel = 3'b001;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end
                
                S4_DECB :
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 1;
                        ALU_Sel = 3'b011;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_NOTB :
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 1;
                        ALU_Sel = 3'b111;
                        CCR_Load = 1;
                        Bus1_Sel = 2'b01;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_BRA : 
                    begin  
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end
                
                S5_BRA : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end                

                S6_BRA : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10; 
                        write = 0;
                    end

                S4_BMI : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end

                S5_BMI : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S6_BMI : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10; 
                        write = 0;
                    end

                S7_BMI : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S4_BPL : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end

                S5_BPL : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S6_BPL : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10; 
                        write = 0;
                    end

                S7_BPL : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S4_BEQ : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end

                S5_BEQ : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S6_BEQ : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b10; 
                        write = 0;
                    end

                S7_BEQ : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S4_BNE : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end

                S5_BNE : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b00; 
                        write = 0;
                    end

                S6_BNE : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S7_BNE : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_BVS : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b01;
                        write = 0;
                    end

                S5_BVS : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S6_BVS : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S7_BVS : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_BVC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00; 
                        Bus2_Sel = 2'b01; 
                        write = 0;
                    end

                S5_BVC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S6_BVC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S7_BVC : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_BCS : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b01;
                        write = 0;
                    end

                S5_BCS : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S6_BCS : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S7_BCS : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S4_BCC : 
                    begin
                        IR_Load = 0;
                        MAR_Load = 1;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b01;
                        write = 0;
                    end

                S5_BCC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end

                S6_BCC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 1;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b10;
                        write = 0;
                    end

                S7_BCC : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 1;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000; 
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end


                default : 
                    begin 
                        IR_Load = 0;
                        MAR_Load = 0;
                        PC_Load = 0;
                        PC_Inc = 0;
                        A_Load = 0;
                        B_Load = 0;
                        ALU_Sel = 3'b000;
                        CCR_Load = 0;
                        Bus1_Sel = 2'b00;
                        Bus2_Sel = 2'b00;
                        write = 0;
                    end
            endcase
        end
endmodule