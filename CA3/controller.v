`timescale 1ns/1ns

module controller (
    input wire clk, rst,
    input wire [2:0] opcode,
    output reg PCWrite,
    output reg PCJZ,
    output reg AdrSrc,
    output reg MemWrite,
    output reg IRWrite,
    output reg DataSelect,
    output reg push,
    output reg pop,
    output reg tos,
    output reg AWrite,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg [1:0] ALUControl,
    output reg PCSrc
);

    parameter [3:0]
        S1  = 4'b0001,
        S2  = 4'b0010,
        S3  = 4'b0011,
        S4  = 4'b0100,
        S5  = 4'b0101,
        S6  = 4'b0110,
        S7  = 4'b0111,
        S8  = 4'b1000,
        S9  = 4'b1001,
        S10 = 4'b1010,
        S11 = 4'b1011,
        S12 = 4'b1100;

    reg [3:0] ps;
    reg [3:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S1;
        else
            ps <= ns;
    end

    always @(ps, opcode) begin        
        case (ps)
            S1:  ns = S2;
            S2:  begin
                case (opcode)
                    3'b000: ns = S3;   //ADD
                    3'b001: ns = S3;   //SUB
                    3'b010: ns = S3;   //AND
                    3'b011: ns = S6;   //NOT
                    3'b100: ns = S8;   //PUSH
                    3'b101: ns = S10;  //POP
                    3'b110: ns = S11;  //JMP
                    3'b111: ns = S12;  //JZ
                endcase
            end
            S3:  ns = S4;
            S4:  ns = S5; 
            S5:  ns = S1;
            S6:  ns = S7;
            S7:  ns = S1;
            S8:  ns = S9;
            S9:  ns = S1;
            S10: ns = S1;
            S11: ns = S1;
            S12: ns = S1;
            default: ns = S1;
        endcase
    end

    always @(ps, opcode) begin  
        {PCWrite, PCJZ, AdrSrc, MemWrite, IRWrite, DataSelect, AWrite, ALUSrcA, ALUSrcB, PCSrc, push, pop, tos} = 13'd0;
        ALUControl = 2'b00;

        case (ps)
            S1: {IRWrite, PCWrite} = 2'b11;
            S2:  begin
                case (opcode)
                    3'b000: pop = 1'b1;   //ADD
                    3'b001: pop = 1'b1;   //SUB
                    3'b010: pop = 1'b1;   //AND
                    3'b011: pop = 1'b1;   //NOT
                    3'b100: ;             //PUSH
                    3'b101: pop = 1'b1;   //POP
                    3'b110: ;             //JMP
                    3'b111: tos = 1'b1;   //JZ
                endcase
            end
            S3:  {pop, AWrite} = 2'b11;
            S4:  begin 
                {ALUSrcA, ALUSrcB} = 2'b11;
                case (opcode)
                    3'b000: ALUControl = 2'b00;
                    3'b001: ALUControl = 2'b01;
                    3'b010: ALUControl = 2'b10;
                endcase
            end
            S5:  {push} = 1'b1;
            S6:  begin
                {ALUSrcB} = 1'b1;
                ALUControl = 2'b11;
            end
            S7:  {push} = 1'b1;
            S8:  {AdrSrc} = 1'b1;
            S9:  {DataSelect, push} = 2'b11;
            S10: {AdrSrc, MemWrite} = 2'b11;
            S11: {PCSrc, PCWrite} = 2'b11;
            S12: {PCSrc, PCJZ} = 2'b11;
        endcase
    end
    
endmodule
