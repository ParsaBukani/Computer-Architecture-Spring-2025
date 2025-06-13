`timescale 1ns/1ns

module HazardUnit(
    input wire RegWriteM,
    input wire RegWriteW,
    input wire [1:0] ResultSrcE,
    input wire [1:0] ResultSrcM,
    input wire [1:0] ResultSrcW,
    input wire PCSrcE,
    input wire [4:0] Rs1D,
    input wire [4:0] Rs2D,
    input wire [4:0] Rs1E,
    input wire [4:0] Rs2E,
    input wire [4:0] RdE,
    input wire [4:0] RdM,
    input wire [4:0] RdW,
    output wire StallF,
    output wire StallD,
    output wire FlushD,
    output wire FlushE,
    output wire [1:0] ForwardAE,
    output wire [1:0] ForwardBE
);

    // Forwarding logic for ALU operand A
    assign ForwardAE = ((Rs1E == RdM && RegWriteM) && Rs1E != 0) ? 2'b10 : // Forward ALUOutM
                       (((Rs1E == RdW && RegWriteW) || (Rs1E == RdW && ResultSrcW == 2'b11)) && Rs1E != 0) ? 2'b01 : // Forward ResultW (including LUI)
                       ((Rs1E == RdM && ResultSrcM == 2'b11) && Rs1E != 0) ? 2'b11 : // Forward ImmM (LUI)
                       2'b00; // No forwarding

    // Forwarding logic for ALU operand B
    assign ForwardBE = ((Rs2E == RdM && RegWriteM) && Rs2E != 0) ? 2'b10 :
                       (((Rs2E == RdW && RegWriteW) || (Rs2E == RdW && ResultSrcW == 2'b11)) && Rs2E != 0) ? 2'b01 : 
                       ((Rs2E == RdM && ResultSrcM == 2'b11) && Rs2E != 0) ? 2'b11 :
                       2'b00; 

    // Load - stall
    wire lwStall;
    assign lwStall = ((Rs1D == RdE || Rs2D == RdE) && ResultSrcE == 2'b01 && RdE != 0);

    // Stall signals
    assign StallF = lwStall;
    assign StallD = lwStall;

    // Flush signals
    assign FlushE = lwStall || PCSrcE;
    assign FlushD = PCSrcE;

endmodule
