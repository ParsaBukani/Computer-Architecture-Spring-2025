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
        if (rd) begin
            data_out <= mem[addr_x][addr_y];
        end
    end

    always @(posedge clk) begin 
        if (wr) begin
            mem[addr_x][addr_y] = data_in;
        end
    end

endmodule

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

module counter #(
    parameter m = 8
) (
    input wire clk,
    input wire rst,
    input wire ld,
    input wire encnt,
    input wire [(m - 1):0] pin,
    output reg [(m - 1):0] cntout
    output co,
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            cntout <= {m{1'b0}};
        else if (encnt) begin
            if (ld) begin
                cntout <= pin;
            end
            else begin
                cntout <= cntout + 1;
            end
        end
    end
    assign co = &{cntout};
endmodule

module up_down_counter #(
    parameter m = 8
) (
    input wire clk,
    input wire rst,
    input wire ld,
    input wire encnt,
    input wire count_up,
    input wire [0:(m - 1)] pin,
    output reg [0:(m - 1)] cntout
    output overflow,
    output underflow,
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            cntout <= {m{1'b0}};
        else if (encnt) begin
            if (ld) begin
                cntout <= pin;
            end
            else begin
                if (count_up) begin
                    cntout <= cntout + 1;
                end
                else begin
                    cntout <= cntout - 1;
                end   
            end
        end
    end
    assign overflow = &{cntout};
    assign underflow = ~|{cntout};
endmodule

module register #(
    parameter n = 8
) (
    input wire clk,
    input wire rst,
    input wire enr,
    input wire izR,
    input wire [0:(n - 1)]din,
    output reg [0:(n - 1)] qout
);
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            qout <= {n{1'b0}};
        end else if (enr) begin
            if (izR) begin
                qout <= {n{1'b0}};
            end else begin
                qout <= din;
            end
        end  
    end
endmodule

module decoder #(
    parameter WIDTH = 4
) (  
    input [0:WIDTH-1] in,
    output reg [0:2**WIDTH-1] out
);  

    always @(*) begin   
        out = 0;
        out[in] = 1'b1;  
    end  
endmodule

module decoder #(
    parameter MUX = 8
    parameter DATA_WIDTH = 2
) (  
    input wire [0:MUX-1] sl,
    input wire data_in [0:DATA_WIDTH][0:2**MUX-1]
    output reg [0:DATA_WIDTH] out
);  

    always @(*) begin   
        out = {DATA_WIDTH{1'b0}};
        out = data_in[sl];
    end  
endmodule
