`timescale 1ns/1ns

module risc_V_controlUnit(
    input clk,
    input rst,
    input Zero,
    input wire [6:0] opcode,
    input wire [2:0] func_3,
    input wire [6:0] func_7,
    output reg [2:0] ImmSrc,
    output reg [1:0] ResultSrc,
    output reg [1:0] AluOp,
    output reg AluSrc,
    output reg PcSrc,
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
                
            end
            0010011: // I_Type (Alu)
            begin
                
            end
            0000011: // I_Type (Load)
            begin
                
            end
            0100011: // S_Type
            begin
                
            end
            1100011: // B_Type
            begin
                
            end
            0110111: // U_Type (LUI)
            begin
                
            end
            0010111: // U_Type (AUIPC)
            begin
                
            end
            1101111: // J_Type
            begin
                
            end
            1100111: // I_Type (JALR)
            begin
                
            end
        endcase
    end
    
endmodule