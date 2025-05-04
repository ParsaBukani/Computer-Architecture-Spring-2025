`timescale 1ns/1ns

module main_controller(
    input wire clk, rst,
    input wire zero,
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output wire [1:0] PCSrc,
    output wire [1:0] ResultSrc,
    output wire MemWrite,
    output wire [2:0] ALUControl,
    output wire ALUSrc,
    output wire [2:0] ImmSrc,
    output wire RegWrite
);

    wire [1:0] AluOp;

    risc_V_controlUnit CU (
        .clk(clk),
        .rst(rst),
        .zero(zero),
        .opcode(opcode),
        .funct3(funct3),    
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .AluOp(AluOp),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

    alu_control ALU_CU (
        .AluOp(AluOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

endmodule
