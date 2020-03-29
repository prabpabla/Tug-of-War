`timescale 1ns / 1ps


module music_winning(clk,music_2,rst);
input clk,rst;
output music_2;
parameter clkdivider = 100000000/440/2;
reg [14:0] counter;
reg [23:0] tone;


reg music_2;


always @(posedge clk or posedge rst) 
begin
	if(rst)begin
	counter <= 0;
	music_2 <= 0;
	tone<=0;
end

else if(counter==0) 
begin 
	counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1); 
	music_2 <= ~music_2;
	tone <= tone+1;
end

else 
begin
	counter <= counter-1;
	tone <= tone+1;
end
end
endmodule
