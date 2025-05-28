`timescale 1ns/1ns

module freqF #(
    parameter m = 9
) (
    input wire clk,
    input wire rst,
    input wire [2:0] cnt,
    input wire ld,
    output wire co
);
    reg [(m - 1):0] cntout;

    always @(posedge clk or posedge rst) begin
        if (rst)
            cntout <= {m{1'b0}};
        else if (ld) begin
            cntout <= {1'b1, cnt, 5'b0};
        end
        else begin
            cntout <= cntout + 1;
        end
    end

    assign co = &{cntout};
    
endmodule