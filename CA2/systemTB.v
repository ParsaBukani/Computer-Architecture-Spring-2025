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
        $display("Starting simulation...");
        // $dumpfile("riscv_test.vcd"); 
        // $dumpvars(0, riscv_testbench);

        clk = 1;
        rst = 1;
        #6;
        rst = 0;

        #100;

        $display("Register x7 should contain 5 (1+4)");
        $stop;
    end

endmodule
