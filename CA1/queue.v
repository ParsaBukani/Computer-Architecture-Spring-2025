module Queue_dp #(
    parameter WIDTH = 2,
    parameter LENGTH = 8
) (
    input wire clk,
    input wire rst,
    input wire init,
    input wire push_en,
    input wire pop_en,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output wire [LENGTH-1:0] cntout_push,
    output wire [LENGTH-1:0] cntout_pop,
    output reg full,
    output reg cnt_zero,
    output reg empty
);
    reg [WIDTH-1:0] mem [0:(2**LENGTH)-1];

    counter #(LENGTH) cnt_push (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init),
        .encnt(push_en),
        .pin({LENGTH{1'b0}}),
        .cntout(cntout_push),
        .co()
    );

    counter #(LENGTH) cnt_pop (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init),
        .encnt(pop_en),
        .pin({LENGTH{1'b0}}),
        .cntout(cntout_pop),
        .co()
    );

    always @(posedge clk) begin
        if (push_en) begin
            mem[cntout_push] <= data_in;
        end
        if (pop_en) begin
            data_out <= mem[cntout_pop];
        end
    end

    always @(*) begin
        empty <= (cntout_push == cntout_pop);
        full <= ((cntout_push + 1) % (1 << LENGTH)) == cntout_pop;
        cnt_zero <= ((cntout_push == 0) || (cntout_pop == 0));
    end

endmodule

module Queue_ctl
(
    input wire clk,
    input wire rst,
    input wire cnt_zero,
    input wire push,
    input wire pop,
    input wire full,
    input wire empty,
    output reg push_en,
    output reg pop_en,
    output reg cnt_init
);

    parameter
        idle        = 1'b0,
        reset_state = 1'b1;

    reg pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= idle;
        else
            pstate <= nstate;
    end

    always @(*) begin
        case (pstate)
            idle:   nstate = (empty && ~cnt_zero) ? reset_state : idle;
            reset_state:    nstate = idle;
        endcase
    end

    always @(*) begin
        {push_en, pop_en, cnt_init} = 3'b000;

        case (pstate)
            idle: begin
                push_en = push && ~full;
                pop_en = pop && ~empty;
            end
            reset_state: begin
                cnt_init = 1;
            end

        endcase
    end
endmodule

module Queue #(  
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
    wire [LENGTH-1:0] cntout_push, cntout_pop;
    wire push_en, pop_en, cnt_init, overflow, underflow, cnt_zero;

    Queue_dp #(.LENGTH(LENGTH), .WIDTH(WIDTH)) datapath (
        .clk(clk),
        .rst(rst),
        .init(cnt_init),
        .cnt_zero(cnt_zero),
        .push_en(push_en),
        .pop_en(pop_en),
        .data_in(data_in),
        .data_out(data_out),
        .cntout_push(cntout_push),
        .cntout_pop(cntout_pop),
        .full(overflow),
        .empty(underflow)
    );

    Queue_ctl controller (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .full(overflow),
        .empty(underflow),
        .push_en(push_en),
        .pop_en(pop_en),
        .cnt_init(init),
        .cnt_zero(cnt_zero)
    );

    assign full = overflow;
    assign empty = underflow;
endmodule