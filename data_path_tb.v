`timescale 1ns/1ps
`include "data_path.v"

module data_path_tb;

    reg [7:0] from_memory;
    reg [2:0] ALU_Sel;
    reg [1:0] Bus1_Sel, Bus2_Sel;
    reg IR_Load, MAR_Load, PC_Load, A_Load, B_Load, CCR_Load, PC_Inc, Reset, Clk;
    wire [7:0] address, to_memory, IR_out;
    wire [3:0] CCR_Result;

    data_path uut (
        .address(address),
        .to_memory(to_memory),
        .IR_out(IR_out),
        .CCR_Result(CCR_Result),
        .from_memory(from_memory),
        .ALU_Sel(ALU_Sel),
        .Bus1_Sel(Bus1_Sel),
        .Bus2_Sel(Bus2_Sel),
        .IR_Load(IR_Load),
        .MAR_Load(MAR_Load),
        .PC_Load(PC_Load),
        .A_Load(A_Load),
        .B_Load(B_Load),
        .CCR_Load(CCR_Load),
        .PC_Inc(PC_Inc),
        .Reset(Reset),
        .Clk(Clk)
    );

    initial begin
        // Create dump file for GTKWave
        $dumpfile("data_path_tb.vcd");
        $dumpvars(0, data_path_tb);

        // Initialize all signals
        from_memory = 8'b0;
        ALU_Sel = 3'b0;
        Bus1_Sel = 2'b0;
        Bus2_Sel = 2'b0;
        IR_Load = 0;
        MAR_Load = 0;
        PC_Load = 0;
        A_Load = 0;
        B_Load = 0;
        CCR_Load = 0;
        PC_Inc = 0;
        Reset = 1;
        Clk = 0;

        // Apply reset
        #10 Reset = 0;

        // LDA_IMM - Load A with immediate value 07
        from_memory = 8'h07;
        IR_Load = 1;
        #10 IR_Load = 0;
        A_Load = 1;
        Bus2_Sel = 2'b10;
        #10 A_Load = 0;
        PC_Inc = 1;
        #10 PC_Inc = 0;

        // LDB_IMM - Load B with immediate value 09
        from_memory = 8'h09;
        IR_Load = 1;
        #10 IR_Load = 0;
        B_Load = 1;
        Bus2_Sel = 2'b10;
        #10 B_Load = 0;
        PC_Inc = 1;
        #10 PC_Inc = 0;

        // SUB_AB - Subtract B from A (A = A - B)
        ALU_Sel = 3'b010;
        A_Load = 1;
        Bus1_Sel = 2'b01;
        Bus2_Sel = 2'b10;
        #10 A_Load = 0;
        PC_Inc = 1;
        #10 PC_Inc = 0;

        // STR_DIR - Store the result in a specific address
        MAR_Load = 1;
        from_memory = 8'h80;
        IR_Load = 1;
        #10 MAR_Load = 0;
        IR_Load = 0;
        #10 PC_Inc = 1;
        #10 PC_Inc = 0;

        // Check if the result is zero and branch if equal (BEQ)
        if (CCR_Result[2]) begin
            PC_Load = 1;
            from_memory = 8'h14;
            IR_Load = 1;
            #10 PC_Load = 0;
            IR_Load = 0;
            PC_Inc = 1;
            #10 PC_Inc = 0;
        end

        // Check if the result is negative and branch if minus (BMI)
        else if (CCR_Result[3]) begin
            PC_Load = 1;
            from_memory = 8'h0D;
            IR_Load = 1;
            #10 PC_Load = 0;
            IR_Load = 0;
            PC_Inc = 1;
            #10 PC_Inc = 0;
        end

        // If the result is positive, decrement A (DECA)
        else begin
            ALU_Sel = 3'b011;
            A_Load = 1;
            Bus1_Sel = 2'b01;
            Bus2_Sel = 2'b10;
            #10 A_Load = 0;
            PC_Inc = 1;
            #10 PC_Inc = 0;
        end

        // Loop back to store the decremented value
        MAR_Load = 1;
        from_memory = 8'h05;
        IR_Load = 1;
        #10 MAR_Load = 0;
        IR_Load = 0;

        // If negative, increment A (INCA)
        ALU_Sel = 3'b001;
        A_Load = 1;
        Bus1_Sel = 2'b01;
        Bus2_Sel = 2'b10;
        #10 A_Load = 0;
        PC_Inc = 1;
        #10 PC_Inc = 0;

        // Loop back to store the incremented value
        MAR_Load = 1;
        from_memory = 8'h05;
        IR_Load = 1;
        #10 MAR_Load = 0;
        IR_Load = 0;

        // Load the final value of A from memory
        MAR_Load = 1;
        from_memory = 8'h80;
        IR_Load = 1;
        #10 MAR_Load = 0;
        IR_Load = 0;

        // Store the final value in the output address
        MAR_Load = 1;
        from_memory = 8'hE0;
        IR_Load = 1;
        #10 MAR_Load = 0;
        IR_Load = 0;

        // Loop back to the start of the program
        PC_Load = 1;
        from_memory = 8'h00;
        IR_Load = 1;
        #10 PC_Load = 0;
        IR_Load = 0;

        // Finish simulation
        #1000 $finish;
    end

    // Clock generation
    always begin
        #5 Clk = ~Clk;
    end

endmodule
