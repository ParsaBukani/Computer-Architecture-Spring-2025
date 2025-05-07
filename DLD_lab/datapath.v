`timescale 1ns/1ns

module shift_register #(parameter n = 5) (
    input wire clk,
    input wire clk_en,
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

        else if (clk_en) begin
            if (ldQ) begin
                qout <= qin;
            end else if (shQ) begin
                qout <= {qout[(n - 2):0], sin};
            end
        end
    end

    assign sout = qout[0];

endmodule

module counter #(
    parameter m = 2
) (
    input wire clk,
    input wire clk_en,
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
        else if (clk_en) begin
            if (ld) begin
                cntout <= pin;
            end
            else if (init) begin
                cntout <= {m{1'b0}};
            end
            else if (encnt) begin
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
    input wire clk_en,
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
        else if (encnt && clk_en) begin
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

    assign overflow = (cntout == {m{1'b1}}) ? 1'b1 : 1'b0;
    assign underflow = (cntout == {m{1'b0}}) ? 1'b1 : 1'b0;

endmodule

module demultiplexer (  
    input wire ser_in,  
    input wire [1:0] port_num,  
    output wire p0,  
    output wire p1,  
    output wire p2,  
    output wire p3  
);  

assign p0 = (port_num == 2'b00) ? ser_in : 1'b0;  
assign p1 = (port_num == 2'b01) ? ser_in : 1'b0;  
assign p2 = (port_num == 2'b10) ? ser_in : 1'b0;  
assign p3 = (port_num == 2'b11) ? ser_in : 1'b0;  

endmodule

module Seven_Segment(count, SSD);
  input [3:0] count;
  output reg [6:0] SSD;

  always@(count)begin
    case(count)
      4'b0000: SSD = 7'b1000000;
      4'b0001: SSD = 7'b1111001;
      4'b0010: SSD = 7'b0100100;
      4'b0011: SSD = 7'b0110000;
      4'b0100: SSD = 7'b0011001;
      4'b0101: SSD = 7'b0010010;
      4'b0110: SSD = 7'b0000010;
      4'b0111: SSD = 7'b1111000;
      4'b1000: SSD = 7'b0000000;
      4'b1001: SSD = 7'b0010000;
      4'b1010: SSD = 7'b0001000;
      4'b1011: SSD = 7'b0000011;
      4'b1100: SSD = 7'b1000110;
      4'b1101: SSD = 7'b0100001;
      4'b1110: SSD = 7'b0000110;
      4'b1111: SSD = 7'b0001110;
    endcase
  end

endmodule

module DataPath(
    input wire clk,
    input wire clk_en,
    input wire rst,
    input wire init_cnt1,
    input wire init_cnt2,
    input wire cnt1,
    input wire cnt2,
    input wire cntD,
    input wire ld_cntD,
    input wire sh_en,
    input wire sh_enD,
    input wire ser_in,

    output wire co2,
    output wire co1,
    output wire coD,
    output wire [4:0] data_num,
    output wire p0,
    output wire p1,
    output wire p2,
    output wire p3,
    output [6:0] SSD_out_1,
    output [6:0] SSD_out_2
);

wire [1:0] port_num;
wire [4:0] num_data;
wire [4:0] dataTrans_out;
//unusable
wire [2:0] DataNam_out;
wire [1:0] PortNam_out;
wire [4:0] DataNam_sh_out;
wire [1:0] PortNam_sh_in;
wire overflow, x_0, x_1, x_2, x_3;

assign data_num = num_data;

counter #(3) DataNum_cnt (
    .clk(clk),
    .clk_en(clk_en),
    .rst(rst),
    .ld(init_cnt2),
    .encnt(cnt2),
    .init(1'b0),
    .pin(3'b011),
    .cntout(DataNam_out),
    .co(co2)
);

// pin
counter #(2) PortNum_cnt (
    .clk(clk),
    .clk_en(clk_en),
    .rst(rst),
    .ld(init_cnt1),
    .encnt(cnt1),
    .init(1'b0),
    .pin(2'b10),
    .cntout(PortNam_out),
    .co(co1)
);

up_down_counter #(5) DataTrans_cnt (
    .clk(clk),
    .clk_en(clk_en),
    .rst(rst),
    .ld(ld_cntD),
    .init(1'b0),
    .encnt(1'b1),
    .pin(num_data),
    .cntout(dataTrans_out),
    .count_up(1'b0),
    .count_down(cntD),
    .overflow(x_0),
    .underflow(coD)
);

shift_register #(5) DataNam_sh (
    .clk(clk),
    .clk_en(clk_en),
    .rst(rst),
    .shQ(sh_enD),
    .ldQ(1'b0),
    .sin(ser_in),
    .qin(DataNam_sh_out),
    .qout(num_data),
    .sout(x_2)
);

shift_register #(2) PortNum_sh (
    .clk(clk),
    .clk_en(clk_en),
    .rst(rst),
    .shQ(sh_en),
    .ldQ(1'b0),
    .sin(ser_in),
    .qin(PortNam_sh_in), 
    .qout(port_num),
    .sout(x_3)
);

demultiplexer dmux (
    .ser_in(ser_in),
    .port_num(port_num),
    .p0(p0),
    .p1(p1),
    .p2(p2),
    .p3(p3)
);

Seven_Segment SSD1 (
    .count(dataTrans_out[3:0]),
    .SSD(SSD_out_1)
);

Seven_Segment SSD2 (
    .count({3'b0, dataTrans_out[4]}),
    .SSD(SSD_out_2)
);

endmodule