`timescale 1ns/1ns

module MEM_WB_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] ResultSrcM,
    input wire RegWriteM,
    input wire [31:0] ReadDataM,
    input wire [31:0] ALUResultM,
    input wire [4:0] RdM,
    input wire [31:0] ExtImmM,
    input wire [31:0] PCPlus4M,
    output reg [1:0] ResultSrcW,
    output reg RegWriteW,
    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [4:0] RdW,
    output reg [31:0] ExtImmW,
    output reg [31:0] PCPlus4W
);

    always @(posedge clk) begin
        if (rst) begin
            ResultSrcW <= 0;
            RegWriteW <= 0;
            ReadDataW <= 0;
            ALUResultW <= 0;
            RdW <= 0;
            ExtImmW <= 0;
            PCPlus4W <= 0;
        end
        else begin
            ResultSrcW <= ResultSrcM;
            RegWriteW <= RegWriteM;
            ReadDataW <= ReadDataM;
            ALUResultW <= ALUResultM;
            RdW <= RdM;
            ExtImmW <= ExtImmM;
            PCPlus4W <= PCPlus4M;
        end
    end

endmodule
