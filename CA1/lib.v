module memory_block #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter ADDR_W = 4,
    parameter ADDR_H = 4
) (
    input wire clk,
    input wire wr,
    input wire rd,
    input wire [ADDR_W-1:0] addr_x,
    input wire [ADDR_H-1:0] addr_y,
    input wire data_in,
    output reg data_out
);

    reg [0:0] mem [0:WIDTH-1][0:HEIGHT-1];

    always @(*) begin
        if (wr) begin
            mem[addr_x][addr_y] = data_in;
        end
    end

    always @(posedge clk) begin
        if (rd) begin
            data_out <= mem[addr_x][addr_y];
        end
    end

endmodule

