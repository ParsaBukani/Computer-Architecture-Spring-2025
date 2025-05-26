`timescale 1ns/1ns

module risc_v_memory #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter MEM_SIZE = 32,
    parameter INIT_FILE = "memory.mem"
) (
    input wire clk,
    input wire mem_write,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    initial begin
        $readmemb(INIT_FILE, mem);
    end

    always @(posedge clk) begin
        if (mem_write)
            mem[addr] <= data_in;
    end

    assign data_out = mem[addr];

endmodule

