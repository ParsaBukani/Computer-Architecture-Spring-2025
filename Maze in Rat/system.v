`timescale 1 ns/ 1 ns

module system (
    input clk, rst,
    input start,
    input run,
    output Fail,
    output Done,
    output [1:0] Move
);
    wire init_x, init_y, init_stack, init_checkList, init_count;
    wire push, write_checkList, pop, update_state;
    wire load_count, count_en, go_back, read_checkList, checkList_direction, read_moves;
    wire RD, WR, D_in, D_out;
    wire invalid, empty, co, found, finished_reading;
    wire [3:0] X, Y;

    maze_datapath datapath (
        .clk(clk),
        .rst(rst),
        .init_x(init_x),
        .init_y(init_y),
        .init_stack(init_stack),
        .init_checkList(init_checkList),
        .init_count(init_count),
        .push(push),
        .write_checkList(write_checkList),
        .pop(pop),
        .update_state(update_state),
        .load_count(load_count),
        .count_en(count_en),
        .go_back(go_back),
        .read_checkList(read_checkList),
        .checkList_direction(checkList_direction),
        .read_moves(read_moves),
        .invalid(invalid),
        .empty(empty),
        .co(co),
        .found(found),
        .finished_reading(finished_reading),
        .Move(Move),
        .X(X),
        .Y(Y)
    );

    maze_controller controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .run(run),
        .invalid(invalid),
        .empty(empty),
        .co(co),
        .found(found),
        .finished_reading(finished_reading),
        .D_out(D_out),
        .init_x(init_x),
        .init_y(init_y),
        .init_stack(init_stack),
        .init_checkList(init_checkList),
        .init_count(init_count),
        .push(push),
        .write_checkList(write_checkList),
        .pop(pop),
        .update_state(update_state),
        .load_count(load_count),
        .count_en(count_en),
        .go_back(go_back),
        .read_checkList(read_checkList),
        .checkList_direction(checkList_direction),
        .RD(RD),
        .WR(WR),
        .D_in(D_in),
        .Fail(Fail),
        .Done(Done),
        .read_moves(read_moves)
    );

    memory_block #(
        .WIDTH(16),
        .HEIGHT(16),
        .ADDR_W(4),
        .ADDR_H(4),
        .FILE_PATH("map.txt")
    ) maze_memory (
        .clk(clk),
        .wr(WR),
        .rd(RD),
        .addr_x(X),
        .addr_y(Y),
        .data_in(D_in),
        .data_out(D_out)
    );

endmodule
