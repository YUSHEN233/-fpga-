`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/30 20:04:43
// Design Name: 
// Module Name: div
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


module div2(output reg clk_out,input clk,input rst_n);

reg [30:0] cnt;

always @(posedge clk or negedge rst_n)
if(!rst_n)
begin
cnt <= 31'b0;
clk_out <= 1'b0;
end
else if(cnt == 31'd9)
begin
cnt <= 31'b0;
clk_out <= ~clk_out;
end
else cnt <= cnt + 1'b1;

endmodule
