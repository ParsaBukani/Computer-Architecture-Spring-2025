module stack_dp #(
    parameter WIDTH = 2,
    parameter LENGTH = 8
) (
    input wire clk,
    input wire rst,
    input wire rd,
    input wire wr,
    input wire init,
    input wire count_up,
    input wire count_down,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output full,
    output empty
);

    wire [(LENGTH - 1):0] cntout;

    up_down_counter #(LENGTH) cnt (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init),
        .encnt(1'b1),
        .pin({LENGTH{1'b0}}),
        .cntout(cntout),
        .count_up(count_up),
        .count_down(count_down),
        .overflow(),
        .underflow()
    );

    reg [WIDTH-1:0] mem [0:(2**LENGTH)-1];

    always @(posedge clk) begin
        if (wr) begin
            mem[cntout] = data_in;
        end
        if (rd) begin
            data_out = mem[cntout-1];
        end
    end

    assign empty = ~|{cntout};
    assign full = &{cntout};

endmodule


module stack_ctl (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire full,
    input wire empty,
    output reg count_up,
    output reg count_down,
    output reg wr,
    output reg rd
);

    parameter
        idle        = 1'b0,
        inc         = 1'b1;

    reg pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= idle;
        else
            pstate <= nstate;
    end

    always @(*) begin
        case (pstate)
            idle:   nstate = (push) ? ((full) ? idle : inc) : idle;
            inc:    nstate = idle;
        endcase
    end

    always @(*) begin
        {count_up, count_down, wr, rd} = 4'b0000;

        case (pstate)
            idle: begin
                count_down = (pop & ~empty) ? 1'b1 : 1'b0;
                rd = (pop & ~empty) ? 1'b1 : 1'b0;
            end
            inc: begin
                wr = 1;
                count_up = 1;
            end

        endcase
    end

endmodule


module  Stack #(  
    parameter WIDTH = 2,  
    parameter LENGTH = 8  
) (  
    input wire clk,  
    input wire rst,
    input wire push,  
    input wire pop, 
    input wire init,
    input wire [WIDTH-1:0] data_in,  
    output wire [WIDTH-1:0] data_out,
    output wire full,  
    output wire empty
);
    wire count_up;
    wire count_down;
    wire overflow;
    wire underflow;
    wire wr;
    wire rd;

    stack_ctl control (  
        .clk(clk),  
        .rst(rst),  
        .push(push),  
        .pop(pop),  
        .full(overflow),  
        .empty(underflow), 
        .count_up(count_up),  
        .count_down(count_down),  
        .wr(wr),
        .rd(rd)
    );

    stack_dp #(  
        .WIDTH(WIDTH),  
        .LENGTH(LENGTH)  
    ) data_path ( 
        .clk(clk),  
        .rst(rst),
        .rd(rd),  
        .wr(wr),
        .init(init),
        .count_up(count_up),
        .count_down(count_down),
        .data_in(data_in),  
        .data_out(data_out),
        .empty(underflow),
        .full(overflow)
    );

    assign full = overflow;
    assign empty = underflow;

endmodule