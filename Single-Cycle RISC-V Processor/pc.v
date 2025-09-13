`timescale 1ns/1ns

module risc_v_pc #(
    parameter ADDR_WIDTH = 32
) (
    input wire clk,
    input wire reset,                   
    input wire [ADDR_WIDTH-1:0] next_pc,
    output [ADDR_WIDTH-1:0] pc      
);
    reg [ADDR_WIDTH-1:0] stored_pc;

    always @(posedge clk, posedge reset) begin
        if (reset)
            stored_pc <= {ADDR_WIDTH{1'b0}};
        else
            stored_pc <= next_pc;
    end

    assign pc = stored_pc;

endmodule
