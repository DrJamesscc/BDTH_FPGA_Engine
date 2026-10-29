module DDS_sin_Ash(
  input clk,
  input rst_n,
  input [3:0]f_sel,
  input en,
  input SW0,SW1,SW2,SW3,
  output reg [15:0] dds_data
);
  reg[19:0]addr;
  reg[19:0]fword;
wire [15:0] sin_data;
wire [15:0] square_data;
wire [15:0] tri_data;
wire [15:0] saw_rev_data;

always @(*) begin
    if(SW0 && !SW1) begin
        // SW1拨下，SW2松开：C4
        case(f_sel)
            4'd0:  fword = 20'd1;
            4'd1:  fword = 20'd1432;
            4'd2:  fword = 20'd1514;
            4'd3:  fword = 20'd1607;
            4'd4:  fword = 20'd1699;
            4'd5:  fword = 20'd1803;
            4'd6:  fword = 20'd1907;
            4'd7:  fword = 20'd2022;
            4'd8:  fword = 20'd2142;
            4'd9:  fword = 20'd2268;
            4'd10: fword = 20'd2404;
            4'd11: fword = 20'd2546;
            4'd12: fword = 20'd2699;
            default: fword = 20'd1;
        endcase
    end
    else if(!SW0 && SW1) begin
        // SW2拨下，SW1松开：C6
        case(f_sel)
            4'd0:  fword = 20'd1;
            4'd1:  fword = 20'd5716;
            4'd2:  fword = 20'd6060;
            4'd3:  fword = 20'd6421;
            4'd4:  fword = 20'd6803;
            4'd5:  fword = 20'd7202;
            4'd6:  fword = 20'd7634;
            4'd7:  fword = 20'd8087;
            4'd8:  fword = 20'd8568;
            4'd9:  fword = 20'd9077;
            4'd10: fword = 20'd9617;
            4'd11: fword = 20'd10191;
            4'd12: fword = 20'd10798;
            default: fword = 20'd1;
        endcase
    end
    else begin
        // 都不拨下 / 两个同时拨下：C5基准
        case(f_sel)
            4'd0:  fword = 20'd1;
            4'd1:  fword = 20'd2858;
            4'd2:  fword = 20'd3027;
            4'd3:  fword = 20'd3208;
            4'd4:  fword = 20'd3399;
            4'd5:  fword = 20'd3601;
            4'd6:  fword = 20'd3814;
            4'd7:  fword = 20'd4044;
            4'd8:  fword = 20'd4284;
            4'd9:  fword = 20'd4541;
            4'd10: fword = 20'd4809;
            4'd11: fword = 20'd5093;
            4'd12: fword = 20'd5399;
            default: fword = 20'd1;
        endcase
    end
end

  always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
          addr <= 'd0;
        else if(en)
          addr <= addr + fword;
        else
          addr <='d0;
  end


    Gowin_pROM_sin_C4 sin_Ash(
        .dout(sin_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

    Gowin_pROM_square square_Ash(
        .dout(square_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

    Gowin_pROM_saw_rev saw_rev_Ash(
        .dout(saw_rev_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

always @(*) begin
    if(SW3) begin
        dds_data = saw_rev_data;
    end
    else if(SW2) begin
        dds_data = square_data;
    end
    else begin
        dds_data = sin_data;
    end
end

endmodule