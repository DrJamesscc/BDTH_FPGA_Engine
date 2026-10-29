`timescale 1ns / 1ps
module ADSR(
    input               clk,
    input               rst_n,
    input               en,          //按键使能：1按下，0松开
     input [15:0]   dds_data,          //ROM输出正弦波
    output  signed [15:0] ADSR_out   //最终输出：乘完包络的音频
);

localparam IDLE    = 2'd0;
localparam ATTACK  = 2'd1;
localparam DECAY   = 2'd2;
localparam SUSTAIN = 2'd3;
localparam RELEASE = 2'd4;

// 48kHz参数，和你原文完全一致
localparam ATTACK_STEP  = 14;
localparam DECAY_STEP   = 3;
localparam RELEASE_STEP = 2;
localparam SUSTAIN_LVL  = 16'h1800; // sustain电平

reg [2:0] adsr_state;
reg [15:0] env_gain; //Q2.14 0 ~ 0x4000

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        adsr_state <= IDLE;
        env_gain <= 16'd0;
    end else begin
        case(adsr_state)
            IDLE: begin
                if(en) begin
                    adsr_state <= ATTACK;
                    env_gain <= 16'd0;
                end
            end
            ATTACK:begin
                if(en) begin
                    if(env_gain >= 16'h3000) begin
                        adsr_state <= DECAY;
                    end else begin
                        env_gain <= env_gain + ATTACK_STEP;
                    end
                end else begin
                    adsr_state <= RELEASE;
                end
            end
            DECAY:begin
                if(en)begin
                    if(env_gain <= SUSTAIN_LVL) begin
                        adsr_state <= SUSTAIN;
                    end else begin
                        env_gain <= env_gain - DECAY_STEP;
                    end
                end else begin
                    adsr_state <= RELEASE;
                end
            end
            SUSTAIN:begin
                if(!en) adsr_state <= RELEASE;
            end
            RELEASE:begin
                if(env_gain == 16'd0) begin
                    adsr_state <= IDLE;
                end else begin
                    env_gain <= env_gain - RELEASE_STEP;
                end
            end
        endcase
    end
end

wire signed [15:0] sin_wave;
wire signed [31:0] multiply_full;
reg signed [15:0] dds_env_out;
assign sin_wave = $signed(dds_data);
assign multiply_full = sin_wave * $signed({1'b0, env_gain});

always @(*) begin
    dds_env_out = multiply_full >>> 14;
end

assign ADSR_out =(en == 1'd1) ? dds_env_out : dds_data ;

endmodule
