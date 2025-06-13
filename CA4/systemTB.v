`timescale 1ns/1ns

module riscv_testbench;

    reg clk;
    reg rst;

    riscv dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1; #2; rst = 0;
        #5000;
        $stop;
    end

endmodule
