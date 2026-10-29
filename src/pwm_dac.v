
module pwm_dac (
    input clk,
    input [9:0] pcm_data,  // 10bit音频样本
    output reg pwm_out
);
    reg [9:0] sigma = 0;
 
    always @(posedge clk) begin
        sigma <= sigma[8:0] + pcm_data;
        pwm_out <= sigma[9];
    end


endmodule
