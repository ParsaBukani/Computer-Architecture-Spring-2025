`timescale 1ns/1ns

module riscv (
    input wire clk,
    input wire rst
);

    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire zero;

    wire [1:0] PCSrc;
    wire [1:0] ResultSrc;
    wire MemWrite;
    wire [2:0] ALUControl;
    wire ALUSrc;
    wire [2:0] ImmSrc;
    wire RegWrite;

    datapath datapath_inst (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .zero(zero)
    );

    main_controller controller_inst (
        .clk(clk),
        .rst(rst),
        .zero(zero),
        .opcode(opcode),
        .funct3(func3),
        .funct7(func7),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

endmodule
