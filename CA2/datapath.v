`timescale 1ns/1ns

module datapath (
    input clk,
    input rst, 
    input wire [1:0] PCSrc,
    input wire [1:0] ResultSrc,
    input wire MemWrite,
    input wire [2:0] ALUControl,
    input wire ALUSrc,
    input wire [2:0] ImmSrc,
    input wire RegWrite,
    output wire [6:0] opcode,
    output wire [2:0] func3,
    output wire [6:0] func7,
    output wire zero
);

    wire [31:0] pc_current, pc_next, pc_plus4, pc_target;
    wire [31:0] instruction;
    wire [31:0] reg_data1, reg_data2, write_data;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm_ext, alu_srcB, alu_result;
    wire [31:0] mem_data;

    risc_v_pc pc_reg (
        .clk(clk),
        .reset(rst),
        .next_pc(pc_next),
        .pc(pc_current)
    );

    instructionMemory imem (
        .address(pc_current),
        .readData(instruction)
    );

    assign opcode    = instruction[6:0];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];
    assign rs1   = instruction[19:15];
    assign rs2   = instruction[24:20];
    assign rd    = instruction[11:7];

    risc_v_regfile regfile (
        .clk(clk),
        .rst(rst),
        .reg_write(RegWrite),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .write_addr(rd),
        .write_data(write_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    ImmExtend imm_gen (
        .sl(ImmSrc),
        .immData(instruction[31:7]),
        .ImmOut(imm_ext)
    );

    mux_2to1 #(32) alu_b_mux (
        .data0(reg_data2),
        .data1(imm_ext),
        .sel(ALUSrc),
        .out(alu_srcB)
    );

    ALU alu (
        .sl(ALUControl),
        .Ain(reg_data1),
        .Bin(alu_srcB),
        .AluOut(alu_result),
        .Zero(zero)
    );

    risc_v_memory dmem (
        .clk(clk),
        .mem_write(MemWrite),
        .addr(alu_result[6:2]),
        .data_in(reg_data2),
        .data_out(mem_data)
    );

    mux_4to1 #(32) result_mux (
        .data0(alu_result),
        .data1(mem_data),
        .data2(pc_plus4),
        .data3(imm_ext),
        .sel(ResultSrc),
        .out(write_data)
    );

    adder pc_inc (
        .a(pc_current),
        .b(32'd4),
        .sum(pc_plus4)
    );

    adder pc_target_add (
        .a(pc_current),
        .b(imm_ext),
        .sum(pc_target)
    );

    mux_3to1 #(32) pc_mux (
        .data0(pc_plus4),
        .data1(pc_target),
        .data2(alu_result),
        .sel(PCSrc),
        .out(pc_next)
    );

endmodule
