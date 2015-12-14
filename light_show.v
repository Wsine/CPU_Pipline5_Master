`timescale 1ns / 1ps

module light_show(
	input light_clk,
	input reset,
	input [15:0] y,
	output reg [6:0] light,
	output reg [3:0] en
    );

	reg [1:0] dp;
	reg [3:0] four;

	always@(posedge light_clk or posedge reset)
	begin
		if(reset)
			dp <= 0;
		else
		begin
			dp <= dp + 1'b1;
		end
	end
	
	always@(*)
	begin
		if(reset)
		begin
			four <= 0;
			en <= 0;
		end
		else
		begin
			case(dp)
				0:			begin four <= y[3:0]; en <= 4'b1110; end
				1:			begin four <= y[7:4]; en <= 4'b1101; end
				2:			begin four <= y[11:8]; en <= 4'b1011; end
				3:			begin four <= y[15:12]; en <= 4'b0111; end
				default:	begin four <= 0; en <= 0; end
			endcase
		end
	end
	
	always@(*)
	begin
		if(reset)
		begin
			light <= 7'b0001000;
		end
		else
		begin
			case(four)
				0:				light <= 7'b0000001;
				1:				light <= 7'b1001111;
				2:				light <= 7'b0010010;
				3:				light <= 7'b0000110;
				4:				light <= 7'b1001100;
				5:				light <= 7'b0100100;
				6:				light <= 7'b0100000;
				7:				light <= 7'b0001111;
				8:				light <= 7'b0000000;
				9:				light <= 7'b0000100;
				4'b1010:		light <= 7'b0001000;
				4'b1011:		light <= 7'b1100000;
				4'b1100:		light <= 7'b0110001;
				4'b1101:		light <= 7'b1000010;
				4'b1110:		light <= 7'b0110000;
				4'b1111:		light <= 7'b0111000;
				default:		light <= 7'b0000001;
			endcase
		end
	end

endmodule