`timescale 1ns/1ns

module tb_shift_register();
    parameter n = 5;  // Same as in the design

    reg clk, rst, shQ, ldQ, sin;
    reg [n-1:0] qin;
    wire [n-1:0] qout;
    wire sout;

    // Instantiate the shift register
    shift_register #(.n(n)) uut (
        .clk(clk),
        .rst(rst),
        .shQ(shQ),
        .ldQ(ldQ),
        .sin(sin),
        .qin(qin),
        .qout(qout),
        .sout(sout)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 0;
        shQ = 0;
        ldQ = 0;
        sin = 0;
        qin = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Test shift operation (right shift)
        shQ = 1;
        sin = 1;  // New bit to shift in
        #10;
        sin = 0;
        #10;
        sin = 1;
        #10;
        shQ = 0;
        #10;

        // End simulation
        $display("Simulation completed.");
        $stop;
    end
endmodule