`timescale 1ns / 1ps

module led_mux(score, vict_leds ,led_control, fake_score, speed_led, game_LED, leds_out);

    input wire [6:0] score; 
	 input wire [6:0] fake_score;
	 input wire [6:0] speed_led;
	 input wire [3:0] led_control;
	 input wire [6:0] vict_leds;
	 input wire [6:0] game_LED;
	 output reg [6:0] leds_out;
 
always @(led_control or score or fake_score or speed_led or game_LED or vict_leds) begin

	case(led_control)
		4'b0000: leds_out = 7'b0000000; 
		4'b0001: leds_out = 7'b0010101;//RESET
		4'b0010: leds_out = 7'b1111111;//all on - wait states
		4'b0011: leds_out = score; //round score
		4'b0100: leds_out = fake_score;
		4'b0101: leds_out = 7'b0101010;//idle state
		4'b0110: leds_out = speed_led;
		4'b0111: leds_out = game_LED; //total game score
		4'b1000: leds_out = vict_leds;
		default: leds_out = 7'b0000000;
		
	endcase
end

endmodule
