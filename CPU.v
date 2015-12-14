`timescale 1ns / 1ps

module CPU(
	input clk,
	input enable,
	input reset,
	input [3:0] SW,
	input start,
	input button,
	output [6:0] light,
	output [3:0] en
    );

	wire PCPU_clk;
	wire MEM_clk;
	wire LIGHT_clk;
	
	wire [15:0] d_datain;
	wire [15:0] i_datain;
	wire [3:0] select_y;
	wire [7:0] d_addr;
	wire [15:0] d_dataout;
	wire d_we;
	wire [7:0] i_addr;
	wire [15:0] y;
	
	clk_div getMEMclk(
		.orgin_clk(clk),
		.reset(reset),
		//.div(16'b0100_0000_0000_0000),
		.div(16'b0000_0000_0000_0001),
		.div_clk(MEM_clk)
	);
	
	clk_div getLIGHTclk(
		.orgin_clk(clk),
		.reset(reset),
		.div(16'b0010_0000_0000_0000),
		.div_clk(LIGHT_clk)
	);
	
	PCPUcontroller PCPUctrl(
		.myclk(clk),
		.button(button),
		.reset(reset),
		.sense(PCPU_clk)
	);
	
	PCPU pcpu(
		.clock(PCPU_clk),
		.enable(enable),
		.reset(reset),
		.start(start),
		.d_datain(d_datain),
		.i_datain(i_datain),
		.select_y(SW),
		.d_addr(d_addr),
		.d_dataout(d_dataout),
		.d_we(d_we),
		.i_addr(i_addr),
		.y(y)
	);
	
	I_mem i_mem(
		.mem_clk(MEM_clk),
		.addr(i_addr),
		.rdata(i_datain)
	);
	
	D_mem d_mem(
		.mem_clk(MEM_clk),
		.dwe(d_we),
		.addr(d_addr),
		.wdata(d_dataout),
		.rdata(d_datain)
	);
	
	light_show show_light(
		.light_clk(LIGHT_clk),
		.reset(reset),
		.y(y),
		.light(light),
		.en(en)
	);

endmodule
