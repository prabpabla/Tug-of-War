`timescale 1ns / 1ps
module mc(winrnd,wingame,over,start_button,score_button,slowen256,rand, randFake, randSpeed,clk,rst,speed_exit,winspeed,speed_round,leds_on,clear,led_control,fake,update,sound_shut_down,sound_control,slowen1024);

input winrnd,wingame,over,slowen1024;
input slowen256;
input rand;
input clk;
input rst;
input randFake; //for fake state
input randSpeed; //for speed round
input winspeed; //turn off speed_round\
input speed_exit;
input start_button;
input score_button;
output reg speed_round,sound_shut_down;
output reg leds_on;
output reg clear;
output reg [3:0] led_control;
output reg [1:0] sound_control;
output reg fake;
output reg update;
wire fake_timeout; //high after designated wait time
reg [2:0] slowen_count; //counts slowen
reg [3:0] state, next_state;

parameter reset=0, wait_a=1, wait_b=2, dark=3,play=4,gloat_a=5,gloat_b=6, ERROR=16, fake_play=8, speed_play=9, speed_play_display=10,idle=11,resetgame_updatescore=12,victory=13,displaygamescore=14,lose_gloat_a=15,lose_gloat_b=7;
//parameter reset=0, idle=1,wait_a=2, wait_b=3, dark=4,play=5,fake_play=6, speed_play=7,ERROR=8,speed_play_display=9,gloat_a=10,gloat_b=11,gloat_c=12,gloat_d=13,lose_gloat_a=14,lose_gloat_b=15,lose_gloat_c=16,lose_gloat_d=17,resetgame_updatescore=18,victory=19,displaygamescore=20;
always @(posedge clk or posedge rst) begin
	if(rst)  state <= reset;
	
	else state <= next_state;
end
//*********CREATING FAKE timeout*****************//
always @(posedge slowen256 or posedge rst ) begin
 //Complete code here so that fake_timeout is high after 2 seconds ??????
  if (rst) slowen_count<=0;
  else if(fake) slowen_count<=slowen_count+1;
  else slowen_count<=0;
end
assign fake_timeout = slowen_count[2]&~slowen_count[1]&~slowen_count[0];
//******************************************//

always @(state or winrnd or slowen256 or rand or rst or randFake or randSpeed or winspeed or speed_exit or fake_timeout or  start_button or wingame or over or score_button)begin //some signals missing in always block sensitivity list  ???????
    next_state=state;
	 case(state)
	   reset:if(~rst) next_state=idle;
		idle:if(start_button) next_state=wait_a;else if(score_button & ~start_button) next_state=displaygamescore;
	   wait_a:if(slowen256) next_state=wait_b;
      wait_b:if(slowen256) next_state=dark;
	   dark:if(slowen256&randFake&~rand) next_state = fake_play;
	        else if(slowen256&randSpeed&~rand&~randFake) next_state=speed_play;
		     else if (slowen256&rand) next_state=play;
		     else if(winrnd) next_state=lose_gloat_a;
	   play:if(winrnd)  next_state=gloat_a;
	   fake_play:if(winrnd&~fake_timeout) next_state=lose_gloat_a;
	             else if (fake_timeout) next_state=dark;
      speed_play:if(winspeed) next_state=speed_play_display;
	   speed_play_display:if(speed_exit) next_state=gloat_a;
	   gloat_a:if(slowen256) next_state=gloat_b;
		gloat_b:if(slowen256&~wingame) next_state=wait_b;else if(slowen256&wingame) next_state=resetgame_updatescore;
	  //gloat_b:if(slowen256) next_state=gloat_c;
	  //gloat_c:if(slowen256) next_state=gloat_d;
	  lose_gloat_a:if(slowen256) next_state=lose_gloat_b;
	  lose_gloat_b:if(slowen256&~wingame) next_state=wait_b;else if(slowen256&wingame) next_state=resetgame_updatescore;
	  //lose_gloat_c:if(slowen256) next_state=lose_gloat_d;
	  //lose_gloat_d:if(slowen256&~wingame) next_state=wait_b;else if(slowen256&wingame) next_state=resetgame_updatescore;
	   
		resetgame_updatescore:if(slowen256&~over) next_state=idle;else if (slowen256&over) next_state=victory;
		victory:next_state=victory;
		displaygamescore:if(score_button) next_state=idle;
	   ERROR: next_state = reset; 
	   default: next_state = reset;
	endcase
end

//output 
always @(state)
	case(state)
	   reset:     begin leds_on = 1; clear = 1; led_control = 4'b0001; fake = 0; speed_round = 0;update=0; sound_shut_down=0;sound_control=2'b00;end
		wait_a:    begin leds_on = 1; clear = 1; led_control = 4'b0010; fake = 0; speed_round = 0;update=0;sound_shut_down=0;sound_control=2'b00;end
		wait_b:    begin leds_on = 1; clear = 1; led_control = 4'b0010; fake = 0; speed_round = 0;update=0; sound_shut_down=0;sound_control=2'b00;end
		dark:      begin leds_on = 0; clear = 0; led_control = 4'b0000; fake = 0; speed_round = 0;update=0; sound_shut_down=0; sound_control=2'b00;end
		play:      begin leds_on = 1; clear = 0; led_control = 4'b0011; fake = 0; speed_round = 0;update=0;sound_shut_down=0;sound_control=2'b00;end
		fake_play: begin leds_on = 1; clear = 0; led_control = 4'b0100; fake = 1; speed_round = 0;update=0;sound_shut_down=0;sound_control=2'b00; end
		speed_play:begin leds_on = 1; clear = 1; led_control = 4'b0110; fake = 0; speed_round = 1;update=0; sound_shut_down=0;sound_control=2'b00;end
		speed_play_display: begin leds_on = 1; clear = 1; led_control = 4'b0110; fake = 0; speed_round = 0;update=0; sound_shut_down=0; sound_control=2'b00;end
		gloat_a:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b01;end
		gloat_b:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b01;end
	   //gloat_c:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b01;end
		//gloat_d:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b01;end
		lose_gloat_a:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b10;end
		lose_gloat_b:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b10;end
	   //lose_gloat_c:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b10;end
		//lose_gloat_d:   begin leds_on = 1; clear = 1; led_control = 4'b0011; fake = 0; speed_round = 0;update=0; sound_shut_down=1;sound_control=2'b10;end
		idle:      begin leds_on = 1; clear = 1; led_control = 4'b0101; fake = 0; speed_round = 0;update=0;  sound_shut_down=0;sound_control=2'b00;end
		resetgame_updatescore:begin leds_on=0;  clear = 1; led_control = 4'b0000; fake = 0; speed_round = 0;update=1;sound_shut_down=1;sound_control=2'b11;end
		victory:   begin leds_on=1;clear=1;led_control=4'b1000;fake = 0; speed_round = 0;update=0;sound_shut_down=1;sound_control=2'b11;end
		displaygamescore:begin leds_on=1;clear=1;led_control= 4'b0111;fake = 0; speed_round = 0;update=0;sound_shut_down=0; sound_control=2'b00;end
		ERROR:     begin leds_on = 1; clear = 1; led_control = 4'b0001; fake = 0; speed_round = 0;update=0;sound_shut_down=0; sound_control=2'b00;end
		default:   begin leds_on = 1; clear = 1; led_control = 4'b0001; fake = 0; speed_round = 0;update=0;sound_shut_down=0;  sound_control=2'b00;end
	endcase
endmodule