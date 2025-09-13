`timescale 1ns/1ns

module risc_v_processor (
    input wire clk,
    input wire rst
);

    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    wire JumpD, BranchD, JALRSrcD, BranchSrcD;
    wire [1:0] ResultSrcD;
    wire MemWriteD;
    wire [2:0] ALUControlD;
    wire ALUSrcD;
    wire [2:0] ImmSrcD;
    wire RegWriteD;

    wire StallF, StallD, FlushD, FlushE;
    wire [1:0] ForwardAE, ForwardBE;
    wire RegWriteM, RegWriteW;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;
    wire PCSrcE;
    wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    wire ZeroE;

    main_controller ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .Jump(JumpD),
        .Branch(BranchD),
        .JALRSrc(JALRSrcD),
        .BranchSrc(BranchSrcD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD),
        .ImmSrc(ImmSrcD),
        .RegWrite(RegWriteD)
    );

    HazardUnit hazard (
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .ResultSrcM(ResultSrcM),
        .ResultSrcW(ResultSrcW),
        .PCSrcE(PCSrcE),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    risc_v_datapath dp (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .JALRSrcD(JALRSrcD),
        .BranchSrcD(BranchSrcD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .RegWriteD(RegWriteD),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .ResultSrcM(ResultSrcM),
        .ResultSrcW(ResultSrcW),
        .PCSrcE(PCSrcE),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .ZeroE(ZeroE)
    );

endmodule
