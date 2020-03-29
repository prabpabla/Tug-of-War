 `timescale 100ns / 1ps
 
 module pushCounter(
    input pbl,
    input pbr,
    input clk,
    input rst,
	 input speedRound,
	 input speedExit,
    output speed_tie,
    output speed_right
    );


reg[7:0] count_right, count_left;
reg right, tie;


synchronizer create_pbrSync(pbr,clk,rst,pbrSync);
synchronizer create_pblSync(pbl,clk,rst,pblSync);

opp createPBR_pulse(pbrSync,clk,rst,PBR_pulse);
opp createPBL_pulse(pblSync,clk,rst,PBL_pulse);

always@(posedge clk or posedge rst)
begin
	if(rst)count_left<=0;
	else if(speedExit)count_left<=0;
	else if(PBL_pulse & speedRound) count_left <= count_left+1;
	else count_left <= count_left;
end

always@(posedge clk or posedge rst)
begin
	if(rst)count_right<=0;
	else if(speedExit)count_right<=0;
	else if(PBR_pulse & speedRound) count_right <= count_right+1;
	else count_right <= count_right;
end

always@(posedge clk)
begin
	if(count_right > count_left) begin right=1; tie=0;end
	else if(count_right == count_left)begin right=0; tie=1;end
	else begin right=0; tie=0;end
end

assign speed_right = right;
assign speed_tie = tie;

endmodule