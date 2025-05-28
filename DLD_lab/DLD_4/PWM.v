`timescale 1ns/1ns

module PWM (
    input wire clk,
    input wire rst,
    input wire [7:0] dataIn,
    output wire GPIO
);

    wire [7:0] cntOut;

    counter #(8) cnt8bit (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .encnt(1'b1),
        .init(1'b0),
        .pin(),
        .cntout(cntOut),
        .co()
    );

    assign GPIO = (cntOut < dataIn) ? 1'b1 : 1'b0;
    
endmodule