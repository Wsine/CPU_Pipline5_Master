`timescale 1ns / 1ps

module clk_div(
	input orgin_clk,
	input reset,
	input [15:0] div,
	output reg div_clk
    );
	
	reg [15:0] count;
	
	always@(posedge orgin_clk or posedge reset)
	begin
		if(reset)
		begin
			div_clk <= 0;
			count <= 0;
		end
		else
		begin
			if(count == div)
			begin
				div_clk <= ~div_clk;
				count <= 0;
			end
			else
				count <= count + 1'b1;
		end
	end


endmodule
