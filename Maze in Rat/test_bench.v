`timescale 1ns / 1ns

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
            $display("No solution found.");
        end else begin
            $display("Maze solved successfully.");
            #20 run <= 1;
            #20 run <= 0;
            @(posedge clk);
            @(posedge clk);
            repeat (200) begin
                @(posedge clk);
                @(posedge clk);
                $display("Move: %b", Move);
            end
        end
        #1000 $stop;
    end

endmodule
