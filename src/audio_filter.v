module fir(
	input wire 			clk,       //数据时钟 48kHZ 
	input wire 			sys_clk,  //系统时钟  26MHZ
	input wire 			rst_n,    
    input mode_valid,
	input signed[16:0] 		data_in,    
	output signed[16:0] data_out    
);

      reg signed[16:0] x1;
      reg signed[16:0] x2;
      reg signed[16:0] x3;
      reg signed[16:0] x4;
      reg signed[16:0] x5;
      reg signed[16:0] x6;
      reg signed[16:0] x7;
      reg signed[16:0] x8;
      reg signed[16:0] x9;
      reg signed[16:0] x10;

always @ (posedge clk or negedge rst_n)begin // 移位
	if(!rst_n)begin
		x1 <= 17'b0;
		x2 <= 17'b0;
		x3 <= 17'b0;
		x4 <= 17'b0;
		x5 <= 17'b0;
		x6 <= 17'b0;
		x7 <= 17'b0;
		x8 <= 17'b0;
		x9 <= 17'b0;
		x10 <= 17'b0;
	end
	else begin
		x1 <= data_in;
		x2 <= x1;
		x3 <= x2;
		x4 <= x3;
		x5 <= x4;
		x6 <= x5;
		x7 <= x6;
		x8 <= x7;
		x9 <= x8;
		x10 <= x9;
	end
end

localparam signed [15:0] h0  =  16'd0;
localparam signed [15:0] h1  = -16'd108;
localparam signed [15:0] h2  =  16'd600;
localparam signed [15:0] h3  = -16'd1476;
localparam signed [15:0] h4  =  16'd2356;
localparam signed [15:0] h5  =  16'd13640;
localparam signed [15:0] h6  =  16'd2356;
localparam signed [15:0] h7  = -16'd1476;
localparam signed [15:0] h8  =  16'd600;
localparam signed [15:0] h9  = -16'd108;
localparam signed [15:0] h10 =  16'd0;

reg [3:0] counter;
always @ (posedge sys_clk or negedge rst_n)begin
    if(~rst_n)begin
        counter <= 4'd0;  
    end else begin
        if(counter == 4'd10) begin
            counter <= 4'd0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

reg signed[16:0] 	mult_a;    //寄存的输入数据
reg signed[15:0] 	mult_b;    //滤波器系数
wire signed[33:0] 	mult_p;    //data_in[15:0] * h[7:0]  
assign mult_p = mult_a * mult_b;

always @ (posedge sys_clk or negedge rst_n)begin
	if(~rst_n)begin
		mult_a <= 17'b0;
		mult_b <= 16'sb0;
	end
	else begin
		case(counter)
			4'd0:begin
				mult_a <= data_in;
				mult_b <= h0;
			end
			4'd1:begin
				mult_a <= x1;
				mult_b <= h1;
			end
			4'd2:begin
				mult_a <= x2;
				mult_b <= h2;
			end
			4'd3:begin
				mult_a <= x3;
				mult_b <= h3;
			end
			4'd4:begin
				mult_a <= x4;
				mult_b <= h4;
			end
			4'd5:begin
				mult_a <= x5;
				mult_b <= h5;
			end
			4'd6:begin
				mult_a <= x6;
				mult_b <= h6;
			end
			4'd7:begin
				mult_a <= x7;
				mult_b <= h7;
			end
			4'd8:begin
				mult_a <= x8;
				mult_b <= h8;
			end
			4'd9:begin
				mult_a <= x9;
				mult_b <= h9;
			end
			4'd10:begin
				mult_a <= x10;
				mult_b <= h10;
			end
            default: begin
                mult_a <= 17'b0;
                mult_b <= 16'sb0;
            end
		endcase
	end
end

reg signed[16:0] data_out_t;
//累加求和32bit
reg signed[34:0] data_out_temp;  
 
always @ (posedge sys_clk or negedge rst_n)begin
	if(~rst_n)begin
		data_out_temp <= 35'b0;
		data_out_t <= 17'b0;
	end
	else begin
		data_out_temp <= data_out_temp + mult_p;
		if(counter == 4'd10)begin
			data_out_t <= data_out_temp[34:18];   //数据截断，取前16bit
			data_out_temp <= 35'b0;
		end
	end
end 

assign data_out = (mode_valid == 1'd1) ? data_out_t : data_in ;

endmodule