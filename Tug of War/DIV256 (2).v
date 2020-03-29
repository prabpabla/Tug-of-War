`timescale 1ns/1ns
module div256(clk,rst,slowen256,slowen64,slowen1024);

input clk;
input rst;
output slowen256,slowen1024,slowen64;

reg [9:0]counter,next;

always @(posedge clk or posedge rst)
	begin
		if(rst)begin           		
		  counter <= 0; 
		end	else  begin 
		  counter <= next;
		end
	end
always @(counter)begin
    next=counter+1;
end
assign slowen64  = counter[5]&counter[4]&counter[3]&counter[2]&counter[1]&counter[0];
assign slowen256 = counter[7]&counter[6]&counter[5]&counter[4]&counter[3]&counter[2]&counter[1]&counter[0];
assign slowen1024 = &counter;


endmodule