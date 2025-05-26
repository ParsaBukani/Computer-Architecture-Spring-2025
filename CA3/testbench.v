`timescale 1ns/1ns

module tb_system;
    reg clk;
    reg rst;

    system uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;

        #500;
        $stop;
    end
endmodule
