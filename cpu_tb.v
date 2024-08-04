`timescale 1ns / 1ps

// Importa o módulo cpu
`include "cpu.v"

module testbench;
    
    // Declaração dos sinais de teste
    reg [7:0] address;
    reg [7:0] to_memory;
    reg write;
    reg clk, reset;
    wire [7:0] addr;
    wire [7:0] to_mem;
    wire wrt;
    wire clock, res;
    wire [7:0] from_memory;
    
    // Instancia o módulo CPU
    cpu uut (
        .address(addr),
        .to_memory(to_mem),
        .write(wrt),
        .from_memory(from_memory),
        .clk(clock),
        .reset(res)
    );
    
    // Clock generator
    always begin
        #5 clk = ~clk; // Gera um clock com período de 10ns (frequência de 100 MHz)
    end
    
    // Inicialização do teste
    initial begin
        // Inicializa sinais
        clk = 0;
        reset = 0;
        address = 8'b0;
        to_memory = 8'b0;
        write = 0;
        
        // Inicializa dump file para GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        
        // Atraso para estabilizar o reset
        #10;
        reset = 1;
        #10;
        reset = 0;
        
        // Teste com comandos básicos
        // Adiciona instruções e dados a partir de agora.
        
        // Exemplo de um ciclo de teste
        address = 8'h00;
        to_memory = 8'hAA; // Exemplo de dado a ser escrito na memória
        write = 1; // Habilita escrita
        #10; // Aguarda 10ns
        write = 0; // Desabilita escrita
        
        // Adicione mais ciclos de teste aqui
        
        // Finaliza a simulação após um tempo
        #100;
        $finish;
    end

    assign addr = address;
    assign to_mem = to_memory;
    assign wrt = write;
    assign clock = clk;
    assign res = reset;
    
endmodule