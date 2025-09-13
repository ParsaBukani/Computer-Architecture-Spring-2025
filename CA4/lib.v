`timescale 1ns/1ns

module mux_2to1 #(
    parameter DATA_WIDTH = 32
) (
    input wire [DATA_WIDTH-1:0] data0, data1,
    input wire sel,
    output reg [DATA_WIDTH-1:0] out
);
    always @(*) begin
        out = sel ? data1 : data0;
    end
endmodule

module mux_3to1 #(
    parameter DATA_WIDTH = 32
) (
    input wire [DATA_WIDTH-1:0] data0, data1, data2,
    input wire [1:0] sel,
    output reg [DATA_WIDTH-1:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule

module mux_4to1 #(
    parameter DATA_WIDTH = 32
) (
    input wire [DATA_WIDTH-1:0] data0, data1, data2, data3,
    input wire [1:0] sel,
    output reg [DATA_WIDTH-1:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            2'b11: out = data3;
        endcase
    end
endmodule

module adder #(
    parameter DATA_WIDTH = 32
) (
    input  wire [DATA_WIDTH-1:0] a,
    input  wire [DATA_WIDTH-1:0] b,
    output wire [DATA_WIDTH-1:0] sum
);
    assign sum = a + b;
endmodule
