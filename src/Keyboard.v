`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/12 09:48:34
// Design Name: 
// Module Name: Matrix_Keyboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Keyboard (
    clk,
    rst_n,
	row,
	col,
	value
);
						
input clk;                        //ϵͳʱ�ӣ�50MHz
input rst_n;
input [3 : 0] row;
output [3 : 0] col;
output [3 : 0] value;

reg [3 : 0] col;
reg [3 : 0] value;

reg [19 : 0] cnt;

reg [5 : 0] current_state;
reg [5 : 0] next_state;
reg key_pressed_flag;             //���̰��±�־
reg [3 : 0] col_val;              //��ֵ
reg [3 : 0] row_val;              //��ֵ

/****************��Ƶ����******************/

always @(posedge clk or negedge rst_n)
    if(!rst_n)
	    cnt <= 20'd0;
	else 
	    cnt <= cnt + 1'b1;
		
wire key_clk = cnt[10];                 //(2^20)/50M=21ms

/****************״̬��*********************/

parameter NO_KEY_PRESSED = 6'b000_001;          //û�а�������
parameter SCAN_COL0      = 6'b000_010;          //ɨ����0��
parameter SCAN_COL1      = 6'b000_100;          //ɨ����1��
parameter SCAN_COL2      = 6'b001_000;          //ɨ����2��
parameter SCAN_COL3      = 6'b010_000;          //ɨ����3��
parameter KEY_PRESSED    = 6'b100_000;          //�а�������

always @(posedge key_clk or negedge rst_n)
    if(!rst_n)
	    current_state <= NO_KEY_PRESSED;
	else
	    current_state <= next_state;
		
always @(*)
   case (current_state)
    NO_KEY_PRESSED :                           // û�а�������
        if (row != 4'hF)
            next_state = SCAN_COL0;
        else
            next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                               // ɨ����0�� 
        if (row != 4'hF)
            next_state = KEY_PRESSED;
        else
            next_state = SCAN_COL1;
    SCAN_COL1 :                               // ɨ����1�� 
        if (row != 4'hF)
            next_state = KEY_PRESSED;
        else
            next_state = SCAN_COL2;
    SCAN_COL2 :                               // ɨ����2��
        if (row != 4'hF)
            next_state = KEY_PRESSED;
        else
            next_state = SCAN_COL3;
    SCAN_COL3 :                               // ɨ����3��
        if (row != 4'hF)
            next_state = KEY_PRESSED;
        else
            next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                             // �а�������
        if (row != 4'hF)
            next_state = KEY_PRESSED;
        else
            next_state = NO_KEY_PRESSED;
    endcase	     
	
always @ (posedge key_clk or negedge rst_n)
    if (!rst_n)
        begin
            col <= 4'h0;
            key_pressed_flag <= 1'b0;
        end
    else
        case (next_state)
            NO_KEY_PRESSED :                                  // û�а�������
	            begin
                    col <= 4'h0;
                    key_pressed_flag <= 1'b0;                 // �����̰��±�־
                end
            SCAN_COL0 :                                       // ɨ����0��
                col <= 4'b1110;
            SCAN_COL1 :                                       // ɨ����1��
                col <= 4'b1101;
            SCAN_COL2 :                                       // ɨ����2��
                col <= 4'b1011;
            SCAN_COL3 :                                       // ɨ����3��
                col <= 4'b0111;
            KEY_PRESSED :                                     // �а�������
                begin
                    col_val <= col;                           // ������ֵ
                    row_val <= row;                           // ������ֵ
                    key_pressed_flag <= 1'b1;                 // �ü��̰��±�־  
                end
        endcase	
		
always @ (posedge key_clk or negedge rst_n)
  if (!rst_n)
    value <= 4'h0;
  else
    if (key_pressed_flag)
      case ({col_val, row_val})
        8'b1110_1110 : value <= 4'h0;              //1
        8'b1110_1101 : value <= 4'h1;              //4
        8'b1110_1011 : value <= 4'h2;              //7
        8'b1110_0111 : value <= 4'h3;              //*
         
        8'b1101_1110 : value <= 4'h4;              //2
        8'b1101_1101 : value <= 4'h5;              //5
        8'b1101_1011 : value <= 4'h6;              //8
        8'b1101_0111 : value <= 4'h7;              //0
         
        8'b1011_1110 : value <= 4'h8;              //3
        8'b1011_1101 : value <= 4'h9;              //6
        8'b1011_1011 : value <= 4'hA;              //9
        8'b1011_0111 : value <= 4'hB;              //#
         
        8'b0111_1110 : value <= 4'hC;              //A
        8'b0111_1101 : value <= 4'hD;              //B
        8'b0111_1011 : value <= 4'hE;              //C
        8'b0111_0111 : value <= 4'hF;              //D       
      endcase		
endmodule 