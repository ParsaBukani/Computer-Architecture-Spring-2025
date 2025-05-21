`timescale 1ns/1ns

module tb_MessageProcess;
    reg clk;
    reg rst;
    reg send;
    reg [4:0] message;
    wire data;

    MessageProcess uut (
        .clk(clk),
        .rst(rst),
        .send(send),
        .message(message),
        .data(data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        send = 0;
        message = 5'b00000;

        #15;
        rst = 0;
        message = 5'b10101; 

        #10;
        send = 1;
        #50; 
        send = 0;

        #50000;
        #50000;
        $stop;
    end
endmodule