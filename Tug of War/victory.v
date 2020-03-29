`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:47 03/23/2015 
// Design Name: 
// Module Name:    victory 
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
module victory(slowen256,clk,winright,over,rst,vict_leds);
	 input slowen256,clk,winright,over,rst;
	 output [6:0] vict_leds;
	 reg [6:0] states,next_states;
	 always @(posedge clk or posedge rst) begin
	     if(rst) states <= 7'b0001000;
		  else  states<=next_states;
	 end 
	 always @(states or over or winright or slowen256 ) begin	 
			    case(states)
				     7'b0001000:if(winright & over & slowen256)next_states=7'b0001111;
					             else if(~winright & over & slowen256)next_states=7'b1111000;else next_states=states;
					  7'b0001111:if(slowen256)next_states=7'b0001000;else next_states=states;
					  7'b1111000:if(slowen256)next_states=7'b0001000;else next_states=states;
					  default:next_states=7'b0001000;
				endcase
		end	
		assign vict_leds=states;


endmodule
