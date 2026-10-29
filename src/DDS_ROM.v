 module DDS_ROM(
  input clk,
  input rst_n,
  input [19:0]fword ,
  input en,
  input SW2,SW3,SW4,
  output reg [15:0] dds_data


);
  reg[19:0]addr;
wire [15:0] sin_data;
wire [15:0] square_data;
wire [15:0] tri_data;
wire [15:0] saw_rev_data;


 always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
          addr <= 'd0;
        else if(en)
          addr <= addr + fword;
        else
          addr <='d0;
  end


    Gowin_pROM_sin_C4 sin_A(
        .dout(sin_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

    Gowin_pROM_square square_A(
        .dout(square_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );

/*    Gowin_pROM_tri tri_A(
        .dout(tri_data), //output [15:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(~rst_n), //input reset
        .ad(addr[19:10]) //input [9:0] ad
    );
*/
    Gowin_pROM_saw_rev saw_rev_A(
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
/*    else if(SW3) begin
        dds_data = tri_data;
    end*/
    else if(SW2) begin
        dds_data = square_data;
    end
    else begin
        dds_data = sin_data;
    end
end

endmodule 