`timescale 1ns/1ns

module system (
    input clk,
    input rst,
    input wire send,
    input wire mode,
    input wire [4:0] message,
    input wire [2:0] cnt,
    output wire GPIO
);
    wire [7:0] dataOut;

    DigitalModulator uut (
        .clk(clk),
        .rst(rst),
        .send(send),
        .mode(mode),
        .message(message),
        .cnt(cnt),
        .dataOut(dataOut)
    );

    PWM pwm (
        .clk(clk),
        .rst(rst),
        .dataIn(dataOut),
        .GPIO(GPIO)
    );

endmodule
