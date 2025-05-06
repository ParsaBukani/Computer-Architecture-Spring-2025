`timescale 1ns/1ns

module one_pulser_tb;

    reg rst;
    reg clk;
    reg clkPB;
    wire clkEN;
    
    one_pulser uut (
        .rst(rst),
        .clk(clk),
        .clkPB(clkPB),
        .clkEN(clkEN)
    );
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        clkPB = 0;
        
        #20 rst = 0;
        
        #30 clkPB = 1;
        #40 clkPB = 0;
        
        #60 clkPB = 1;
        #100 clkPB = 0;
        
        #40 clkPB = 1;
        #20 rst = 1;
        #21 rst = 0;
        #20 clkPB = 0;
        
        #100 $stop;
    end

endmodule