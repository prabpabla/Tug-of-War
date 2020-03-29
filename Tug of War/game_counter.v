`timescale 1ns / 1ps

module game_counter(rw,wingame,clk,rst,game_LED,over,winright);

    input rw,wingame,clk,rst;
    wire sy_LW,sy_RW,opp_LW,opp_RW;
    reg [1:0]  counterL,counterR;
	 reg [1:0]  nextL,nextR;
    output wire [6:0] game_LED;
	 output reg over;
	 output reg winright;
	 wire lw;
	 assign lw=~rw&wingame;
	 
	 synchronizer lwsy(lw,clk,rst,sy_LW); 
	 synchronizer rwsy(rw,clk,rst,sy_RW); 
	 opp opplw(sy_LW, clk, rst, opp_LW);
	 opp opprw(sy_RW, clk, rst, opp_RW);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
	        counterL<=2'b00;
		     counterR<=2'b00;
	     end else if(~over)   begin
	        counterL<=nextL;
		     counterR<=nextR;
	     end else begin
		     counterL<=counterL;
			  counterR<=counterR;
			  end
    end
    
    always @(opp_LW or opp_RW or counterL or counterR)begin
	     nextL=counterL;
		  nextR=counterR;
	     if (opp_LW)nextL=counterL+1;
		  else if(opp_RW)nextR=counterR+1;
	 end
	 
	 always @(counterL or counterR) begin
	     if(&counterL ) begin over=1;winright=0;end
		  else if(&counterR) begin over=1;winright=1;end				
		  else begin over=0;winright=0; end
	 end
	 
	 assign game_LED[4] = counterL[0] | counterL[1];
	 assign game_LED[5] = counterL[1];
	 assign game_LED[6] =(counterL[0]&counterL[1]);
	 assign game_LED[3] = 1;
	 assign game_LED[0] =(counterR[0]&counterR[1]);
	 assign game_LED[1] = counterR[1];
	 assign game_LED[2] = counterR[0] | counterR[1];
	
endmodule