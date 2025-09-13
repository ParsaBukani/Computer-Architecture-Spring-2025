`timescale 1ns/1ns

module EX_MEM_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] ResultSrcE,
    input wire MemWriteE,
    input wire RegWriteE,
    input wire [31:0] ALUResultE,
    input wire [31:0] WriteDataE, 
    input wire [4:0] RdE,
    input wire [31:0] ExtImmE,
    input wire [31:0] PCPlus4E,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,
    output reg RegWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] ExtImmM,
    output reg [31:0] PCPlus4M
);

    always @(posedge clk) begin
        if (rst) begin
            ResultSrcM <= 0;
            MemWriteM <= 0;
            RegWriteM <= 0;
            ALUResultM <= 0;
            WriteDataM <= 0;
            RdM <= 0;
            ExtImmM <= 0;
            PCPlus4M <= 0;
        end
        else begin
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
            RegWriteM <= RegWriteE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            ExtImmM <= ExtImmE;
            PCPlus4M <= PCPlus4E;
        end
    end

endmodule
