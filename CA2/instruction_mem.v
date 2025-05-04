`timescale 1ns/1ns

module instructionMemory #(
    parameter ADDR_WIDTH     = 32,
    parameter MEM_ADDR_BITS  = 6
) (
    input  wire [ADDR_WIDTH-1:0] address,
    output wire [31:0] readData
);

    localparam MEM_DEPTH = 2 ** MEM_ADDR_BITS;

    reg [31:0] RAM[0:MEM_DEPTH-1];

    initial begin
        $readmemh("instruction_memory_testbench.dat", RAM);
    end

    assign readData = RAM[address[MEM_ADDR_BITS+1:2]];

endmodule
