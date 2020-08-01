`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/30 09:07:13
// Design Name: 
// Module Name: VGA
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 14:54:23
// Design Name: 
// Module Name: vga_out
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


module vga_out( 
    input button,
    input button2,
    input clk, 
    input RGB_VDE, 
    input [11:0]Set_X, 
    input [11:0]Set_Y, 
    output reg[23:0]RGB_Data=24'hffff00    //RBG 
    ); 
    localparam
    Piccar_H=100,
    Piccar_V=100,
    Picufo_H=100,
    Picufo_V=100;
    
    wire clk_1S;
    wire clk_20S;
    
    reg [12:0]Piccar_LB = 700-Piccar_H/2;//car图片的左边
    reg [12:0]Piccar_RB = 700+Piccar_H/2;//car图片的右边
    reg [12:0]Piccar_UB = 550-Piccar_V/2;//car图片的上边
    reg [12:0]Piccar_DB = 550+Piccar_V/2;//car图片的下边
    
    reg [12:0]Picufo_LB = 1800;//ufo图片的左边
    reg [12:0]Picufo_RB = 1900;//ufo图片的右边
    reg [12:0]Picufo_UB = 500;//ufo图片的上边
    reg [12:0]Picufo_DB = 600;//ufo图片的下边
    
        wire [7:0]p_Data;
        wire [7:0]u_Data;
   
    
    
    reg [14:0]Address0=0; //car的地址

    reg [14:0]Address1=0; //ufo的地址

    reg bl1,bs1,bl2,bs2;//按键按下的信号
    
    reg Piccar_area;//判断car显示的位置
    reg Picufo_area;//判断ufo显示的位置
    
    reg crash=0; //碰撞判定
    reg crashrst=1; //碰撞解除
    /************************按键代码***************************/	
            reg[19:0] timer;    //定时10ms,按键扫描
            //测量按键按下的时间长度,区分长按和短按
            //三种模式：大于20ms小于1s为短按,大于1s小于2s为中长按,2s以上为长按
            //根据实际情况而定
            reg[31:0] count2;    
            reg new_key2;  //新扫描按键电平
            reg last_key2; //旧扫描按键电平
            wire flag_up2; //上升沿检测标志
            
            reg[31:0] count1;    
            reg new_key1;  //新扫描按键电平
            reg last_key1; //旧扫描按键电平
            wire flag_up1; //上升沿检测标志
        /*
        **    10ms按键扫描一次
        */    
        always @(posedge clk )
            begin
                if (timer == 20'd499_999)
                    begin
                        timer <= 20'd0;
                        new_key2 <= button2;
                        new_key1 <= button;
                    end
                else
                    timer <= timer +1'b1;
            end
        /*
        ** 按键状态保存一个时钟周期    
        */
        always @(posedge clk)
            begin
                last_key2 <= new_key2;
                last_key1 <= new_key1;
            end
         
        assign flag_up2 = (~last_key2) & new_key2;        //检测按键松开产生的上升沿
        assign flag_up1 = (~last_key1) & new_key1;        //检测按键松开产生的上升沿
         
        /*
        **    count计数,测量按键按下时间长度
        */
        always @(posedge clk )
            begin 
                if (new_key2 == 0)
                    count2 <= count2 +1'b1;
                else if (new_key2 == 1)
                    count2 <= 32'd0;
                if (new_key1 == 0)
                    count1 <= count1 +1'b1;
                else if (new_key1 == 1)
                    count1 <= 32'd0;
            end
        /*
        **    根据按键按下时间的长短进行相应的动作
        */
        always @(posedge clk)
            begin 
                if (flag_up2 == 1)
                    begin
                        if (count2 >= 32'd49_999_999)
                            bl2 = 1;        //按下时间超过1s且小于2s
                        else if (count2 >= 32'd999_999)
                            bs2 = 1;        //短按
                    end
                else if (flag_up1 == 1)
                    begin
                        if (count1 >= 32'd49_999_999)
                            bl1 = 1;        //按下时间超过1s且小于2s
                        else if (count1 >= 32'd999_999)
                            bs1 = 1;        //短按
                    end
                else begin
                    bl1 <= 0;
                    bs1 <= 0;
                    bl2 <= 0;
                    bs2 <= 0;
                end
            end
     /*******************************随机数产生*********************/
              reg [7:0]rand_num=8'b1111_1111;
              always @(posedge clk_1S)
             begin
                             rand_num[0] <= rand_num[7];
                             rand_num[1] <= rand_num[0];
                             rand_num[2] <= rand_num[1];
                             rand_num[3] <= rand_num[2];
                             rand_num[4] <= rand_num[3]^rand_num[7];
                             rand_num[5] <= rand_num[4]^rand_num[7];
                             rand_num[6] <= rand_num[5]^rand_num[7];
                             rand_num[7] <= rand_num[6];                     
             end
        always@(posedge clk)begin    
                
                     if(Piccar_area)begin
                            Address0=(Set_X-Piccar_LB)+(Set_Y-Piccar_UB)*Piccar_H;
                            end
                            else if(Picufo_area)begin
                             Address1=(Set_X-Picufo_LB)+(Set_Y-Picufo_UB)*100; 
                     end
                              
          end
     /*******************************根据随机数确定ufo纵坐标位置*********************/
          reg [3:0]ufoXC = 1'b0;

       //UFO的横坐标计数器
          always@(posedge clk_1S)begin
             if(ufoXC==0)
               begin
                  case( rand_num[0]+rand_num[6])
                  0:begin Picufo_UB<=400;Picufo_DB<=500; end
                  1:begin Picufo_UB<=500;Picufo_DB<=600; end 
                  2:begin Picufo_UB<=600;Picufo_DB<=700; end
                  endcase
                 end
                end   
  /*******************************分频*********************/
                div div(.clk_out(clk_1S),.clk(clk),.rst_n(1));
                div2 div2(.clk_out(clk_20S),.clk(clk_1S),.rst_n(1));
         always@(posedge clk_1S)begin
             if(crash==0)
                    begin
                    if(ufoXC>=0&&ufoXC<7) ufoXC<=ufoXC+1'b1;
                    else ufoXC <= 0;
                    end 
                    else if(crash==1) ufoXC <= 7;             
              end
     /***************************ufo移动*******************************/
          reg [3:0]accelerate=0;
          always@(posedge clk_20S)begin
             accelerate <= accelerate + 1;
           end 
          always@(posedge clk_1S)begin
             Picufo_LB <= 1800 - ((150+(50*accelerate)) * ufoXC);
             Picufo_RB <= 1900 - ((150+(50*accelerate)) * ufoXC);
            end
     
     /***************************飞机移动以及按键*******************************/
            reg up;
            reg down;
            reg [20:0] i1;   //???
            reg [1:0]car_y=2'b01;
            

    
    always@(posedge clk)begin
    
          Piccar_LB = 700-Piccar_H/2;
          Piccar_RB = 700+Piccar_H/2;
          Piccar_UB = 550-Piccar_V/2;
          Piccar_DB = 550+Piccar_V/2;

          if(bs2)begin
                    crashrst<=0;
                    if(car_y==2)
                        car_y=car_y;
                    else  car_y=car_y+1;   
                end              
          else if(bs1) begin
                     crashrst<=0;
                     if(car_y==0)
                           car_y=car_y;
                     else  car_y=car_y-1;   
                 end 
     /* end 
           
       always@(posedge clk)begin */
           if(car_y==1)begin
               Piccar_UB <= Piccar_UB;
               Piccar_DB <= Piccar_DB;
           end
           else if(car_y==0)begin
               Piccar_UB <= Piccar_UB-100;
               Piccar_DB <= Piccar_DB-100;
           end
           else if(car_y==2)begin
               Piccar_UB <= Piccar_UB+100;
               Piccar_DB <= Piccar_DB+100;
           end
       end
    
     /***************************碰撞判定*******************************/
              always@(posedge clk)begin
                if(ufoXC==7&&Picufo_UB==Piccar_UB&&Picufo_DB==Piccar_DB)        
                      crash<=1;
                      else crash<=0;
                  end
    
    
     /**********************************显示区域********************************控制1080*1920，判断那块区域是不是显示图片位置*/
        always@(posedge clk)begin   //显示区域
          Piccar_area = (Set_X >= (Piccar_LB) && Set_X < (Piccar_RB) && Set_Y >= Piccar_UB && Set_Y < Piccar_DB); 
           Picufo_area = (Set_X >= (Picufo_LB) && Set_X < (Picufo_RB) && Set_Y >= Picufo_UB && Set_Y < Picufo_DB); 
        end
 /*******************************vga信号输出*********************/
    always@(posedge clk) 
        begin 
            if(Piccar_area) 
                RGB_Data<={p_Data,p_Data,p_Data};
            else  if(Picufo_area) 
                RGB_Data<={u_Data,u_Data,u_Data};
            else RGB_Data<=24'hffffff;  
        end 

  
  
  
     plane_rom   plane(
                           .clka(clk), // input wire clka
                           .ena(1), // input wire ena
                           .addra(Address0), // input wire [13 : 0] addra
                           .douta(p_Data) // output wire [23 : 0] douta
                          );
     
     ufo_rom   ufo(
                           .clka(clk), // input wire clka
                           .ena(1), // input wire ena
                           .addra(Address1), // input wire [13 : 0] addra
                           .douta(u_Data) // output wire [23 : 0] douta
                          );  
    endmodule 
    
    
 