`timescale 1ns / 1ps

module music_Victory(clk, music_1,rst);
input clk,rst;
output music_1;

reg [27:0] tone;

wire [5:0] fullnote = tone[27:22];

wire [2:0] octave;
wire [3:0] note;

divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));
reg [8:0] clkdivider;


always @(note)
case(note)
  0: clkdivider = 271-1; // A 
  1: clkdivider = 271-1; // A#/Bb
  2: clkdivider = 271-1; // B 
  3: clkdivider = 271-1; // C 
  4: clkdivider = 271-1; // C#/Db
  5: clkdivider = 271-1; // D 
  6: clkdivider = 271-1; // D#/Eb
  7: clkdivider = 271-1; // E 
  8: clkdivider = 271-1; // F 
  9: clkdivider = 271-1; // F#/Gb
  10: clkdivider = 271-1; // G 
  11: clkdivider = 271-1; // G#/Ab
  12: clkdivider = 0; // should never happen
  13: clkdivider = 0; // should never happen
  14: clkdivider = 0; // should never happen
  15: clkdivider = 0; // should never happen
endcase
 reg [8:0] counter_note;
 reg [7:0] counter_octave;
reg music_1;


always @(posedge clk or posedge rst)
begin
	if(rst)begin
		counter_note <= 0;
		counter_octave <= 0;
		music_1 <= 0;
		tone <=0;
	end
	
	else if(counter_note==0)begin
		tone <= tone+1;
		counter_note <= clkdivider;
		if(counter_octave==0) begin
			counter_octave <= (octave==4?15:octave==3?31:octave==2?63:octave==1?127:octave==0?255:7);
			music_1 <= ~music_1;
		end
		
		else begin
			counter_octave <= counter_octave-1;
		end
	end

	else begin
	tone <= tone+1;
	counter_note <= counter_note-1;
	end
end

endmodule