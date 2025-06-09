`timescale 1ns/1ns


module MessageProcess_DP (
    input wire clk,
    input wire rst,
    input wire cnt10,
    input wire cnt4Ld,
    input wire shiftLd,
    input wire cnt10Init,
    input wire [4:0] message,
    output wire co2,
    output wire serOut
);

    wire co1;

    counter #(4) cnt4bit (
        .clk(clk),
        .rst(rst),
        .ld(cnt4Ld),
        .encnt(co1),
        .init(1'b0),
        .pin(4'b0110),
        .cntout(),
        .co(co2)
    );

    counter #(10) cnt10bit (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .encnt(cnt10),
        .init(cnt10Init),
        .pin(),
        .cntout(),
        .co(co1)
    );
    
    shift_register #(9) shiftReg (
        .clk(clk),
        .rst(rst),
        .shQ(co1),
        .ldQ(shiftLd),
        .sin(1'b0),
        .qin({4'b0101, message}),
        .qout(),
        .sout(serOut)
    );

endmodule



module MessageProcess_CTL (
    input wire clk,
    input wire rst,
    input wire co2,
    input wire send,
    output reg shiftLd,
    output reg cnt10Init,
    output reg cnt4Ld,
    output reg cnt10,
    output reg valid
);

    parameter [0:0]
        S0  = 1'b0,
        S1  = 1'b1;

    reg [0:0] ps;
    reg [0:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end

    always @(*) begin        
        case (ps)
            S0:  ns = send ? S1 : S0;
            S1:  ns = co2 ? S0 : S1;
            default: ns = S0;
        endcase
    end

    always @(*) begin  
        {shiftLd, cnt10, cnt4Ld, cnt10Init} = 4'b0;

        case (ps)
            S0:  {cnt4Ld, shiftLd, cnt10Init} = 3'b111;
            S1:  {cnt10, valid} = 2'b11;
        endcase
    end

endmodule



module MessageProcess (
    input wire clk,
    input wire rst,
    input wire send,
    input wire [4:0] message,
    output wire data,
    output wire valid
);

    wire co2, shiftLd, cnt10Init, cnt4Ld, cnt10;

    MessageProcess_CTL  controller (
        .clk(clk),
        .rst(rst),
        .co2(co2),
        .send(send),
        .shiftLd(shiftLd),
        .cnt10Init(cnt10Init),
        .cnt4Ld(cnt4Ld),
        .cnt10(cnt10),
        .valid(valid)
    );

    MessageProcess_DP datapath (
        .clk(clk),
        .rst(rst),
        .cnt10(cnt10),
        .cnt4Ld(cnt4Ld),
        .shiftLd(shiftLd),
        .cnt10Init(cnt10Init),
        .message(message),
        .co2(co2),
        .serOut(data)
    );

endmodule

