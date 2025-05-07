`timescale 1ns/1ns

module controller (
    input clk, rst,
    input clkEn,
    input serIn,
    input co1, co2, coD,
    input wire [4:0] num_data,
    output reg cnt1, cnt2, cntD,
    output reg ldcntD,
    output reg sh_enD, sh_en,
    output reg init_cnt1, init_cnt2,
    output reg Done, SerOutValid
);

    parameter [2:0]
        S0  = 3'b000,
        S1  = 3'b001,
        S2  = 3'b010,
        S3  = 3'b011,
        S4  = 3'b100;

    reg [2:0] ps;
    reg [2:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else if (clkEn)
            ps <= ns;
    end

    always @(ps, serIn, co1, co2, coD) begin        
        case (ps)
            S0:  ns = serIn ? S0 : S1;
            S1:  ns = co1 ? S2 : S1;
            S2:  ns = co2 ? S3 : S2;
            S3:  ns = (num_data == 5'd1) ? S0 : S4;
            S4:  ns = coD ? S0 : S4;
            default: ns = S0;
        endcase
    end

    always @(ps, serIn, co1, co2, coD) begin  
        {cnt1, cnt2, cntD, ldcntD, sh_en, sh_enD, Done, SerOutValid, init_cnt1, init_cnt2} = 10'd0;

        case (ps)
            S0:  begin 
                {Done} = 1'b1;
                if (~serIn) begin
                    {init_cnt1, init_cnt2} = 2'b11;
                end
            end
            S1:  {cnt1, sh_en} = 2'b11;
            S2:  {cnt2, sh_enD} = 2'b11;
            S3:  {ldcntD, SerOutValid} = 2'b11;
            S4:  {cntD, SerOutValid} = 2'b11;
        endcase
    end

endmodule
