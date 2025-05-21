`timescale 1ns/1ns

module ControllerCnt(
    input wire clk,
    input wire rst,
    output reg SignBit,
    output reg PhasePose,
    output wire [5:0] cntout
);
wire co;
wire [5:0] pin;

counter cnt (
    .clk(clk),
    .rst(rst),
    .ld(1'b0),
    .encnt(1'b1),
    .init(1'b0),
    .pin(pin),
    .cntout(cntout),
    .co(co)
);
    parameter [1:0]
        S0  = 2'b00,
        S1  = 2'b01,
        S2  = 2'b10,
        S3  = 2'b11;

    reg [1:0] ps;
    reg [1:0] ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end

    always @(*) begin        
        case (ps)
            S0:  ns = co ? S1 : S0;
            S1:  ns = co ? S2 : S1;
            S2:  ns = co ? S3 : S2;
            S3:  ns = co ? S0 : S3;
            default: ns = S0;
        endcase
    end

    always @(*) begin  
        {SignBit, PhasePose} = 2'b0;

        case (ps)
            S0:  ;
            S1:  {PhasePose} = 1'b1;
            S2:  {SignBit} = 1'b1;
            S3:  {PhasePose, SignBit} = 2'b11;
        endcase
    end
    
endmodule

// module counter #(
//     parameter m = 6
// ) (
//     input wire clk,
//     input wire rst,
//     input wire ld,
//     input wire encnt,
//     input wire init,
//     input wire [(m - 1):0] pin,
//     output reg [(m - 1):0] cntout,
//     output wire co
// );
//     always @(posedge clk or posedge rst) begin
//         if (rst)
//             cntout <= {m{1'b0}};
//         else if (ld) begin
//             cntout <= pin;
//         end
//         else if (init) begin
//             cntout <= {m{1'b0}};
//         end
//         else if (encnt) begin
//             cntout <= cntout + 1;
//         end
//     end

//     assign co = &{cntout};
    
// endmodule


module TwosCompliment(
    input wire SignSelector,
    input wire [8:0] In,
    output reg [8:0] Out
);
    assign Out = SignSelector ? (~{In} + 1) : In;

endmodule

module SinRom #(
    parameter DATA_WIDTH     = 8,
    parameter MEM_ADDR_BITS  = 6
) (
    input   [MEM_ADDR_BITS-1:0] address,
    output  [DATA_WIDTH-1:0] readData
);

    reg [DATA_WIDTH-1:0] RAM[2**MEM_ADDR_BITS-1:0];

    initial begin
        $readmemb("rom.mem", RAM);
    end

    assign readData = RAM[address];

endmodule

module DSS(
    input wire clk,
    input wire rst,
    output wire [7:0] Data
);
    wire SignBit, PhasePose;
    wire [5:0] Addr, cntout;
    wire [7:0] RomOut;
    wire [8:0] SignOut;

    ControllerCnt ctl (
        .clk(clk),
        .rst(rst),
        .PhasePose(PhasePose),
        .SignBit(SignBit),
        .cntout(cntout)
    );

    assign Addr = PhasePose ? ~cntout : cntout;

    SinRom rom (
        .address(Addr),
        .readData(RomOut)
    );

    TwosCompliment SignMag (
        .SignSelector(SignBit),
        .In({1'b0, RomOut}),
        .Out(SignOut)
    );

    assign Data = SignOut[7:0];
    
endmodule