module audio_delay(

  input clk,
  input rstn,
  
  input mode_valid,

  input [16:0] i_audio_data,
  
  output [16:0] o_audio_data
);

wire [16:0] audio_data_t;
wire [16:0] audio_data_t2;
wire full_flag;
wire full_flag2;
wire audio_read_en;
wire audio_read_en2;
assign audio_read_en = (full_flag == 1'b1) ? 1'd1:1'd0;
assign audio_read_en2 = (full_flag2 == 1'b1) ? 1'd1:1'd0;
	fifo_sc_top_delay delay(
		.Data(i_audio_data), //input [16:0] Data

		.Clk(clk), //input Clk

		.WrEn(1'd1), //input WrEn
		.RdEn(audio_read_en), //input RdEn

		.Reset(!rstn), //input Reset

		.Q(audio_data_t), //output [16:0] Q

		.Empty(), //output Empty
		.Full(full_flag) //output Full
	);

assign o_audio_data = (mode_valid == 1'd1) ?  $signed (audio_data_t): i_audio_data;
endmodule