`timescale 1ns/1ns

module datapath (
    input wire clk, rst,
    input wire PCWrite,
    input wire PCJZ,
    input wire AdrSrc,
    input wire MemWrite,
    input wire IRWrite,
    input wire DataSelect,
    input wire push,
    input wire pop,
    input wire tos,
    input wire AWrite,
    input wire ALUSrcA,
    input wire ALUSrcB,
    input wire [1:0] ALUControl,
    input wire PCSrc,
    output wire [2:0] opcode
);

    wire [3:0] pc_current;
    wire [4:0] next_pc;
    wire pc_enable, Zero;

    wire [4:0] mem_address;
    wire [7:0] mem_data;
    wire [7:0] MDR_out;
    wire [7:0] IR;

    wire [4:0] stack_d_in;
    wire [4:0] stack_d_out;

    wire [4:0] AluOut;
    wire [4:0] alu_result;
    wire [4:0] a_reg_out;
    wire [4:0] alu_srcA;
    wire [4:0] alu_srcB;

    risc_v_pc pc_reg (
        .clk(clk),
        .reset(rst),
        .enable(pc_enable),
        .next_pc(next_pc[3:0]),
        .pc(pc_current)
    );

    assign pc_enable = PCWrite || (PCJZ && Zero);

    risc_v_memory dmem (
        .clk(clk),
        .mem_write(MemWrite),
        .addr(mem_address),
        .data_in({3'b0, stack_d_out}),
        .data_out(mem_data)
    );

    assign mem_address = AdrSrc ? IR[4:0] : {1'b0, pc_current};

    register mdr (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .izR(1'b0),
        .din(mem_data),
        .qout(MDR_out)
    );

    register ir (
        .clk(clk),
        .rst(rst),
        .en(IRWrite),
        .izR(1'b0),
        .din(mem_data),
        .qout(IR)
    );

    assign opcode = IR[7:5];

    Stack stack (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .tos(tos),
        .data_in(stack_d_in),
        .data_out(stack_d_out),
        .full(),
        .empty()
    );

    assign Zero = ~|stack_d_out;
    assign stack_d_in = DataSelect ? MDR_out[4:0] : AluOut;

    register #(.n(5)) a_reg (
        .clk(clk),
        .rst(rst),
        .en(AWrite),
        .izR(1'b0),
        .din(stack_d_out),
        .qout(a_reg_out)
    );  

    assign alu_srcA = ALUSrcA ? a_reg_out : 5'd1;  
    assign alu_srcB = ALUSrcB ? stack_d_out : {1'b0, pc_current};

    ALU alu (
        .sl(ALUControl),
        .Ain(alu_srcA),
        .Bin(alu_srcB),
        .AluOut(alu_result)
    );

    register #(.n(5)) alu_reg (
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .izR(1'b0),
        .din(alu_result),
        .qout(AluOut)
    );

    assign next_pc = PCSrc ? IR[4:0] : alu_result;
    
endmodule
