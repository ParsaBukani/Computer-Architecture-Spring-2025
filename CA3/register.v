`timescale 1ns/1ns

module register #(
    parameter n = 8
) (
    input wire clk,
    input wire rst,
    input wire en,
    input wire izR,
    input wire [(n - 1):0] din,
    output reg [(n - 1):0] qout
);
    always @(posedge clk or posedge rst) begin  
        if (rst)
            qout <= {n{1'b0}};
        else if (en) begin
            if (izR) begin
                qout <= {n{1'b0}};
            end 
            else begin
                qout <= din;
            end
        end  
    end

endmodule