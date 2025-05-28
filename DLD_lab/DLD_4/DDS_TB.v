`timescale 1ns/1ns

module DDSTestbench;
    reg clk;
    reg rst;
    wire [7:0] Data;

    DSS uut (
        .clk(clk),
        .rst(rst),
        .Data(Data)
    );

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 1;

        #20;
        rst = 0;

        #40000;

        $stop;
    end

endmodule