`timescale 1ns/1ns

module tb_DigitalModulator();
  reg clk;
  reg rst;
  reg send;
  reg mode;
  reg [4:0] message;
  reg [2:0] cnt;

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

  always #1 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    send = 0;
    mode = 0;
    message = 5'b00000;
    cnt = 3'b000;

    #10;
    rst = 0;
    message = 5'b10101;
    #10;
    send = 1;
    #10000;
    send = 0;
    #1000000;
    #1000000;
    #1000000;
    #1000000;
    #1000000;
    #1000000;

    mode = 1;
    send = 1;
    #10000;
    send = 0;
    #1000000;
    #1000000;
    #1000000;
    #1000000;
    #1000000;
    #1000000;

    $stop;
  end

endmodule