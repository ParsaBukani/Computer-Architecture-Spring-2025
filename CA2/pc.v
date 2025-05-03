module risc_v_pc #(
    parameter ADDR_WIDTH = 32
) (
    input wire clk,
    input wire reset,                   
    input wire [ADDR_WIDTH-1:0] next_pc,
    output reg [ADDR_WIDTH-1:0] pc      
);

    always @(posedge clk) begin
        if (reset)
            pc <= {ADDR_WIDTH{1'b0}};   
        else
            pc <= next_pc;             
    end

endmodule
