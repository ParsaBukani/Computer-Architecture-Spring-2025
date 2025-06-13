`timescale 1ns/1ns

module main_controller(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output wire Jump,
    output wire Branch,
    output wire JALRSrc,
    output wire [1:0] ResultSrc,
    output wire MemWrite,
    output wire [2:0] ALUControl,
    output wire ALUSrc,
    output wire [2:0] ImmSrc,
    output wire RegWrite
);

    wire [1:0] AluOp;

    risc_V_controlUnit CU (
        .opcode(opcode),
        .funct3(funct3),    
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .AluOp(AluOp),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .Jump(Jump),
        .JALRSrc(JALRSrc)
    );

    alu_control ALU_CU (
        .ALUOp(AluOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

endmodule
