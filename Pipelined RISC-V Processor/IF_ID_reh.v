`timescale 1ns/1ns

module IF_ID_reg (
    input wire clk,
    input wire rst,
    input wire ld,     
    input wire flush,   
    input wire [31:0] PCF,
    input wire [31:0] InstrF,
    input wire [31:0] PCPlus4F,
    output reg [31:0] PCD,
    output reg [31:0] InstrD,
    output reg [31:0] PCPlus4D
);

    always @(posedge clk) begin
        if (rst || flush) begin
            PCD <= 0;
            InstrD <= 0;
            PCPlus4D <= 0;
        end
        else if (ld) begin
            PCD <= PCF;
            InstrD <= InstrF;
            PCPlus4D <= PCPlus4F;
        end
    end

endmodule