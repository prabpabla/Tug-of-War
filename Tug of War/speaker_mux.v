`timescale 1ns / 1ps

module sound_mux(speaker,sound_control,clk,rst);

   wire music_1; 
   input [1:0] sound_control;
	input clk,rst;
	wire music_2;
	wire music_3;
	output reg  speaker;
	
	
music_losing creatLosing(clk, music_3,rst);
music_winning creatWinning(clk, music_2,rst);
music_Victory creatVict(clk, music_1 , rst );
 
always @(sound_control or music_1 or music_2 or music_3 or speaker) begin

	case(sound_control)
		2'b00: speaker = 0;// speaker is off 
		2'b01: speaker = music_2;//winning round
		2'b10: speaker = music_3;//losing round
		2'b11: speaker = music_1;//victory or winning game 
		default: speaker = 0;
	endcase
end

endmodule
