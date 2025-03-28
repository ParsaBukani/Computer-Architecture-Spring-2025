`timescale 1 ns/ 1 ns

module maza_datapath(
    input clk, rst,
    input init_x,
    input init_y,
    input init_stack,
    input init_checkList,
    input init_count,
    input push, checkList_push,
    input pop,
    input update_state,
    input load_count, count_en,
    input go_back,
    input read_checkList,
    output invalid,
    output empty,
    output co,
    output found,
    output finished_reading,
    output [3:0] X,
    output [3:0] Y,
    output [1:0] Move
);
    wire [3:0] x_cordinate, y_cordinate;
    wire X_en, Y_en;
    wire count_up, count_down;
    wire x_overflow, x_underflow, y_overflow, y_underflow;

    wire [1:0] direction;
    wire [1:0] stack_data_out;

    up_down_counter #(4) X (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init_x),
        .encnt(X_en),
        .pin(4'b0),
        .cntout(x_cordinate),
        .count_up(count_up),
        .count_down(count_down),
        .overflow(x_overflow),
        .underflow(x_underflow)
    );

    up_down_counter #(4) Y (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init_y),
        .encnt(Y_en),
        .pin(4'b0),
        .cntout(y_cordinate),
        .count_up(count_up),
        .count_down(count_down),
        .overflow(y_overflow),
        .underflow(y_underflow)
    );

    counter #(2) direction_generator (
        .clk(clk),
        .rst(rst),
        .ld(load_count),
        .encnt(count_en),
        .init(init_count),
        .pin(stack_data_out),
        .cntout(direction),
        .co(co)
    );





    

endmodule