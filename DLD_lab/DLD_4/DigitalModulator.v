`timescale 1ns/1ns

module DigitalModulator(
    input wire clk,
    input wire rst,
    input wire send,
    input wire mode,
    input wire [4:0] message,
    input wire [2:0] cnt,
    output wire [7:0] dataOut
);

    wire co1, co2;
    wire clkMode;
    wire freqSel;
    wire [7:0] dssOut;
    
    //FSK
    counter #(9) FSK_freqDiv (
        .clk(clk),
        .rst(rst),
        .ld(co1),
        .encnt(1'b1),
        .init(),
        .pin({1'b1, cnt, 5'b0}),
        .cntout(),
        .co(co1)
    );
    
    //ASK
    counter #(9) ASK_freqDiv (
        .clk(clk),
        .rst(rst),
        .ld(co2),
        .encnt(1'b1),
        .init(),
        .pin({1'b0, cnt, 5'b0}),
        .cntout(),
        .co(co2)
    );

    MessageProcess msgProcessor(
        .clk(co1),
        .rst(rst),
        .send(send),
        .message(message),
        .data(freqSel)
    );

    assign clkMode = freqSel ? co1 : co2;

    DSS dss(
        .clk(clkMode),
        .rst(rst),
        .Data(dssOut)
    );

    assign dataOut = (mode || freqSel) ? dssOut : 8'd128;

endmodule
