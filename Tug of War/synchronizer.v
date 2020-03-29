`timescale 1ns / 1ps
module synchronizer(push,clk,rst,synchronous_push); 

	input push, clk, rst;	
	output synchronous_push;				
	reg temp;
	
	//flip flop is at a positive clock edge or positive edge reset
	always @ (posedge clk or posedge rst)begin
		if(rst)temp <= 0;
		else temp <= push;
	end
	//assiging the synchronous_pushpush to the temp value
	assign synchronous_push = temp; 
endmodule
