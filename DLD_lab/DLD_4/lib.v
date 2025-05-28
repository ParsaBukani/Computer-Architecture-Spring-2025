`timescale 1ns/1ns

module counter #(
    parameter m = 6
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

module shift_register #(parameter n = 5) (
    input wire clk,
    input wire rst,
    input wire shQ,
    input wire ldQ,
    input wire sin,
    input wire [(n - 1):0] qin,
    output reg [(n - 1):0] qout,
    output wire sout
    );

    always @(posedge clk) begin
        if (rst) 
            qout <= {n{1'b0}};
        else begin
            if (ldQ) begin
                qout <= qin;
            end else if (shQ) begin
                qout <= {qout[(n - 2):0], sin};
            end
        end
    end

    assign sout = qout[n-1];

endmodule


module freqMux (
    input wire a,        
    input wire b,     
    input wire sel,   
    output wire clk 
);

  assign clk = sel ? a : b;

endmodule

module modeMux (
    input wire [7:0] a,        
    input wire sel,   
    output wire [7:0] y  
);

  assign y = sel ? a : 8'd128;

endmodule