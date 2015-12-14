`timescale 1ns / 1ps

module PCPUcontroller(
	input myclk,
	input button,
	input reset,
	output reg sense
    );

	parameter STOP = 2'b00, INC = 2'b01, TRAP = 2'b10;
	
	reg [1:0] state, nextstate;
	
	always@(posedge myclk or posedge reset)
	begin
		if(reset)
			state <= STOP;
		else
			state <= nextstate;
	end
	
	always@(*)
	begin
		case(state)
			STOP:
				if(button)	nextstate <= INC;
				else			nextstate <= STOP;
			INC:				nextstate <= TRAP;
			TRAP:
				if(button)	nextstate <= TRAP;
				else			nextstate <= STOP;
			default:			nextstate <= STOP;
		endcase
	end
	
	always@(*)
	begin
		if(reset)
			sense <= 0;
		else
			case(state)
				INC:		sense <= 1'b1;
				default:	sense <= 1'b0;
			endcase
	end

endmodule
