`timescale 1ns/1ns

module ALU (
    input wire [1:0] sl,             
    input wire [4:0] Ain,
    input wire [4:0] Bin,
    output reg [4:0] AluOut
);

    always @(*) begin
        case (sl)
            2'b00 : AluOut = Ain + Bin;            // ADD
            2'b01 : AluOut = Ain - Bin;            // SUB
            2'b10 : AluOut = Ain & Bin;            // AND
            2'b11 : AluOut = ~Bin;                 // NOT
            default: AluOut = 8'd0;
        endcase
    end

endmodule
