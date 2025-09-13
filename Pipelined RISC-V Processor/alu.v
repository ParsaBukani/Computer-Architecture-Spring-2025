`timescale 1ns/1ns

module ALU (
    input wire [2:0] sl,
    input wire [31:0] Ain,
    input wire [31:0] Bin,
    output reg [31:0] AluOut,
    output reg Zero
);

    always @(*) begin
        case (sl)
            3'b000 : AluOut = Ain + Bin;              // add
            3'b001 : AluOut = Ain - Bin;              // subtract
            3'b010 : AluOut = Ain & Bin;              // and
            3'b011 : AluOut = Ain | Bin;              // or
            3'b100 : AluOut = Ain < Bin ? 32'd1 : 32'd0; // SLT
            default: AluOut = 32'd0;                 
        endcase
    end

    assign Zero = (AluOut == 0) ? 1 : 0;

endmodule
