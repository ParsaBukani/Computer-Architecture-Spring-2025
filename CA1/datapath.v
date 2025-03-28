`timescale 1 ns/ 1 ns

module maze_datapath (
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
    output [1:0] Move,
    output [3:0] X,
    output [3:0] Y
);
    wire [3:0] x_coordinate, y_coordinate;
    wire X_en, Y_en;
    wire count_up, count_down;
    wire x_overflow, x_underflow, y_overflow, y_underflow;

    wire [1:0] cnt_direction;
    wire [1:0] stack_data_out;

    wire [1:0] direction;

    up_down_counter #(4) X_coordinate (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init_x),
        .encnt(X_en),
        .pin(4'b0),
        .cntout(x_coordinate),
        .count_up(count_up),
        .count_down(count_down),
        .overflow(x_overflow),
        .underflow(x_underflow)
    );

    up_down_counter #(4) Y_coordinate (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init_y),
        .encnt(Y_en),
        .pin(4'b0),
        .cntout(y_coordinate),
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
        .cntout(cnt_direction),
        .co(co)
    );

    Stack stack (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .init(init_stack),
        .data_in(cnt_direction),
        .data_out(stack_data_out),
        .full(),
        .empty(empty)
    );

    Stack checkList (
        .clk(clk),
        .rst(rst),
        .push(checkList_push),
        .pop(read_checkList),
        .init(init_checkList),
        .data_in(stack_data_out),
        .data_out(Move),
        .full(),
        .empty(finished_reading)
    );

    assign direction = go_back ? ~stack_data_out : cnt_direction; // is might be better to use a register instead

    assign count_up = ~direction[1];
    assign count_down = direction[1];

    assign X_en = update_state ? (direction[1] ^ direction[0]) : 0;
    assign Y_en = update_state ? ~(direction[1] ^ direction[0]) : 0;

    assign invalid = x_overflow | x_underflow | y_overflow | y_underflow;
    assign found = (&{x_coordinate}) & (&{y_coordinate});
    assign X = x_coordinate;
    assign Y = y_coordinate;

endmodule

