`timescale 1ns/1ns

module risc_V_controlUnit(
    input wire zero,
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    output reg [1:0] PCSrc,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg [1:0] AluOp,
    output reg ALUSrc,
    output reg [2:0] ImmSrc,
    output reg RegWrite
);

    always @(*) begin
        case (opcode)
            7'b0110011: // R_Type
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b00;
                    ALUSrc = 0;
                    AluOp = 2'b10;
                    ResultSrc = 2'b00;
                    ImmSrc = 3'bxxx;
                end

            7'b0000011: // I_Type (Load)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b00;
                    ALUSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'b01;
                    ImmSrc = 3'b000;
                end

            7'b0010011: // I_Type (Alu)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b00;
                    ALUSrc = 1;
                    AluOp = 2'b10;
                    ResultSrc = 2'b00;
                    ImmSrc = 3'b000;
                end

            7'b1100111: // I_Type (Jalr)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b10;
                    ALUSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'b10;
                    ImmSrc = 3'b000;
                end

            7'b0100011: // S_Type
                begin
                    RegWrite = 0;
                    MemWrite = 1;
                    PCSrc = 2'b00;
                    ALUSrc = 1;
                    AluOp = 2'b00;
                    ResultSrc = 2'bxx;
                    ImmSrc = 3'b001;
                end
            
            7'b1100011: // B-Type
                begin 
                    RegWrite = 0;
                    MemWrite = 0;
                    ALUSrc = 0;
                    AluOp = 2'b01;         
                    ImmSrc = 3'b010;
                    ResultSrc = 2'bxx;     

                    case (funct3)
                        3'b000: PCSrc = (zero == 1) ? 2'b01 : 2'b00;  // BEQ
                        3'b001: PCSrc = (zero == 0) ? 2'b01 : 2'b00;  // BNE
                        default: PCSrc = 2'b00; 
                    endcase
                end

            7'b0110111: // U_Type (Lui)
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b00;
                    ALUSrc = 1'bx;
                    AluOp = 2'bxx;
                    ResultSrc = 2'b11;
                    ImmSrc = 3'b011;
                end

            7'b1101111: // J_Type
                begin
                    RegWrite = 1;
                    MemWrite = 0;
                    PCSrc = 2'b01;
                    ALUSrc = 1'bx;
                    AluOp = 2'bxx;
                    ResultSrc = 2'b10;
                    ImmSrc = 3'b100;
                end
            default
                begin
                    RegWrite = 0;
                    MemWrite = 0;
                end
        endcase
    end
    
endmodule
