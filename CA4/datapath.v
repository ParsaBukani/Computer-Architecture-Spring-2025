`timescale 1ns/1ns

module risc_v_datapath (
    input wire clk,
    input wire rst,

    // Control Signals
    output wire [6:0] opcode,
    output wire [2:0] funct3,
    output wire [6:0] funct7,
    input wire JumpD,
    input wire BranchD,
    input wire JALRSrcD,
    input wire BranchSrcD,
    input wire [1:0] ResultSrcD,
    input wire MemWriteD,
    input wire [2:0] ALUControlD,
    input wire ALUSrcD,
    input wire [2:0] ImmSrcD,
    input wire RegWriteD,

    // Hazard Unit Signals
    input wire StallF,
    input wire StallD,
    input wire FlushD,
    input wire FlushE,
    input wire [1:0] ForwardAE,
    input wire [1:0] ForwardBE,
    output wire RegWriteM,
    output wire RegWriteW,
    output wire [1:0] ResultSrcE,
    output wire [1:0] ResultSrcM,
    output wire [1:0] ResultSrcW,
    output wire PCSrcE,
    output wire [4:0] Rs1D,
    output wire [4:0] Rs2D,
    output wire [4:0] Rs1E,
    output wire [4:0] Rs2E,
    output wire [4:0] RdE,
    output wire [4:0] RdM,
    output wire [4:0] RdW,

    output wire ZeroE
);

    // Fetch Stage
    wire [31:0] PCF, PCPlus4F, InstrF, NextPCF;

    risc_v_pc pc (
        .clk(clk),
        .reset(rst),
        .en(~StallF),
        .next_pc(NextPCF),
        .pc(PCF)
    );

    adder pc_adder (
        .a(PCF),
        .b(32'd4),
        .sum(PCPlus4F)
    );

    instructionMemory imem (
        .address(PCF),
        .readData(InstrF)
    );

    wire [31:0] PCD, InstrD, PCPlus4D;

    IF_ID_reg if_id (
        .clk(clk),
        .rst(rst),
        .ld(~StallD),
        .flush(FlushD),
        .PCF(PCF),
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCD(PCD),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    // Decode Stage
    wire [31:0] RD1D, RD2D, ExtImmD, ResultW;
    wire [4:0] RdD;

    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    assign opcode = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[31:25];

    risc_v_regfile regfile (
        .clk(clk),
        .rst(rst),
        .reg_write(RegWriteW),
        .read_addr1(Rs1D),
        .read_addr2(Rs2D),
        .write_addr(RdW),
        .write_data(ResultW),
        .read_data1(RD1D),
        .read_data2(RD2D)
    );

    ImmExtend imm_extend (
        .sl(ImmSrcD),
        .immData(InstrD[31:7]),
        .ImmOut(ExtImmD)
    );

    wire [31:0] RD1E, RD2E, ExtImmE, PCPlus4E, PCE;
    wire [2:0] ALUControlE;
    wire BranchSrcE, JumpE;

    ID_EX_reg id_ex (
        .clk(clk),
        .rst(rst),
        .FlushE(FlushE),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .PCPlus4D(PCPlus4D),
        .RegWriteD(RegWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .JALRSrcD(JALRSrcD),
        .BranchSrcD(BranchSrcD),
        .PCD(PCD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .ExtImmD(ExtImmD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .PCPlus4E(PCPlus4E),
        .RegWriteE(RegWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .JALRSrcE(JALRSrcE),
        .BranchSrcE(BranchSrcE),
        .PCE(PCE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .ExtImmE(ExtImmE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE)
    );

    // Execute Stage
    wire [31:0] SrcAE, WriteDataE, SrcBE, ALUResultE, ALUResultM, PCTargetE, ExtImmM;
    wire BranchType;

    mux_4to1 forward_a_mux (
        .data0(RD1E),
        .data1(ResultW),
        .data2(ALUResultM),
        .data3(ExtImmM),
        .sel(ForwardAE),
        .out(SrcAE)
    );

    mux_4to1 forward_b_mux (
        .data0(RD2E),
        .data1(ResultW),
        .data2(ALUResultM),
        .data3(ExtImmM),
        .sel(ForwardBE),
        .out(WriteDataE)
    );

    mux_2to1 alusrc_mux (
        .data0(WriteDataE),
        .data1(ExtImmE),
        .sel(ALUSrcE),
        .out(SrcBE)
    );

    ALU alu (
        .sl(ALUControlE),
        .Ain(SrcAE),
        .Bin(SrcBE),
        .AluOut(ALUResultE),
        .Zero(ZeroE)
    );

    wire [31:0] JALRTargetE;
    mux_2to1 jalr_mux (
        .data0(PCE),
        .data1(SrcAE), // change
        .sel(JALRSrcE),
        .out(JALRTargetE)
    );

    adder pc_target_adder (
        .a(JALRTargetE),
        .b(ExtImmE),
        .sum(PCTargetE)
    );

    assign BranchType = BranchSrcE ? ~ZeroE : ZeroE;
    assign PCSrcE = JumpE || (BranchE && BranchType);

    wire [31:0] WriteDataM, PCPlus4M;
    wire MemWriteM;

    EX_MEM_reg ex_mem (
        .clk(clk),
        .rst(rst),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .RegWriteE(RegWriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .ExtImmE(ExtImmE),
        .PCPlus4E(PCPlus4E),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .ExtImmM(ExtImmM),
        .PCPlus4M(PCPlus4M)
    );

    // Memory Stage
    wire [31:0] ReadDataM;

    risc_v_memory dmem (
        .clk(clk),
        .mem_write(MemWriteM),
        .addr(ALUResultM[6:2]),
        .data_in(WriteDataM),
        .data_out(ReadDataM)
    );

    wire [31:0] ReadDataW, ALUResultW, ExtImmW, PCPlus4W;

    MEM_WB_reg mem_wb (
        .clk(clk),
        .rst(rst),
        .ResultSrcM(ResultSrcM),
        .RegWriteM(RegWriteM),
        .ReadDataM(ReadDataM),
        .ALUResultM(ALUResultM),
        .RdM(RdM),
        .ExtImmM(ExtImmM),
        .PCPlus4M(PCPlus4M),
        .ResultSrcW(ResultSrcW),
        .RegWriteW(RegWriteW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .RdW(RdW),
        .ExtImmW(ExtImmW),
        .PCPlus4W(PCPlus4W)
    );

    // Writeback Stage
    mux_4to1 result_mux (
        .data0(ALUResultW),
        .data1(ReadDataW),
        .data2(PCPlus4W),
        .data3(ExtImmW),
        .sel(ResultSrcW),
        .out(ResultW)
    );

    mux_2to1 pc_mux (
        .data0(PCPlus4F),
        .data1(PCTargetE),
        .sel(PCSrcE),
        .out(NextPCF)
    );

endmodule
