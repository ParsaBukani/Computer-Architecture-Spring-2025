`timescale 1ns/1ns

module system (
    input clk, rst,
    input wire clkPB,
    input wire ser_in,
    output wire p0, p1, p2, p3,
    output wire SerOutValid, done,
    output wire [6:0] SSD1, SSD2
);

    wire clkEn;
    wire cnt1, cnt2, cntD, ldcntD, sh_en, sh_enD, init_cnt1, init_cnt2;
    wire co1, co2, coD;
    wire [4:0] data_num;

    one_pulser u_one_pulser (
        .rst(rst),
        .clk(clk),
        .clkPB(clkPB),
        .clkEN(clkEn)
    );

    controller u_controller (
        .clk(clk),
        .rst(rst),
        .clkEn(clkEn),
        .serIn(ser_in),
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
        .Done(done),
        .SerOutValid(SerOutValid),
        .data_num(data_num)
    );

    DataPath u_datapath (
        .clk(clk),
        .clk_en(clkEn),
        .rst(rst),
        .init_cnt1(init_cnt1),
        .init_cnt2(init_cnt2),
        .cnt1(cnt1),
        .cnt2(cnt2),
        .cntD(cntD),
        .ld_cntD(ldcntD),
        .sh_en(sh_en),
        .sh_enD(sh_enD),
        .ser_in(ser_in),
        .co2(co2),
        .co1(co1),
        .coD(coD),
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .SSD_out_1(SSD1),
        .SSD_out_2(SSD2),
        .data_num(data_num)
    );

endmodule