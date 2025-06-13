`timescale 1ns/1ns

module risc_V_controlUnit(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    output reg RegWrite,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg Jump,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg [2:0] ImmSrc,
    output reg JALRSrc
);

    always @(*) begin
        {RegWrite, ResultSrc, MemWrite, Jump, Branch, ALUOp, ALUSrc, ImmSrc, JALRSrc} = 13'b0;

        case (opcode)
            7'b0110011: // R-Type
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b00; 
                    MemWrite = 0;
                    Jump = 0; 
                    Branch = 0; 
                    ALUOp = 2'b10; 
                    ALUSrc = 0;
                    ImmSrc = 3'bxxx; 
                    JALRSrc = 0;
                end

            7'b0000011: // I-Type (Load)
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b01; 
                    MemWrite = 0;
                    Jump = 0; 
                    Branch = 0; 
                    ALUOp = 2'b00;  
                    ALUSrc = 1;  
                    ImmSrc = 3'b000;  
                    JALRSrc = 0;
                end

            7'b0010011: // I-Type (ALU)
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b00;  
                    MemWrite = 0;
                    Jump = 0;  
                    Branch = 0;  
                    ALUOp = 2'b10; 
                    ALUSrc = 1;  
                    ImmSrc = 3'b000;  
                    JALRSrc = 0;
                end

            7'b1100111: // I-Type (JALR)
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b10; 
                    MemWrite = 0;
                    Jump = 1;  
                    Branch = 0; 
                    ALUOp = 2'b00;  
                    ALUSrc = 1;  
                    ImmSrc = 3'b000; 
                    JALRSrc = 1;
                end

            7'b0100011: // S-Type
                begin
                    RegWrite = 0;
                    ResultSrc = 2'bxx;  
                    MemWrite = 1;
                    Jump = 0; 
                    Branch = 0;  
                    ALUOp = 2'b00; 
                    ALUSrc = 1;  
                    ImmSrc = 3'b001;  
                    JALRSrc = 0;
                end

            7'b1100011: // B-Type
                begin
                    RegWrite = 0;
                    ResultSrc = 2'bxx;  
                    MemWrite = 0;
                    Jump = 0; 
                    Branch = 1;  
                    ALUOp = 2'b01; 
                    ALUSrc = 0;  
                    ImmSrc = 3'b010;  
                    JALRSrc = 0;
                end

            7'b0110111: // U-Type (LUI)
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b11;  
                    MemWrite = 0;
                    Jump = 0; 
                    Branch = 0; 
                    ALUOp = 2'bxx; 
                    ALUSrc = 1'bx;  
                    ImmSrc = 3'b011; 
                    JALRSrc = 0;
                end

            7'b1101111: // J-Type (JAL)
                begin
                    RegWrite = 1;
                    ResultSrc = 2'b10; 
                    MemWrite = 0;
                    Jump = 1;  
                    Branch = 0; 
                    ALUOp = 2'bxx; 
                    ALUSrc = 1'bx;  
                    ImmSrc = 3'b100;  
                    JALRSrc = 0;
                end

            default:
                begin
                    RegWrite = 0;
                    MemWrite = 0;
                    Jump = 0;
                    Branch = 0;
                    ALUOp = 2'bxx;
                    ALUSrc = 1'bx;
                    ImmSrc = 3'bxxx;
                    JALRSrc = 0;
                end
        endcase
    end

endmodule
