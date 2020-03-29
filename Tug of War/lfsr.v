`timescale 1ns / 1ps

module lfsr(rand,randfake,randspeed, clk, rst);

    input clk, rst;
    output rand;
	 output randfake;
	 output randspeed; 
    reg [9:0] lfsr;
	 reg [8:0] count,next_count;
	 wire one_second;
	 always @(posedge clk or posedge rst)begin
	       if(rst) count <= 0;
			 else count<=next_count;
	 end
	 always @(count) begin 
	       next_count=count+1;
	 end
	 assign one_second=&count;
    always @(posedge one_second or posedge rst)
    begin
        if(rst) lfsr [9:0] <= 1;
        else
        begin
            lfsr [8:0] <= lfsr[9:1];
            lfsr[9] <= lfsr[0]^lfsr[2];
        end
    end
	 
    assign rand = lfsr[9];
	 assign randfake = lfsr[7]|lfsr[4];
	 assign randspeed = lfsr[5]|lfsr[3];

	 
    endmodule
