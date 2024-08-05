`include "data_path.v"
`include "control_unit2.v"

module cpu (
    output reg [7:0] address,
    output reg [7:0] to_memory,
    output reg write,
    input wire [7:0] from_memory,
    input wire clk, reset
);

	wire IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, mem_write;
	wire[7:0] IR_Out, addr, to_mem;
	wire [1:0] Bus1_Sel, Bus2_Sel;
	wire [2:0] ALU_Sel;
	wire [3:0] CCR_Result;

    // Instancia a unidade de controle
    control_unit cu (
		.IR_Load(IR_Load),
		.MAR_Load(MAR_Load),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.A_Load(A_Load),
		.B_Load(B_Load),
		.CCR_Load(CCR_Load),
		.ALU_Sel(ALU_Sel),
		.Bus1_Sel(Bus1_Sel),
		.Bus2_Sel(Bus2_Sel),
		.write(mem_write),
		.IR(IR_Out),
		.CCR_Result(CCR_Result),
		.Clk(clk),
		.Reset(reset)
    );

    // Instancia o caminho de dados
    data_path dp (
		.address(addr),
		.to_memory(to_mem),
		.IR_out(IR_Out),
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
		.Clk(clk),
		.Reset(reset)
    );

	always @ (mem_write or addr or to_mem)
	begin
		write = mem_write;
		address = addr;
		to_memory = to_mem;
	end

endmodule
