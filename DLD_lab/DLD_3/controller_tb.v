`timescale 1ns/1ns

`timescale 1ns/1ns

module tb_controller;

    reg clk, rst, clkEn, serIn;
    reg co1, co2, coD;

    wire cnt1, cnt2, cntD;
    wire ldcntD;
    wire sh_enD, sh_en;
    wire init_cnt1, init_cnt2;
    wire Done, SerOutValid;

    contorller uut (
        .clk(clk),
        .rst(rst),
        .clkEn(clkEn),
        .serIn(serIn),
        .co1(co1),
        .co2(co2),
        .coD(coD),
        .cnt1(cnt1),
        .cnt2(cnt2),
        .cntD(cntD),
        .ldcntD(ldcntD),
        .sh_enD(sh_enD),
        .sh_en(sh_en),
        .init_cnt1(init_cnt1),
        .init_cnt2(init_cnt2),
        .Done(Done),
        .SerOutValid(SerOutValid)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        clkEn = 0;
        serIn = 1;
        co1 = 0;
        co2 = 0;
        coD = 0;

        #10 rst = 0;

        #5 clkEn = 1;

        #10 serIn = 0;  // go to S1

        repeat(3) begin
            #10 co1 = 0; // Stay in S1
        end
        #10 co1 = 1;  // Go to S2

        repeat(3) begin
            #10 co2 = 0; // Stay in S2
        end
        #10 co2 = 1;  // Go to S3

        #10;  // Go to S4

        repeat(3) begin
            #10 coD = 0; // Stay in S4
        end
        #10 coD = 1;  // Go back to S0

        #20 $stop;
    end

endmodule
