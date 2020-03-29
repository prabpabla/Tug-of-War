`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:30:06 03/30/2011 
// Design Name: 
// Module Name:    speed_controller 
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
module speed_controller(clk,rst,slowen256, 
slowen1024,
slowen64,
speed_round,
speed_tie,
speed_right,
speed_led,
winspeed,
speed_exit);
//********STATES****************//
	
	`define WAIT  1
   `define count7  2
	`define count6  3
	`define count5   4
	`define count4  5
	`define count3  6
	`define count2  7
	`define count1  8 
	`define count0  9
	`define win_display  10
	`define display_dark  11
	`define FINISH  12
	`define ERROR  13
	


//********INPUTS/OUTPUTS********//
input clk;
input rst;
input slowen256;
input slowen64; // pulse 4 times faster than slowen (64 vs 256)
input slowen1024; // pulse 4 times slower than slowen (1024 vs. 256)
input speed_round; // input from MC to say we're in speed round (exit wait state)
input speed_tie; //from pushcounter - if tie occured in speed round
input speed_right; //from speedright - if right won in speed round
output reg [6:0] speed_led; //led output for speedround
reg speed_finish; //sent to an OPP module to make 1 pulse
output winspeed; // came from the OPP module, 
     				  //1 pulse long version of speed_finish indicates round over
output reg speed_exit; //says when the full round is done including display winner

//**********INTERNAL COMPONENTS************//

reg [3:0] state;
reg [3:0] next_state;

//***********SYNCHRONOUS STATE ASSIGNMENT****//

always @(posedge clk or posedge rst) begin
   		if (rst) state <= `WAIT;
   		else state <= next_state;
		end

//**********STATE MACHINE**********//


always @(slowen256 or slowen64 or slowen1024 or state or speed_round)begin
	case(state)
	`WAIT: 	if(speed_round) next_state = `count7; else next_state = `WAIT;	
	`count7: if(slowen256) next_state = `count6; else next_state = `count7;	
	`count6: if(slowen256) next_state = `count5; else next_state = `count6;	
	`count5: if(slowen256) next_state = `count4; else next_state = `count5;	
	`count4: if(slowen256) next_state = `count3; else next_state = `count4;	
	`count3: if(slowen256) next_state = `count2; else next_state = `count3;	
	`count2: if(slowen256) next_state = `count1; else next_state = `count2;	
	`count1: if(slowen256) next_state = `count0; else next_state = `count1;	
	`count0: if(slowen1024) next_state = `win_display; else next_state = `count0;	
	`win_display: if(slowen64) next_state = `display_dark; else next_state= `win_display;//slowen64 and 1024 creates flashing winning display
	`display_dark: if(slowen64&~slowen1024) next_state = `win_display;
						else if(slowen1024) next_state = `FINISH;
						else next_state = `display_dark;
	`FINISH: if(slowen256) next_state = `WAIT; else next_state = `FINISH;
	`ERROR: next_state = `WAIT;
	endcase
end

//output
always @(state or speed_right or speed_tie) begin
	case(state)
		`WAIT: 			begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0000000; end
		`count7: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b1111111;end
		`count6: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0111111;end
		`count5: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0011111;end
		`count4: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0001111;end
		`count3: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0000111;end
		`count2: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0000011;end
		`count1: 		begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0000001;end
		`count0: 		begin speed_finish = 1; speed_exit = 0; speed_led = 7'b0000000;end
		`win_display: 	begin speed_finish = 0; speed_exit = 0; //speed_finish goes to create winspeed
								if(speed_right)speed_led = 7'b0000111; //right wins
								else if(speed_tie) speed_led = 7'b1110111; //tie
								else speed_led = 7'b1110000; //left wins
							end
		`display_dark:	begin speed_finish = 0; speed_exit = 0; speed_led = 7'b0000000;end
		`FINISH:			begin speed_finish = 0; speed_exit = 1; speed_led = 7'b0000000;end
		`ERROR:			begin speed_finish = 0; speed_exit = 0; speed_led = 7'b1010101;end

	endcase

end

opp createWINSPEED(speed_finish,clk,rst,winspeed); //create winspeed








endmodule
