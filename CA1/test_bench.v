`timescale 1ns / 1ns

module stack_tb;

    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg init;
    reg [1:0] data_in;
    wire [1:0] data_out;
    wire full;
    wire empty;

    Stack uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .init(init),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        push = 0;
        pop = 0;
        init = 0;
        data_in = 0;

        #10 rst = 0;

        #10 init = 1;
        #10 init = 0;

        push_value(11);
        push_value(00);
        push_value(01);
        push_value(10);

        pop_value();
        pop_value();
        pop_value();
        pop_value();

        pop_value();

        repeat (255) push_value($random % 4);

        push_value(11);

        #100;
        $stop;
    end

    task push_value(input [1:0] value);
        begin
            @(posedge clk);
            push = 1;
            data_in = value;
            @(posedge clk);
            push = 0;
            #10;
        end
    endtask

    task pop_value;
        begin
            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            #10;
        end
    endtask

endmodule


module system_tb;
    reg clk;
    reg rst;
    reg start;
    reg run;
    wire Fail;
    wire Done;
    wire [1:0] Move;

    system uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .run(run),
        .Fail(Fail),
        .Done(Done),
        .Move(Move)
    );

    always #5 clk = ~clk;

    initial begin
        {rst, clk, start, run} = 4'b1000;
        #20 rst = 0;
        #20 start = 1;
        #20 start = 0;
    end

    always @(posedge Done or posedge Fail) begin
        if (Fail) begin
            $display("Test failed: No solution found.");
        end else begin
            $display("Test passed: Maze solved successfully.");
            #20 run <= 1;
            #20 run <= 0;
            repeat (50) begin
                @(posedge clk);
                $display("Move: %b", Move);
            end
        end
        #1000 $stop;
    end

endmodule



module queue_tb;

    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg init;
    reg [1:0] data_in;
    wire [1:0] data_out;
    wire full;
    wire empty;

    Queue uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        push = 0;
        pop = 0;
        init = 0;
        data_in = 0;

        #10 rst = 0;

        #10 init = 1;
        #10 init = 0;

        push_value(11);
        push_value(00);
        push_value(01);
        push_value(10);

        pop_value();
        pop_value();
        pop_value();
        pop_value();

        pop_value();

        repeat (255) push_value($random % 4);

        pop_value();
        pop_value();
        pop_value();
        push_value(00);
        push_value(01);
        push_value(11);
        push_value(00);

        #100;
        $stop;
    end

    task push_value(input [1:0] value);
        begin
            @(posedge clk);
            push = 1;
            data_in = value;
            @(posedge clk);
            push = 0;
            #10;
        end
    endtask

    task pop_value;
        begin
            @(posedge clk);
            pop = 1;
            @(posedge clk);
            pop = 0;
            #10;
        end
    endtask

endmodule