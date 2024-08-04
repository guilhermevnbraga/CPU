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

        // Load IR, PC, A, B
        from_memory = 8'h45;
        Bus2_Sel = 2'b10;
        #20 IR_Load = 1;
        #10 IR_Load = 0;
        from_memory = 8'hE8;
        #20 PC_Load = 1;
        #10 PC_Load = 0;
        from_memory = 8'h18;
        #20 A_Load = 1;
        #10 A_Load = 0;
        from_memory = 8'hBB;
        #20 B_Load = 1;
        #10 B_Load = 0;

        // PC, A or B to memory
        #20 Bus1_Sel = 01;
        #30 Bus1_Sel = 10;

        // ALU operations
        #30 ALU_Sel = 3'b000; // A + B
        CCR_Load = 1;
        #10 CCR_Load = 0;
        #30 ALU_Sel = 3'b010; // A - B
        CCR_Load = 1;
        #10 CCR_Load = 0;
        #30 ALU_Sel = 3'b111; // ~A
        CCR_Load = 1;
        #10 CCR_Load = 0;

        // Send Alu Result to address
        Bus2_Sel = 2'b00;
        MAR_Load = 1;
        #10 MAR_Load = 0;

        // Finish simulation
        #1000 $finish;
    end

    // Clock generation
    always begin
        #5 Clk = ~Clk;
    end

endmodule
