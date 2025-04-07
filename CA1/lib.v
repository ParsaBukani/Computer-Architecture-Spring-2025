module memory_block #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter ADDR_W = 4,
    parameter ADDR_H = 4,
    parameter FILE_PATH = "map.txt" //change
) (
    input wire clk,
    input wire wr,
    input wire rd,
    input wire [ADDR_W-1:0] addr_x,
    input wire [ADDR_H-1:0] addr_y,
    input wire data_in,
    output reg data_out
);
    reg [0:WIDTH - 1] mem [0:HEIGHT - 1];

    initial begin
        $readmemb(FILE_PATH, mem);
    end

    always @(*) begin
        if (rd) begin
            data_out = mem[addr_y][addr_x];
        end
    end

    always @(posedge clk) begin 
        if (wr) begin
            mem[addr_y][addr_x] <= data_in;
        end
    end

endmodule


module counter #(
    parameter m = 2
) (
    input wire clk,
    input wire rst,
    input wire ld,
    input wire encnt,
    input wire init,
    input wire [(m - 1):0] pin,
    output reg [(m - 1):0] cntout,
    output wire co
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            cntout <= {m{1'b0}};
        else if (ld) begin
            cntout <= pin;
        end
        else if (init) begin
            cntout <= {m{1'b0}};
        end
        else if (encnt) begin
            cntout <= cntout + 1;
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
    input wire init,
    input wire count_up,
    input wire count_down,
    input wire [(m - 1):0] pin,
    output reg [(m - 1):0] cntout,
    output wire overflow,
    output wire underflow
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cntout <= {m{1'b0}};
        end 
        else if (encnt) begin
            if (ld) begin
                cntout <= pin;
            end 
            else if (init) begin
                cntout <= {m{1'b0}};
            end 
            else begin
                if (count_up) begin
                    cntout <= cntout + 1;
                end 
                if (count_down) begin
                    cntout <= cntout - 1;
                end
            end
        end
    end

    assign overflow = encnt & count_up & (cntout == {m{1'b1}});
    assign underflow = encnt & count_down & (cntout == {m{1'b0}});

endmodule



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


module decoder #(  
    parameter WIDTH = 4  
) (  
    input wire en,  
    input wire [WIDTH-1:0] in,  
    output reg [(2**WIDTH)-1:0] out  
);  
    always @(*) begin   
        out <= 0; 
        if (en) begin  
            out[in] <= 1'b1; 
        end 
    end 

endmodule  


module mux #(
    parameter WIDTH = 4,
    parameter DATA_WIDTH = 2
) (
    input wire [((DATA_WIDTH)*(2**WIDTH))-1:0] data,
    input wire [WIDTH-1:0] sel, 
    input wire en,   
    output reg [DATA_WIDTH-1:0] out 
);
    always @(*) begin
        out <= {DATA_WIDTH{1'b0}};
        if (en) begin
            out <= data[sel]; 
        end
    end
endmodule

