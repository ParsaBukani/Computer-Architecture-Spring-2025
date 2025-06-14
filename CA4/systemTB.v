`timescale 1ns/1ns

module riscv_testbench;

    reg clk;
    reg rst;

    risc_v_processor dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1; #10; rst = 0;
        #10000;
        $stop;
    end

endmodule
