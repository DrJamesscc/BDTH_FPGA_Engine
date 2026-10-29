module DDS_C4(
  input clk,
  input rst_n,
  input [3:0]f_sel,
  input en,
  output [15:0] dds_data
);
  reg[19:0]addr;
  reg[19:0]fword;
 
  always@(*)begin
        case(f_sel)
          0:fword = 1;
          1:fword = 1432;
          2:fword = 1514;
          3:fword = 1607;
          4:fword = 1699;
          5:fword = 1803;
          6:fword = 1907;
          7:fword = 2022;
          8:fword = 2142;
          9:fword = 2268;
          10:fword = 2404;
          11:fword = 2546;
          12:fword = 2699;

          default:fword = 1;
         endcase
  end


  always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
          addr <= 'd0;
        else if(en)
          addr <= addr + fword;
        else
          addr <='d0;
  end


    Gowin_pROM_sin_C4 sin_rom_C4(
        .dout(dds_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

endmodule