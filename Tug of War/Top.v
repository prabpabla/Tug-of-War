`timescale 1ns / 1ps
module top(winrnd,pbl,pbr,rst,clk,clear,right,tie);
	output winrnd,right,tie;
	input pbl,pbr,rst,clk,clear;
	
	wire push,synchronous_push;
	
	
	PBL PBLinst (pbl,pbr,rst,clear,tie,push,right );// .right(right),
	synchronizer synchronizerinst (push,clk,rst,synchronous_push);
	opp OPPinst ( synchronous_push, clk, rst, winrnd );
	
endmodule 