`timescale 1ns/1ns

module ImmExtend (
    input wire [2:0] sl,
    input wire [24:0] immData,
    output reg [31:0] ImmOut
);
    always @(*) begin
        case (sl)
            3'b000 : ImmOut = {20{immData[24]}, immData[24:13]};                                    // I_Type
            3'b001 : ImmOut = {20{immData[24]}, immData[24:18], immData[4;0]};                      // S_Type
            3'b010 : ImmOut = {20{immData[24]} ,immData[0], immData[23:18], immData[4:1], 1'b0};    // B_Type
            3'b011 : ImmOut = {immData[24:5], 12'b0};                                               // U_Type
            3'b100 : ImmOut = {12{immData[24]} ,immData[12:5], immData[13], immData[23:14], 1'b0};  // J_Type
            default:
                ImmOut = 32'b0;
        endcase
    end
    
endmodule