//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW5A-LV25MG121NC1/I0
//Device: GW5A-25
//Device Version: B
//Created Time: Sat Oct 24 16:19:56 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	fifo_sc_top_delay2 your_instance_name(
		.Data(Data), //input [16:0] Data
		.Clk(Clk), //input Clk
		.WrEn(WrEn), //input WrEn
		.RdEn(RdEn), //input RdEn
		.Reset(Reset), //input Reset
		.Q(Q), //output [16:0] Q
		.Empty(Empty), //output Empty
		.Full(Full) //output Full
	);

//--------Copy end-------------------
