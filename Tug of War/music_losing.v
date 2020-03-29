`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:52:06 04/04/2015 
// Design Name: 
// Module Name:    music_losing 
// Project Name: 
// Target Devices: 
// Tool versions: 
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

module music_losing(clk,music_3,rst);
input clk,rst;
output music_3;
parameter clkdivider = 10000000/440/2;
reg [14:0] counter;
reg [23:0] tone;


reg music_3;


always @(posedge clk or posedge rst) 
begin
	if(rst)begin
	counter <= 0;
	music_3 <= 0;
	tone<=0;
end

else if(counter==0) 
begin 
	counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1); 
	music_3 <= ~music_3;
	tone <= tone+1;
end

else 
begin
	counter <= counter-1;
	tone <= tone+1;
end
end
endmodule
