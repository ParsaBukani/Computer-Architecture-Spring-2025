`timescale 1ns/1ns

module risc_v_regfile # (
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
) (
    input clk,
    input wire reg_write,                     
    input wire [ADDR_WIDTH-1:0] read_addr1,   
    input wire [ADDR_WIDTH-1:0] read_addr2,   
    input wire [ADDR_WIDTH-1:0] write_addr,  
    input wire [DATA_WIDTH-1:0] write_data,   
    output reg [DATA_WIDTH-1:0] read_data1,
    output reg [DATA_WIDTH-1:0] read_data2
);

    reg [DATA_WIDTH-1:0] registers [0:31];

    initial begin
        registers[0] = 32'b0;
    end

    always @(posedge clk) begin
        if (reg_write && write_addr != 5'b0) begin
            registers[write_addr] <= write_data;
        end

        read_data1 <= registers[read_addr1];
        read_data2 <= registers[read_addr2];

    end

endmodule
