module top(

  input  sys_clk,  //系统时钟
  input  sys_rst_n,  //系统复位

  input      [3:0]    row,        // 键盘行输入
  output     [3:0]    col,        // 键盘列输出

  input      SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,        

  output audio_out

);

wire clk;
    Gowin_PLL PLL(
        .clkin(sys_clk), //input  clkin
        .clkout0(clk), //output  clkout0
        .clkout1(clk_pwm), //output  clkout1
        .mdclk(1'b0) //input  mdclk
);

Keyboard u_keyboard(
    .clk(sys_clk),  
    .rst_n(sys_rst_n),
    .row(row),
    .col(col),
    .value(key_value)  // key_value[3:0] 按键编码
);
wire [3:0] key_value;

reg [9:0] cnt;
localparam DIV_NUM = 10'd259;
reg clk_48k;
always @(posedge clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt <= 9'd0;
        clk_48k <= 1'b0;
    end else begin
        if(cnt == DIV_NUM) begin
            cnt <= 9'd0;
            clk_48k <= ~clk_48k; //翻转，产生方波
        end else begin
            cnt <= cnt + 1'd1;
        end
    end
end

wire [16:0] wave_sum_signed;

wire [15:0] dds_raw_C;
wire [15:0] dds_raw_Csh;
wire [15:0] dds_raw_D;
wire [15:0] dds_raw_Dsh;
wire [15:0] dds_raw_E;
wire [15:0] dds_raw_F;
wire [15:0] dds_raw_Fsh;
wire [15:0] dds_raw_G;
wire [15:0] dds_raw_Gsh;
wire [15:0] dds_raw_A;
wire [15:0] dds_raw_Ash;
wire [15:0] dds_raw_B;

DDS_sin_C sin_C(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_C),
    .dds_data(dds_raw_C)
);

DDS_sin_Csh sin_Csh(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_Csh),
    .dds_data(dds_raw_Csh)
);

DDS_sin_D sin_D(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_D),
    .dds_data(dds_raw_D)
);

DDS_sin_Dsh sin_Dsh(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_Dsh),
    .dds_data(dds_raw_Dsh)
);

DDS_sin_E sin_E(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_E),
    .dds_data(dds_raw_E)
);

DDS_sin_F sin_F(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_F),
    .dds_data(dds_raw_F)
);

DDS_sin_Fsh sin_Fsh(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3), 

    .f_sel(key_reg+1'b1),
    .en(note_en_Fsh),
    .dds_data(dds_raw_Fsh)
);

DDS_sin_G sin_G(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_G),
    .dds_data(dds_raw_G)
);

DDS_sin_Gsh sin_Gsh(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3), 

    .f_sel(key_reg+1'b1),
    .en(note_en_Gsh),
    .dds_data(dds_raw_Gsh)
);

DDS_sin_A sin_A(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),
    .f_sel(key_reg+1'b1),
    .en(note_en_A),
    .dds_data(dds_raw_A)
);

DDS_sin_Ash sin_Ash(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_Ash),
    .dds_data(dds_raw_Ash)
);

DDS_sin_B sin_B(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),

    .f_sel(key_reg+1'b1),
    .en(note_en_B),
    .dds_data(dds_raw_B)
);

wire signed [16:0] chord_C_out;
reg note_en_chordC;
chord u_chord_C(
    .clk_48k(clk_48k),
    .sys_rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),
    .note_en_chordC(note_en_chordC),
    .chord_out(chord_C_out)
);


reg note_en_C, note_en_Csh, note_en_D, note_en_Dsh;
reg note_en_E, note_en_F, note_en_Fsh, note_en_G;
reg note_en_Gsh, note_en_A, note_en_Ash, note_en_B;


wire no_key = &row; // row[3],row[2],row[1],row[0]全部为1，代表没有按键按下
reg [3:0] key_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_reg <= 4'hF;
    end
    else if(no_key) begin
        key_reg <= 4'hF; //松开按键，强制置为4'hF
    end
    else begin
        key_reg <= key_value;
    end
end

always @(*) begin
    // 默认全部关闭
    {note_en_C, note_en_Csh, note_en_D, note_en_Dsh,
     note_en_E, note_en_F, note_en_Fsh, note_en_G,
     note_en_Gsh, note_en_A, note_en_Ash, note_en_B} = 12'b0;

    case(key_reg)
        4'h0: note_en_C    = 1'b1;
        4'h1: note_en_Csh  = 1'b1;
        4'h2: note_en_D    = 1'b1;
        4'h3: note_en_Dsh  = 1'b1;
        4'h4: note_en_E    = 1'b1;
        4'h5: note_en_F    = 1'b1;
        4'h6: note_en_Fsh  = 1'b1;
        4'h7: note_en_G    = 1'b1;
        4'h8: note_en_Gsh  = 1'b1;
        4'h9: note_en_A    = 1'b1;
        4'hA: note_en_Ash  = 1'b1;
        4'hB: note_en_B    = 1'b1;
        4'hC: note_en_chordC = 1'b1;
        default:; // 无按键，全部0
    endcase
end

wire [15:0] wave_C    = note_en_C    ? dds_raw_C    : 16'd0;
wire [15:0] wave_Csh  = note_en_Csh  ? dds_raw_Csh  : 16'd0;
wire [15:0] wave_D    = note_en_D    ? dds_raw_D    : 16'd0;
wire [15:0] wave_Dsh  = note_en_Dsh  ? dds_raw_Dsh  : 16'd0;
wire [15:0] wave_E    = note_en_E    ? dds_raw_E    : 16'd0;
wire [15:0] wave_F    = note_en_F    ? dds_raw_F    : 16'd0;
wire [15:0] wave_Fsh  = note_en_Fsh  ? dds_raw_Fsh  : 16'd0;
wire [15:0] wave_G    = note_en_G    ? dds_raw_G    : 16'd0;
wire [15:0] wave_Gsh  = note_en_Gsh  ? dds_raw_Gsh  : 16'd0;
wire [15:0] wave_A    = note_en_A    ? dds_raw_A    : 16'd0;
wire [15:0] wave_Ash  = note_en_Ash  ? dds_raw_Ash  : 16'd0;
wire [15:0] wave_B    = note_en_B    ? dds_raw_B    : 16'd0;


assign ADSR_in = (
    wave_C + wave_Csh +
    wave_D + wave_Dsh +
    wave_E + wave_F +
    wave_Fsh + wave_G +
    wave_Gsh + wave_A +
    wave_Ash + wave_B + chord_C_out
);

wire [16:0] ADSR_in;
wire [16:0] ADSR_out;
ADSR adsr(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .en(SW4),          //按键使能：1按下，0松开
    .dds_data(ADSR_in),          //ROM输出正弦波
    .ADSR_out(ADSR_out)   //最终输出：乘完包络的音频
);

wire [16:0] overdrive_data_out;
overdrive overdrive( 
.clk(sys_clk),
.rstn(sys_rst_n),
    
.mode_valid(SW5),
    
.i_audio_data(ADSR_out),
    
.o_audio_data(overdrive_data_out)

);

wire [16:0] delay_data_out; 
audio_delay delay(
    .clk(clk_48k),
    .rstn(sys_rst_n),
    .mode_valid(SW6),
    .i_audio_data(overdrive_data_out),
    .o_audio_data(delay_data_out)
);

wire [16:0] fir_data_out; 
fir u_fir_inst(
    .clk        (clk_48k),         //48KHz采样时钟
    .sys_clk    (sys_clk),     //26MHz系统时钟
    .rst_n      (sys_rst_n),       //复位，低有效
    .mode_valid (SW7),
    .data_in    (delay_data_out),     //17bit输入数据
    .data_out   (fir_data_out)     //17bit输出数据
);

reg [9:0] pcm_10bit;
wire audio_pwm_out ;
pwm_dac audio_dac_inst (
    .clk(sys_clk),      
    .pcm_data(pcm_10bit), // 输入10bit PCM音频样本
    .pwm_out(audio_pwm_out)
);
assign audio_out = audio_pwm_out ;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        pcm_10bit <= 10'd0;
    end
    else if(no_key) begin
        //松开按键强制中点，立刻静音
        pcm_10bit <= 10'd0;
    end
    else begin
        pcm_10bit = fir_data_out >>> 8;
    end
end

endmodule