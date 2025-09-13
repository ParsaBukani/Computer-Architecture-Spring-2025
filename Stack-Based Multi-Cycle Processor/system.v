`timescale 1ns/1ns

module system (
    input wire clk,
    input wire rst
);
    wire PCWrite, PCJZ, AdrSrc, MemWrite, IRWrite, DataSelect;
    wire push, pop, tos, AWrite, ALUSrcA, ALUSrcB, PCSrc;
    wire [1:0] ALUControl;
    wire [2:0] opcode;

    datapath dp (
        .clk(clk),
        .rst(rst),
        .PCWrite(PCWrite),
        .PCJZ(PCJZ),
        .AdrSrc(AdrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .DataSelect(DataSelect),
        .push(push),
        .pop(pop),
        .tos(tos),
        .AWrite(AWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc),
        .opcode(opcode)
    );

    controller ctrl (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .PCWrite(PCWrite),
        .PCJZ(PCJZ),
        .AdrSrc(AdrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .DataSelect(DataSelect),
        .push(push),
        .pop(pop),
        .tos(tos),
        .AWrite(AWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc)
    );

endmodule
