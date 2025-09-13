`timescale 1ns/1ns

module risc_v_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5,
    parameter MEM_SIZE = 32
) (
    input wire clk,
    input wire mem_write,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    initial begin
        $readmemb("data.mem", mem);
    end

    always @(posedge clk) begin
       if (mem_write) begin
            mem[addr] <= data_in;
        end
    end

    assign data_out = mem[addr];

endmodule
