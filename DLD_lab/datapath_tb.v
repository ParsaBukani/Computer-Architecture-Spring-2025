`timescale 1ns/1ns


module TopModule_tb;

    // Inputs
    reg clk = 0;
    reg rst = 1;
    reg clkPB = 0;
    reg ser_in = 0;

    // Outputs
    wire p0, p1, p2, p3;
    wire SerOutValid, done;
    wire [6:0] SSD1, SSD2;

    // Instantiate the DUT (Device Under Test)
    system uut (
        .clk(clk),
        .rst(rst),
        .clkPB(clkPB),
        .ser_in(ser_in),
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .SerOutValid(SerOutValid),
        .done(done),
        .SSD1(SSD1),
        .SSD2(SSD2)
    );

    // Clock generator
    always #5 clk = ~clk;  // 10ns period

    // Test sequence
    initial begin

        // Initial conditions
        rst = 1;
        clkPB = 0;
        ser_in = 1;
        #20;

        // Release reset
        rst = 0;
        #10;
        ser_in = 0;

        // Simulate button presses and serial input
        repeat (250) begin
            #10 clkPB = 1;
            ser_in = $random % 2; // Random 0 or 1 input
            #10 clkPB = 0;
            #10;
        end

        // Wait and finish
        #200;
        $stop;
    end

endmodule
