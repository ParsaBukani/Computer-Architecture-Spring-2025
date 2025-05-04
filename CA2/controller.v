`timescale 1ns/1ns

module risc_V_controlUnit(
    input clk,
    input rst,
    input Zero,
    input wire [6:0] opcode,
    output reg [2:0] ImmSrc,
    output reg [1:0] ResultSrc,
    output reg [1:0] AluOp,
    output reg [1:0] PcSrc,
    output reg AluSrc,
    output reg MemWrite,
    output reg RegWrite
);

    parameter
        S0  = 1'b0;

    reg ps;
    reg ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else
            ps <= S0;
    end

    always @(*) begin       
        case (opcode)
            0110011: // R_Type
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b00;
                    AluSrc = 0;
                    AluOp = 2'b10;
                    ResultSrc = 2'b00;
                    ImmSrc = 3'bxxx;
                end
            0000011: // I_Type (Load)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b00;
                    AluSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'b01;
                    ImmSrc = 3'b000;
                end
            0010011: // I_Type (Alu)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b00;
                    AluSrc = 1;
                    AluOp = 2'b10;
                    ResultSrc = 2'b00;
                    ImmSrc = 3'b000;
                end
            1100111: // I_Type (JALR)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b10;
                    AluSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'b10;
                    ImmSrc = 3'b000;
                end
            0100011: // S_Type
                begin
                    RegWrite = 0;
                    MemWrite = 1;
                    PcSrc = 2'b00;
                    AluSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'bxx;
                    ImmSrc = 3'b001;
                end
            1100011: // B_Type
                begin
                    RegWrite = 0;
                    MemWrite = 0;
                    PcSrc = (Zero == 1) ? 2'b01 : 2'b00;
                    AluSrc = 1'bx;
                    AluOp = 2'b01;
                    ResultSrc = 2'bxx;
                    ImmSrc = 3'b010;
                end
            0110111: // U_Type (LUI)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b00;
                    AluSrc = 1'bx;
                    AluOp = 2'bxx;
                    ResultSrc = 2'b11;
                    ImmSrc = 3'b011;
                end
            1101111: // J_Type
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PcSrc = 2'b01;
                    AluSrc = 1'bx;
                    AluOp = 2'bxx;
                    ResultSrc = 2'b10;
                    ImmSrc = 3'b100;
                end
        endcase
    end
    
endmodule