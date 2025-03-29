`timescale 1 ns/ 1 ns

module maze_controller (
    input clk, rst,
    input start, run,
    input invalid,
    input empty,
    input co,
    input found,
    input finished_reading,
    input D_out,
    output reg init_x,
    output reg init_y,
    output reg init_stack,
    output reg init_checkList,
    output reg init_count,
    output reg push, checkList_push,
    output reg pop,
    output reg update_state,
    output reg load_count, count_en,
    output reg go_back,
    output reg read_checkList,
    output reg RD,
    output reg WR,
    output reg D_in,
    output reg Fail,
    output reg Done
);
    parameter [4:0]
        S0  = 5'b00000,
        S1  = 5'b00001,
        S2  = 5'b00010,
        S3  = 5'b00011,
        S4  = 5'b00100,
        S5  = 5'b00101,
        S6  = 5'b00110,
        S7  = 5'b00111,
        S8  = 5'b01000,
        S9  = 5'b01001,
        S10 = 5'b01010,
        S11 = 5'b01011,
        S12 = 5'b01100,
        S13 = 5'b01101,
        S14 = 5'b01110,
        S15 = 5'b01111,
        S16 = 5'b10000,
        S17 = 5'b10001;

    reg [4:0] ps;
    reg [4:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end

    always @(ps, start, run, invalid, empty, co, found, finished_reading, D_out) begin        
        case (ps)
            S0:  ns = start ? S1 : S0;
            S1:  ns = start ? S1 : S2;
            S2:  ns = S3;
            S3:  ns = S4;
            S4:  ns = invalid ? S8 : S5; //change
            S5:  ns = S6;
            S6:  ns = ~D_out ? S7 : S8;
            S7:  ns = found ? S14 : S2;
            S8:  ns = empty ? S9 : S10;
            S9:  ns = S0;
            S10: ns = S11;
            S11: ns = S12;
            S12: ns = co ? S8 : S13;
            S13: ns = S4; //change (it is better)
            S14: ns = S15;
            S15: ns = empty ? S16 : S14;
            S16: ns = run ? S17 : S16;
            S17: ns = finished_reading ? S16 : S17;
            default: ns = S0;
        endcase
    end

    always @(ps, start, run, invalid, empty, co, found, finished_reading, D_out) begin  
        {init_x, init_y, init_stack, init_checkList, init_count, push, checkList_push, pop, update_state, 
        load_count, count_en, go_back, read_checkList, RD, WR, D_in, Fail, Done} = 18'd0;

        case (ps)
            S0:  ;
            S1:  {init_x, init_y, init_stack, init_checkList} = 4'b1111;
            S2:  {init_count} = 1'b1;
            S3:  {WR, D_in} = 2'b11;
            S4:  {push, update_state} = 2'b11;
            S5:  {RD} = 1'b1;
            S6:  ;
            S7:  ;
            S8:  ;
            S9:  {Fail} = 1'b1;
            S10: {pop} = 1'b1;
            S11: {load_count, go_back} = 2'b11;
            S12: {go_back, update_state} = 2'b11;
            S13: {count_en} = 1'b1;
            S14: {pop} = 1'b1;
            S15: {checkList_push} = 1'b1;
            S16: {Done} = 1'b1;
            S17: {read_checkList} = 1'b1;
        endcase
    end

endmodule


