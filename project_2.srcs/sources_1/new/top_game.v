`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 14:36:45
// Design Name: 
// Module Name: top_game
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


module top_game(
    input clk_100MHz,
    input button,
    input button2,
    input realjump,

    output TMDS_Tx_Clk_N,
    output TMDS_Tx_Clk_P,
    output [2:0]TMDS_Tx_Data_N,
    output [2:0]TMDS_Tx_Data_P,
    output Cmode,
    output VCCEN,
    output VCC,
    output GND,
    output reg led
    );
    
    wire clk_system;
    wire clk_10MHz;
    wire clk_100M;
    wire clk_9600;
    wire [23:0]RGB_Data;
        wire [23:0]RGB_In;
        wire RGB_HSync;
        wire RGB_VSync;
        wire RGB_VDE;
        wire tly;
    clk_wiz_0 clk(
        .clk_in1(clk_100MHz),
        .clk_out1(clk_system),
        .clk_out2(clk_100M),
        .clk_out3(clk_10MHz)
    );
        wire [11:0]Set_X;
        wire [11:0]Set_Y;
    reg [30:0]Baud_Rate=9600;
            assign VCCEN=1;
            assign VCC=1;
            assign GND=0;
    
     vga_out vga_out(
     .clk(clk_system),
     .button(button),
     .button2(button2),
   //  .realjump(realjump),
        .RGB_VDE(RGB_VDE),
         .Set_X(Set_X),
         .Set_Y(Set_Y),
         .RGB_Data(RGB_Data)   //RBG
        // .Cmode(Cmode)
    );
    Driver_HDMI Driver_HDMI0(
            .clk(clk_system),        //ʱ��
            .Rst(1),                 //��λ�ź�,�͵�ƽ��λ
            .Video_Mode(0),          //��Ƶ��ʽ
            .RGB_In(RGB_In),         //��������
            .RGB_Data(RGB_Data),     //�������
            .RGB_HSync(RGB_HSync),   //���ź�
            .RGB_VSync(RGB_VSync),   //���ź�
            .RGB_VDE(RGB_VDE),       //������Ч�ź�
            .Set_X(Set_X),           //ͼ������X
            .Set_Y(Set_Y)            //ͼ������Y
            );
    rgb2dvi_0 rgb2dvi(
         .TMDS_Clk_p(TMDS_Tx_Clk_P),
           .TMDS_Clk_n(TMDS_Tx_Clk_N),
           .TMDS_Data_p(TMDS_Tx_Data_P),
           .TMDS_Data_n(TMDS_Tx_Data_N),
           .aRst(0),
           .vid_pData(RGB_Data),
           .vid_pVDE(RGB_VDE),
           .vid_pHSync(RGB_HSync),
           .vid_pVSync(RGB_VSync),
           .PixelClk(clk_system)
    ); 
     wire [30:0]clk_mode;
     assign clk_mode='d100_000_000/Baud_Rate+1;
   clk_div clk_div_0(
        .clk(clk_100M),
        .clk_out(clk_9600)
   );
endmodule
