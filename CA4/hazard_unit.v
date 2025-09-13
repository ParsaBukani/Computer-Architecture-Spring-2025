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
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);

    always @(*) begin
        // ForwardAE logic
        if ((Rs1E == RdM) && (RegWriteM) && (Rs1E != 0))
            ForwardAE = 2'b10; // Forward from ALUOutM
        else if ((Rs1E == RdM) && (ResultSrcM == 2'b11) && (Rs1E != 0))
            ForwardAE = 2'b11; // Forward from ImmM (LUI)
        else if (((Rs1E == RdW) && (RegWriteW)) || ((Rs1E == RdW) && (ResultSrcW == 2'b11)) && (Rs1E != 0))
            ForwardAE = 2'b01; // Forward from ResultW
        else
            ForwardAE = 2'b00;

        // ForwardBE logic
        if ((Rs2E == RdM) && (RegWriteM) && (Rs2E != 0))
            ForwardBE = 2'b10;
        else if ((Rs2E == RdM) && (ResultSrcM == 2'b11) && (Rs2E != 0))
            ForwardBE = 2'b11;
        else if (((Rs2E == RdW) && (RegWriteW)) || ((Rs2E == RdW) && (ResultSrcW == 2'b11)) && (Rs2E != 0))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

    // Load-use hazard detection
    wire lwStall;
    assign lwStall = ((Rs1D == RdE || Rs2D == RdE) && ResultSrcE == 2'b01 && RdE != 0);

    // Stall signals
    always @(*) begin
        StallF = lwStall;
        StallD = lwStall;
    end

    // Flush signals
    always @(*) begin
        FlushE = lwStall || PCSrcE;
        FlushD = PCSrcE;
    end

endmodule
