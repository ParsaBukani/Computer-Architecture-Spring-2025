`timescale 1ns/1ns

module alu_control (
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // ADD for LW/SW/ADD
            2'b01: ALUControl = 3'b001; // SUB for BEQ
            2'b10: begin // R-type
                case ({funct7, funct3})
                    10'b0000000000: ALUControl = 3'b000; // ADD
                    10'b0100000000: ALUControl = 3'b001; // SUB
                    10'b0000000111: ALUControl = 3'b010; // AND
                    10'b0000000110: ALUControl = 3'b011; // OR
                    10'b0000000010: ALUControl = 3'b100; // SLT
                    default:        ALUControl = 3'b000;
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule
