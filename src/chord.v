module chord(
    input               clk_48k,
    input               sys_rst_n,

    input               SW0,
    input               SW1,
    input               SW2,
    input               SW3,

    input               note_en_chordC,  // 和弦总使能，高有效
    output signed [16:0] chord_out       // 叠加并衰减后的和弦输出
);

// 内部DDS raw数据
wire [15:0] dds_raw_C;
wire [15:0] dds_raw_E;
wire [15:0] dds_raw_G;

DDS_sin_C sin_C(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),
    .f_sel(4'd1),
    .en(note_en_chordC),
    .dds_data(dds_raw_C)
);

DDS_sin_E sin_E(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),
    .f_sel(4'd5),
    .en(note_en_chordC),
    .dds_data(dds_raw_E)
);

DDS_sin_G sin_G(
    .clk(clk_48k),
    .rst_n(sys_rst_n),
    .SW0(SW0),
    .SW1(SW1),
    .SW2(SW2),
    .SW3(SW3),
    .f_sel(4'd8),
    .en(note_en_chordC),
    .dds_data(dds_raw_G)
);

// 转为有符号，相加衰减
wire signed [15:0] s_C = $signed(dds_raw_C);
wire signed [15:0] s_E = $signed(dds_raw_E);
wire signed [15:0] s_G = $signed(dds_raw_G);

reg signed [16:0] sum_chord;
always @(*) begin
    if(!note_en_chordC) begin
        sum_chord = 17'sd0;
    end
    else begin
        sum_chord = (s_C + s_E + s_G) >>> 2; // >>2 除以4，压低幅度防溢出
    end
end

assign chord_out = sum_chord;

endmodule
