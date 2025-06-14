`timescale 1ns/1ns

module ID_EX_reg (
    input wire clk,
    input wire rst,
    input wire FlushE,    
    input wire [1:0] ResultSrcD,
    input wire MemWriteD,
    input wire [2:0] ALUControlD,
    input wire ALUSrcD,
    input wire [31:0] PCPlus4D,
    input wire RegWriteD,
    input wire JumpD,
    input wire BranchD,
    input wire JALRSrcD,
    input wire BranchSrcD,
    input wire [31:0] PCD,
    input wire [31:0] RD1D,     
    input wire [31:0] RD2D,    
    input wire [31:0] ExtImmD,
    input wire [4:0] Rs1D,
    input wire [4:0] Rs2D,
    input wire [4:0] RdD,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,
    output reg [31:0] PCPlus4E,
    output reg RegWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg JALRSrcE,
    output reg BranchSrcE,
    output reg [31:0] PCE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] ExtImmE,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE
);

    always @(posedge clk) begin
        if (rst || FlushE) begin
            ResultSrcE <= 0;
            MemWriteE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;
            PCPlus4E <= 0;
            RegWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            JALRSrcE <= 0;
            BranchSrcE <= 0;
            PCE <= 0;
            RD1E <= 0;
            RD2E <= 0;
            ExtImmE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
        end
        else begin
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            PCPlus4E <= PCPlus4D;
            RegWriteE <= RegWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            JALRSrcE <= JALRSrcD;
            BranchSrcE <= BranchSrcD;
            PCE <= PCD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            ExtImmE <= ExtImmD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
        end
    end

endmodule