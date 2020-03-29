`timescale 1ns / 1ps

module tow(
    input pbr,
    input pbl,
    input CLK_I,
	 input scorbut,
    input rst,
	 input st,
	 output speaker,
	 output gain,
    output [6:0] Led,
	 output sound_shut_down
    );
//Complete wire signals needed below ???

wire winrnd,clk,clear,right,tie,start_bottom,score_button,wingame,rw,winright,over,sy_sc;
wire leds_on,fake,speed_tie,speed_right,winspeed,update;
wire slowen256,slowen1024,slowen64,speed_round;
wire rand,randFake,randSpeed,speed_exit;
wire [6:0] score,fake_score,leds_out,speed_led, game_LED,vict_leds;
wire [3:0] led_control;
wire [1:0] sound_control;
//Slower Clock from 100Mhz to 500Hz -Given DO NOT remove 
clk_div createCLKdivide(.CLK_I(CLK_I),.rst(rst), .clk(clk));
//assign clk=CLK_I;
assign gain = 1;

//----------------------------------------------------------------------
//Instantiate PBL Sync OPP ??? 
top PSO(winrnd,pbl,pbr,rst,clk,clear,right,tie);

synchronizer sy_start(st,clk,rst,start_button);	
synchronizer sy_scorbut(scorbut,clk,rst,sy_sc);
opp OPP_sc(sy_sc, clk, rst,score_button);	

//----------------------------------------------------------------------
//Instantiate scorer Led_Mux pushCounter
scorer s(winrnd,update, right, leds_on, tie, clk, rst, fake, score, fake_score, speed_tie, speed_right, winspeed,wingame,rw);
led_mux mux(score, vict_leds ,led_control, fake_score, speed_led, game_LED, leds_out);
pushCounter pc(pbl,pbr,clk,rst,speed_round,speed_exit,speed_tie,speed_right);


//----------------------------------------------------------------------
//Div256 LFSR MC speed_controller
div256 createSLOWEN(clk,rst,slowen256,slowen64,slowen1024);
lfsr createRAND(rand,randFake,randSpeed, clk, rst);
mc createMASTERCONTROLLER(winrnd,wingame,over,start_button,score_button,slowen256,rand, randFake, randSpeed,clk,rst,speed_exit,winspeed,speed_round,leds_on,clear,led_control,fake,update,sound_shut_down,sound_control,slowen1024);
speed_controller speed_controller(clk,rst,slowen256, slowen1024,slowen64,speed_round,speed_tie,speed_right,speed_led,winspeed,speed_exit);
game_counter createGC(rw,wingame,clk,rst,game_LED,over,winright);
victory createVC(slowen256,clk,winright,over,rst,vict_leds);

sound_mux creatSpeaker(speaker,sound_control,CLK_I,rst);


assign Led=leds_out;

endmodule
