`timescale 1ns/1ns
// `include "lib.v"

// module stack_dp #(
//     parameter WIDTH = 2,
//     parameter LENGTH = 8
// ) (
//     input wire encnt,
//     input wire clk,
//     input wire rst,
//     input wire rd,
//     input wire wr,
//     input wire init,
//     input wire count_up,
//     input wire count_down,
//     input wire [WIDTH-1:0] data_in,
//     output reg [WIDTH-1:0] data_out,
//     output overflow,
//     output underflow
// );

//     wire [(LENGTH - 1):0] cntout;

//     up_down_counter #(LENGTH) cnt (
//         .clk(clk),
//         .rst(rst),
//         .ld(1'b0),
//         .init(init),
//         .encnt(encnt),
//         .pin({LENGTH{1'b0}}),
//         .cntout(cntout),
//         .count_up(count_up),
//         .count_down(count_down),
//         .overflow(overflow),
//         .underflow(underflow)
//     );

//     reg [WIDTH-1:0] mem [0:(2**LENGTH)-1];

//     always @(posedge clk) begin
//         if (wr) begin
//             mem[cntout] = data_in;
//         end
//         else if (rd) begin
//             data_out <= mem[cntout];
//         end
//     end
// endmodule


// module stack_ctl (
//     input wire clk,
//     input wire rst,
//     input wire push,
//     input wire pop,
//     input wire full,
//     input wire empty,
//     output reg encnt,
//     output reg count_up,
//     output reg count_down,
//     output reg wr
// );
//     parameter [1:0] idle = 2'b00, inc = 2'b01, push_state = 2'b10, pop_state = 2'b11;
//     reg [1:0] pstate, nstate;

//     always @(posedge clk) begin
//         if (rst)
//             pstate <= idle;
//         else
//             pstate <= nstate;
//     end

//     always @(*) begin
//     {encnt, count_up, count_down, wr} = 0;
//         case (pstate)
//             idle: begin
//                 if (push) begin
//                     nstate = full ? idle : inc;
//                 end
//                 else if (pop) begin
//                     nstate <= empty ? idle : pop_state;
//                 end
//             end
//             inc: begin
//                 encnt = 1;
//                 count_up = 1;
//                 nstate <= push_state;
//             end
//             push_state: begin
//                 wr = 1;
//                 nstate <= idle;
//             end
//             pop_state: begin
//                 encnt = 1;
//                 count_down = 1;
//                 nstate <= idle;
//             end
//         endcase
//     end
    
// endmodule


// module stack #(  
//     parameter WIDTH = 2,  
//     parameter LENGTH = 8  
// ) (  
//     input wire clk,  
//     input wire rst,  
//     input wire push,  
//     input wire pop, 
//     input wire init, 
//     input wire rd,
//     input wire [WIDTH-1:0] data_in,  
//     output wire [WIDTH-1:0] data_out,
//     output reg full,  
//     output reg empty
// );  
//     wire encnt;
//     wire count_up;
//     wire count_down;
//     wire overflow;
//     wire underflow;
//     wire wr;  

//     stack_ctl control (  
//         .clk(clk),  
//         .rst(rst),  
//         .push(push),  
//         .pop(pop),  
//         .full(overflow),  
//         .empty(underflow),  
//         .encnt(encnt),  
//         .count_up(count_up),  
//         .count_down(count_down),  
//         .wr(wr) 
//     );

//     stack_dp #(  
//         .WIDTH(WIDTH),  
//         .LENGTH(LENGTH)  
//     ) data_path (  
//         .encnt(encnt),  
//         .clk(clk),  
//         .rst(rst),
//         .rd(rd),  
//         .wr(wr),
//         .init(init),
//         .count_up(count_up),
//         .count_down(count_down),
//         .data_in(data_in),  
//         .data_out(data_out),
//         .overflow(overflow),
//         .underflow(underflow)
//     );

//     assign full = overflow;
//     assign empty = underflow;

// endmodule 


module Stack (
    input wire clk,  
    input wire rst,  
    input wire push,  
    input wire pop, 
    input wire init, 
    input wire [1:0] data_in,  
    output reg [1:0] data_out,
    output wire full,
    output wire empty
);
    wire [7:0] cntout;

    up_down_counter #(8) cnt (
        .clk(clk),
        .rst(rst),
        .ld(1'b0),
        .init(init),
        .encnt(1'b1),
        .pin(8'b0),
        .cntout(cntout),
        .count_up(push & ~full), 
        .count_down(pop & ~empty), 
        .overflow(full),
        .underflow()
    );

    reg [1:0] mem [0:255];

    always @(posedge clk) begin
        if (push & ~full) begin
            mem[cntout] <= data_in;
        end
        if (pop & ~empty) begin
            data_out <= mem[cntout - 1];
        end
    end

    assign empty = (cntout == 0);

endmodule


