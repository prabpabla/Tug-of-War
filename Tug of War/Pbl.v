`timescale 1ns / 1ps
module PBL( pbl,pbr,rst,clear,tie,push,right );
	//input variables
	input pbr;
	input pbl;
	input rst;
	input clear;
	//output variables
	output push;
	output tie;
	output right;

	//at 1st AND gate
	wire trigger_G;
	wire trigger_H;
	//Output
	wire G;
	wire H;
	//at OR gate
	wire G_or;
	wire H_or;

	assign trigger_G = (pbl & ~H);
	assign trigger_H = (pbr & ~G);
	assign G_or =(trigger_G | G);
	assign H_or =(trigger_H | H);
	assign G = (~(rst|clear) & G_or) ;
	assign H =(~(rst|clear) & H_or);
	assign tie = H&G;//if a tie
	assign push= (H|G)&(~tie);//button pushed
	assign right=H;

endmodule 