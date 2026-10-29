module audio_mix(

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

	fifo_sc_top_delay2 delay2(
		.Data(i_audio_data), //input [16:0] Data

		.Clk(clk), //input Clk

		.WrEn(1'd1), //input WrEn
		.RdEn(audio_read_en2), //input RdEn

		.Reset(!rstn), //input Reset

		.Q(audio_data_t2), //output [16:0] Q

		.Empty(), //output Empty
		.Full(full_flag2) //output Full
	);

//assign o_audio_data = (mode_valid == 1'd1) ?  $signed({audio_data_t[16],audio_data_t[16:1]}) + $signed({i_audio_data[16],i_audio_data[16:1]}) : i_audio_data;//audio_data_t : i_audio_data;
wire signed [16:0] audio_in_s  = $signed(i_audio_data);
wire signed [16:0] delay1_s    = $signed(audio_data_t);
wire signed [16:0] delay2_s    = $signed(audio_data_t2);

// 加权移位混音
wire signed [18:0] mix_sum;
assign mix_sum = (audio_in_s  >>> 1)                 // 50%
               + (delay2_s   >>> 2) + (delay2_s >>>4) // ~31.25%
               + (delay1_s   >>> 3) + (delay1_s >>>4); // ~18.75%

// 截取回17bit signed输出
wire signed [16:0] mix_out_s = mix_sum[16:0];

assign o_audio_data = (mode_valid == 1'd1) ? $unsigned(mix_out_s) : i_audio_data;

endmodule