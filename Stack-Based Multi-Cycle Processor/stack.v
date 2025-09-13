`timescale 1ns/1ns

module Stack #( 
    parameter WIDTH = 5,    
    parameter DEPTH = 32     
) (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire tos,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] sp; 

    assign empty = (sp == 0);
    assign full = (sp == DEPTH);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            data_out <= 0;
        end else begin
            case (1'b1)
                push: begin
                    if (!full) begin
                        mem[sp] <= data_in;
                        sp <= sp + 1;
                    end
                end
                pop: begin
                    if (!empty) begin
                        sp <= sp - 1;
                        data_out <= mem[sp - 1];
                    end
                end
                tos: begin
                    if (!empty) begin
                        data_out <= mem[sp - 1];
                    end
                end
            endcase
        end
    end

endmodule
