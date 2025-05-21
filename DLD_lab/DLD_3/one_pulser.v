`timescale 1ns/ 1ns

module one_pulser (
    input wire rst,
    input wire clk,
    input wire clkPB,
    output reg clkEN
);

    parameter 
        A = 2'b00,
        B = 2'b01,
        C = 2'b10;
    
    reg [1:0] pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= A;
        else
            pstate <= nstate;
    end

    always @(*) begin
        case (pstate)
            A:   nstate = clkPB ? B : A;
            B:   nstate = C;
            C:   nstate = clkPB ? C : A;
        endcase
    end

    always @(*) begin
        {clkEN} = 1'b0;

        case (pstate)
            A: ;
            B: {clkEN} = 1'b1;
            C: ;

        endcase
    end

endmodule


