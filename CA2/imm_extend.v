`timescale 1ns/1ns

module ImmExtend (
    input wire [2:0] sl,
    input wire [24:0] immData,
    output reg [31:0] ImmOut
);
    always @(*) begin
        case (sl)
            3'b000 : alu 
            3'b001 : 
            3'b010 : 
            3'b011 : 
            3'b100 : 
            default:
            ImmOut = 32'b0;
        endcase
    end
    
endmodule