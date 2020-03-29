`timescale 1ns / 1ps
module opp( synchronous_push, clk, rst, winrnd);
  
   input synchronous_push;		// All input variable declarations
	input clk;
	input rst;
	
	output winrnd;		// out declaration
	reg b;				//value stored in the register
	
	always @ (posedge clk or posedge rst)		//flip flop is at a positive clock edge or positive edge reset
		begin
		if(rst)           //on reset 
		begin
			b <= 0;					// b is assigned to 0 if at reset
		end
		else 
		begin
			b <= synchronous_push;  //else b is assigned to the sypush
		end
	end
	
	assign winrnd = ~b & synchronous_push;  

endmodule 