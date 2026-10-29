module overdrive( 
	input 		clk,
    input 		rstn,
    
    input 		mode_valid,
    
    input [16:0]i_audio_data,
    
    output [16:0] o_audio_data

);

reg signed [16:0]	audio_data_t;
wire signed [33:0]	squared_data_t;

assign squared_data_t = (i_audio_data * i_audio_data);

always @(posedge clk or negedge rstn )begin
	if(!rstn)begin
    	audio_data_t <= 17'd0;
    end
    else begin
		audio_data_t <= $signed(i_audio_data[16:1]) + $signed(squared_data_t[33:12]);
    end
end

assign o_audio_data = (mode_valid == 1'd1) ?  audio_data_t : i_audio_data;

endmodule