//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.11.03 Education
//Part Number: GW5A-LV25MG121NC1/I0
//Device: GW5A-25
//Device Version: B
//Created Time: Tue Sep 29 15:51:19 2026

module Gowin_pROM_sin (dout, clk, oce, ce, reset, ad);

output [7:0] dout;
input clk;
input oce;
input ce;
input reset;
input [7:0] ad;

wire [23:0] prom_inst_0_dout_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[23:0],dout[7:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .AD({gw_gnd,gw_gnd,gw_gnd,ad[7:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 8;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'hD8D5D3D1CECCC9C7C4C1BFBCB9B6B3B1AEABA8A5A29F9C999693908C89868380;
defparam prom_inst_0.INIT_RAM_01 = 256'hFFFFFFFEFEFEFDFDFCFBFAFAF9F8F6F5F4F3F1F0EFEDEBEAE8E6E4E2E0DEDCDA;
defparam prom_inst_0.INIT_RAM_02 = 256'hDCDEE0E2E4E6E8EAEBEDEFF0F1F3F4F5F6F8F9FAFAFBFCFDFDFEFEFEFFFFFFFF;
defparam prom_inst_0.INIT_RAM_03 = 256'h8386898C909396999C9FA2A5A8ABAEB1B3B6B9BCBFC1C4C7C9CCCED1D3D5D8DA;
defparam prom_inst_0.INIT_RAM_04 = 256'h282B2D2F323437393C3F4144474A4D4F5255585B5E6164676A6D7074777A7D80;
defparam prom_inst_0.INIT_RAM_05 = 256'h01010102020203030405060607080A0B0C0D0F1011131516181A1C1E20222426;
defparam prom_inst_0.INIT_RAM_06 = 256'h2422201E1C1A1816151311100F0D0C0B0A080706060504030302020201010101;
defparam prom_inst_0.INIT_RAM_07 = 256'h7D7A7774706D6A6764615E5B5855524F4D4A4744413F3C393734322F2D2B2826;

endmodule //Gowin_pROM_sin
