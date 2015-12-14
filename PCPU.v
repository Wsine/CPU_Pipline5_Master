`timescale 1ns / 1ps
`include"headfile.v"

module PCPU(
	input clock,
	input enable,
	input reset,
	input start,
	input [15:0] d_datain,
	input [15:0] i_datain,
	input [3:0] select_y,
	output wire [7:0] d_addr,
	output wire [15:0] d_dataout,
	output wire d_we,
	output wire [7:0] i_addr,
	output reg [15:0] y
    );

	reg state;
	reg [7:0] pc;
	reg [15:0] id_ir;
	reg [15:0] ex_ir, reg_A, reg_B, smdr;
	reg [15:0] mem_ir, reg_C, smdr1; reg dw; reg flag; reg [15:0] ALUo;reg zf, nf, cf;
	reg [15:0] wb_ir, reg_C1;
	
	reg [15:0] gr[0:7];
	
	assign d_dataout = smdr1;
	assign d_we = dw;
	assign d_addr = reg_C[7:0];
	assign i_addr = pc;
	
	/*******CPUcontrol**********************/
	reg nextstate;
	
	always@(posedge clock or posedge reset)
	begin
		if(reset)
			state <= `idle;
		else
			state <= nextstate;
	end
	
	always@(*)
	begin
		case(state)
			`idle:
				if((enable == 1'b1) && (start == 1'b1))
					nextstate <= `exec;
				else
					nextstate <= `idle;
			`exec:
				if((enable == 1'b0) || (wb_ir[15:11] == `HALT))
					nextstate <= `idle;
				else
					nextstate <= `exec;
		endcase
	end
	
	/***************************************/
	
	/****************IF*********************/
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			id_ir <= 16'b0000_0000_0000_0000;
			pc <= 8'b0000_0000;
		end
		else if(state == `exec)
		begin
			/*************Hazard*******************/
			if ((id_ir[15:11]==`LOAD)
			  &&(i_datain[15:11]!=`JUMP)&&(i_datain[15:11]!=`NOP)
			  &&(i_datain[15:11]!=`HALT)&&(i_datain[15:11]!=`LOAD))
				begin
					/*********r1*********/
					if((id_ir[10:8]==i_datain[2:0])
					 &&((i_datain[15:11]==`ADD)||(i_datain[15:11]==`ADDC)
					  ||(i_datain[15:11]==`SUB)||(i_datain[15:11]==`SUBC)
					  ||(i_datain[15:11]==`CMP)||(i_datain[15:1]==`AND)
					  ||(i_datain[15:11]==`OR)||(i_datain[15:11]==`XOR)))
						begin
							pc <= pc;
							id_ir <= i_datain;
						end
					/*********r2*********/
					else if((id_ir[10:8]==i_datain[6:4])
							&&((i_datain[15:11]==`STORE)||(i_datain[15:11]==`ADD)
							 ||(i_datain[15:11]==`ADDC)||(i_datain[15:11]==`SUB)
							 ||(i_datain[15:11]==`SUBC)||(i_datain[15:11]==`CMP)
							 ||(i_datain[15:11]==`AND)||(i_datain[15:11]==`OR)
							 ||(i_datain[15:11]==`XOR)||(i_datain[15:11]==`SLL)
							 ||(i_datain[15:11]==`SRL)||(i_datain[15:11]==`SLA)
							 ||(i_datain[15:11]==`SRA)))		//r2
						begin
							pc <= pc;
							id_ir <= i_datain;
						end
					/*********r3*********/
					else if((id_ir[10:8]==i_datain[10:8])
						   &&((i_datain[15:11]==`STORE)||(i_datain[15:11]==`LDIH)
							 ||(i_datain[15:11]==`ADDI)||(i_datain[15:11]==`SUBI)
							 ||(i_datain[15:11]==`JMPR)||(i_datain[15:11]==`BZ)
							 ||(i_datain[15:11]==`BNZ)||(i_datain[15:11]==`BN)
							 ||(i_datain[15:11]==`BNN)||(i_datain[15:11]==`BC)
							 ||(i_datain[15:11]==`BNC)))
						begin
							pc <= pc;
							id_ir <= i_datain;
						end
					else
						begin
							pc <= pc + 1'b1;
							id_ir <= i_datain;
						end
				end
			/**************************************/
			else
			begin
				if(((ex_ir[15:11] == `BZ)  && (zf == 1'b1))
				 ||((ex_ir[15:11] == `BN)  && (nf == 1'b1))
				 ||((ex_ir[15:11] == `BC)  && (cf == 1'b1))
				 ||((ex_ir[15:11] == `BNZ) && (zf == 1'b0))
				 ||((ex_ir[15:11] == `BNN) && (nf == 1'b0))
				 ||((ex_ir[15:11] == `BNC) && (cf == 1'b0))
				 || (ex_ir[15:11] == `JMPR))
					begin pc <= ALUo[7:0]; id_ir <= {`NOP, 000_0000_0000}; end // Flush
				else if(id_ir[15:11] == `JUMP)
					begin pc <= id_ir[7:0]; id_ir <= {`NOP, 000_0000_0000}; end
				else if(id_ir[15:11] == `HALT) // STOP
					begin pc <= pc; id_ir <= id_ir; end
				else
					begin pc <= pc + 1'b1; id_ir <= i_datain; end
			end
		end
		else
		begin
			pc <= pc;
			id_ir <= id_ir;
		end
	end
	
	/***************************************/
	
	/****************ID*********************/
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			ex_ir <= 16'b0000_0000_0000_0000;
			reg_A <= 16'b0000_0000_0000_0000;
			reg_B <= 16'b0000_0000_0000_0000;
			smdr <= 16'b0000_0000_0000_0000;
		end
		/********Flush*********/
		else if((state == `exec) &&
				  (((ex_ir[15:11]==`BZ)&&(zf==1'b1))
				 ||((ex_ir[15:11]==`BNZ)&&(zf==1'b0))
				 ||((ex_ir[15:11]==`BN)&&(nf==1'b1))
				 ||((ex_ir[15:11]==`BNN)&&(nf==1'b0))
				 ||((ex_ir[15:11]==`BC)&&(cf==1'b1))
				 ||((ex_ir[15:11]==`BNC)&&(nf==1'b0))
				 || (ex_ir[15:11]==`JMPR)))
				 ex_ir <= {`NOP, 000_0000_0000};
		/********Flush*********/
		else if(state == `exec)
		begin
			ex_ir <= id_ir;
			//reg_A
			/********************Hazard**********************/
			if((id_ir[15:11]==`BZ)||(id_ir[15:11]==`BNZ)
			 ||(id_ir[15:11]==`BN)||(id_ir[15:11]==`BNN)
			 ||(id_ir[15:11]==`BC)||(id_ir[15:11]==`BNC)
			 ||(id_ir[15:11]==`ADDI)||(id_ir[15:11]==`SUBI)
			 ||(id_ir[15:11]==`LDIH)||(id_ir[15:11]==`JMPR))
				begin
					if(((id_ir[15:11]==`BZ)||(id_ir[15:11]==`BNZ)
					 ||(id_ir[15:11]==`BN)||(id_ir[15:11]==`BNN)
					 ||(id_ir[15:11]==`BC)||(id_ir[15:11]==`BNC))
					 &&(id_ir[10:8]==`gr0))//分支指令，基地址为0直接到偏移量地址的不会有冲突
						begin		reg_A <= gr[id_ir[10:8]];		end
					else if((id_ir[10:8]==ex_ir[10:8])
					 &&(ex_ir[15:11]!=`NOP)&&(ex_ir[15:11]!=`HALT)
					 &&(ex_ir[15:11]!=`LOAD)&&(ex_ir[15:11]!=`CMP)
					 &&(ex_ir[15:11]!=`JUMP)
					 &&(id_ir[15:0] != ex_ir[15:0]))//该行避免LOAD产生的Stall有影响
						begin		reg_A <= ALUo;		end
					else if((id_ir[10:8]==mem_ir[10:8])
							&&(mem_ir[15:11]!=`NOP)&&(mem_ir[15:11]!=`HALT)
							&&(mem_ir[15:11]!=`CMP)&&(mem_ir[15:11]!=`JUMP))
						begin
							if(mem_ir[15:11]==`LOAD)	reg_A <= d_datain;
							else								reg_A <= reg_C;
						end
					else if((id_ir[10:8]==wb_ir[10:8])
						   &&(wb_ir[15:11]!=`NOP)&&(wb_ir[15:11]!=`HALT)
							&&(wb_ir[15:11]!=`CMP)&&(wb_ir[15:11]!=`JUMP)
							&&(id_ir[15:11] != wb_ir[15:11]))//该行避免同指令的无效位冲突
						begin		reg_A <= reg_C1;		end
					else
						begin		reg_A <= gr[id_ir[10:8]];		end	//r1
				end
			else if((id_ir[15:11]==`LOAD)||(id_ir[15:11]==`STORE)
					||(id_ir[15:11]==`ADD)||(id_ir[15:11]==`ADDC)
					||(id_ir[15:11]==`SUB)||(id_ir[15:11]==`SUBC)
					||(id_ir[15:11]==`CMP)||(id_ir[15:11]==`AND)
					||(id_ir[15:11]==`OR)||(id_ir[15:11]==`XOR)
					||(id_ir[15:11]==`SLL)||(id_ir[15:11]==`SRL)
					||(id_ir[15:11]==`SLA)||(id_ir[15:11]==`SRA))
				begin
					if((id_ir[6:4]==ex_ir[10:8])
					 &&(ex_ir[15:11]!=`NOP)&&(ex_ir[15:11]!=`HALT)
					 &&(ex_ir[15:11]!=`LOAD)&&(ex_ir[15:11]!=`CMP)
					 &&(ex_ir[15:11]!=`JUMP)
					 &&(id_ir[6:4]!=`gr0))//gr0冲突无关紧要，允许冲突
						begin		reg_A <= ALUo;		end
					else if((id_ir[6:4]==mem_ir[10:8])
							&&(mem_ir[15:11]!=`NOP)&&(mem_ir[15:11]!=`HALT)
							&&(mem_ir[15:11]!=`CMP)&&(mem_ir[15:11]!=`JUMP)
							&&(id_ir[6:4]!=`gr0))//gr0冲突无关紧要，允许冲突
						begin
							if(mem_ir[15:11]==`LOAD)	reg_A <= d_datain;
							else								reg_A <= reg_C;
						end
					else if((id_ir[6:4]==wb_ir[10:8])
							&&((wb_ir[15:11]!=`NOP)&&(wb_ir[15:11]!=`HALT)
							&&(wb_ir[15:11]!=`CMP)&&(wb_ir[15:11]!=`JUMP))
							&&(id_ir[6:4]!=`gr0))//gr0冲突无关紧要，允许冲突
						begin		reg_A <= reg_C1;		end
					else
						begin		reg_A <= gr[id_ir[6:4]];		end	//r2
				end
			else if(((mem_ir[15:11]==`BZ)&&(zf==1'b1))
					||((mem_ir[15:11]==`BNZ)&&(zf==1'b0))
					||((mem_ir[15:11]==`BN)&&(nf==1'b1))
					||((mem_ir[15:11]==`BNN)&&(nf==1'b0))
					||((mem_ir[15:11]==`BC)&&(cf==1'b1))
					||((mem_ir[15:11]==`BNC)&&(nf==1'b0))
					|| (mem_ir[15:11]==`JMPR))
				begin		reg_A <= 16'b0;		end
			else
			begin
			/***********************************************/
				if((id_ir[15:11] == `BZ)
				 ||(id_ir[15:11] == `BN)
				 ||(id_ir[15:11] == `JMPR)
				 ||(id_ir[15:11] == `BC)
				 ||(id_ir[15:11] == `BNZ)
				 ||(id_ir[15:11] == `BNN)
				 ||(id_ir[15:11] == `BNC)
				 ||(id_ir[15:11] == `ADDI)
				 ||(id_ir[15:11] == `SUBI)
				 ||(id_ir[15:11] == `LDIH))
					reg_A <= gr[(id_ir[10:8])];
				else if(id_ir[15:11] == `JUMP)
					reg_A <= 16'b0000_0000_0000_0000;
				else
					reg_A <= gr[(id_ir[6:4])];
			end
			
			//reg_B
			/********************Hazard*********************/
			if(id_ir[15:11]==`LDIH)
				begin		reg_B <= {id_ir[7:0], 8'b0000_0000};	end
			else if((id_ir[15:11]==`STORE)||(id_ir[15:11]==`LOAD)
					||(id_ir[15:11]==`SLL)||(id_ir[15:11]==`SRL)
					||(id_ir[15:11]==`SLA)||(id_ir[15:11]==`SRA))
				begin		reg_B <= {12'b0000_0000_0000, id_ir[3:0]};	end
			else if((id_ir[15:11]==`BZ)||(id_ir[15:11]==`BNZ)
					||(id_ir[15:11]==`BN)||(id_ir[15:11]==`BNN)
					||(id_ir[15:11]==`BC)||(id_ir[15:11]==`BNC)
					||(id_ir[15:11]==`ADDI)||(id_ir[15:11]==`SUBI)
					||(id_ir[15:11]==`JUMP)||(id_ir[15:11]==`JMPR))
				begin		reg_B <= {8'b0000_0000, id_ir[7:0]};	end
			else if((id_ir[15:11]==`ADD)||(id_ir[15:11]==`ADDC)
					||(id_ir[15:11]==`SUB)||(id_ir[15:11]==`SUBC)
					||(id_ir[15:11]==`CMP)||(id_ir[15:11]==`AND)
					||(id_ir[15:11]==`OR)||(id_ir[15:11]==`XOR))
				begin
					if((id_ir[2:0]==ex_ir[10:8])
					 &&((ex_ir[15:11]!=`NOP)&&(ex_ir[15:11]!=`HALT)
					  &&(ex_ir[15:11]!=`LOAD)&&(ex_ir[15:11]!=`CMP)
					  &&(ex_ir[15:11]!=`JUMP)))
						begin		reg_B <= ALUo;		end
					else if((id_ir[2:0]==mem_ir[10:8])
							&&((mem_ir[15:11]!=`NOP)&&(mem_ir[15:11]!=`HALT)
							&&(mem_ir[15:11]!=`CMP)&&(mem_ir[15:11]!=`JUMP)))
						begin
							if(mem_ir[15:11]==`LOAD)	reg_B <= d_datain;
							else								reg_B <= reg_C;
						end
					else if((id_ir[2:0]==wb_ir[10:8])
							&&((wb_ir[15:11]!=`NOP)&&(wb_ir[15:11]!=`HALT)
							&&(wb_ir[15:11]!=`CMP)&&(wb_ir[15:11]!=`JUMP)))
						begin		reg_B <= reg_C1;		end
					else
						begin		reg_B <= gr[id_ir[2:0]];		end	//r3
				end
			else if(((mem_ir[15:11]==`BZ)&&(zf==1'b1))
					 ||((mem_ir[15:11]==`BNZ)&&(zf==1'b0))
					 ||((mem_ir[15:11]==`BN)&&(nf==1'b1))
					 ||((mem_ir[15:11]==`BNN)&&(nf==1'b0))
					 ||((mem_ir[15:11]==`BC)&&(cf==1'b1))
					 ||((mem_ir[15:11]==`BNC)&&(nf==1'b0))
					 || (mem_ir[15:11]==`JMPR))
				begin		reg_B <= 16'b0;		end	
			else
			begin
			/***********************************************/
				if((id_ir[15:11] == `LOAD)
				 ||(id_ir[15:11] == `SLL)
				 ||(id_ir[15:11] == `SLA)
				 ||(id_ir[15:11] == `SRL)
				 ||(id_ir[15:11] == `SRA))
					reg_B <= {12'b0000_0000_0000, id_ir[3:0]};
				else if((id_ir[15:11] == `BZ)
						||(id_ir[15:11] == `BN)
						||(id_ir[15:11] == `JUMP)
						||(id_ir[15:11] == `JMPR)
						||(id_ir[15:11] == `BC)
						||(id_ir[15:11] == `BNZ)
						||(id_ir[15:11] == `BNN)
						||(id_ir[15:11] == `BNC)
						||(id_ir[15:11] == `ADDI)
						||(id_ir[15:11] == `SUBI))
					reg_B <= {8'b0000_0000, id_ir[7:0]};
				else if((id_ir[15:11] == `STORE))
				begin
					reg_B <= {12'b0000_0000_0000, id_ir[3:0]};
					//smdr <= gr[(id_ir[10:8])];	//for not Hazard
				end
				else if(id_ir[15:11] == `LDIH)
					reg_B <= {id_ir[7:0], 8'b0000_0000};
				else
					reg_B <= gr[id_ir[2:0]];
			end
			
			//smdr
			/********************Hazard**********************/
			if(id_ir[15:11]==`STORE)
				begin
					if((id_ir[10:8]==ex_ir[10:8])
					 &&((ex_ir[15:11]!=`NOP)&&(ex_ir[15:11]!=`HALT)
					 &&(ex_ir[15:11]!=`LOAD)&&(ex_ir[15:11]!=`CMP)
					 &&(ex_ir[15:11]!=`JUMP)))
						begin		smdr <= ALUo;		end
					else if((id_ir[10:8]==mem_ir[10:8])
						   &&((mem_ir[15:11]!=`NOP)&&(mem_ir[15:11]!=`HALT)
							&&(mem_ir[15:11]!=`CMP)&&(mem_ir[15:11]!=`JUMP)))
						begin
							if(mem_ir[15:11]==`LOAD)	smdr <= d_datain;
							else								smdr <= reg_C;
						end
					else if((id_ir[10:8]==wb_ir[10:8])
							&&((wb_ir[15:11]!=`NOP)&&(wb_ir[15:11]!=`HALT)
							&&(wb_ir[15:11]!=`CMP)&&(wb_ir[15:11]!=`JUMP)))
						begin		smdr <= reg_C1;		end
					else
						begin		smdr <= gr[id_ir[10:8]];		end
				end
			else
				smdr <= gr[id_ir[10:8]];
			
			/********************Hazard**********************/
		end
		else
		begin
			ex_ir <= ex_ir;
			reg_A <= reg_A;
			reg_B <= reg_B;
			smdr <= smdr;
		end
	end
	/***************************************/
	
	/****************EX*********************/
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			mem_ir <= 16'b0000_0000_0000_0000;
			reg_C <= 16'b0000_0000_0000_0000;
			smdr1 <= 16'b0000_0000_0000_0000;
			zf <= 1'b0;
			nf <= 1'b0;
			cf <= 1'b0;
			dw <= 1'b0;
		end
		else if(state == `exec)
		begin
			mem_ir <= ex_ir;
			reg_C <= ALUo;
			smdr1 <= smdr;
			if((ex_ir[15:11] == `ADD)
			 ||(ex_ir[15:11] == `CMP)
			 ||(ex_ir[15:11] == `ADDI)
			 ||(ex_ir[15:11] == `SUB)
			 ||(ex_ir[15:11] == `SUBI)
			 ||(ex_ir[15:11] == `LDIH)
			 ||(ex_ir[15:11] == `SLL)
			 ||(ex_ir[15:11] == `SRL)
			 ||(ex_ir[15:11] == `SLA)
			 ||(ex_ir[15:11] == `SRA)
			 ||(ex_ir[15:11] == `ADDC)
			 ||(ex_ir[15:11] == `SUBC)
			 ||(ex_ir[15:11] == `AND)
			 ||(ex_ir[15:11] == `OR)
			 ||(ex_ir[15:11] == `XOR))
			begin
				if(ALUo == 16'b0000_0000_0000_0000)
					zf <= 1'b1;
				else
					zf <= 1'b0;
				
				if(ALUo[15] == 1'b1)
					nf <= 1'b1;
				else
					nf <= 1'b0;
			end
			else
			begin
				zf <= zf;
				nf <= nf;
			end
			
			if(ex_ir[15:11] == `STORE)
			begin
				dw <= 1'b1;
			end
			else
			begin
				dw <= 1'b0;
			end
		end
		else
		begin
			reg_C <= reg_C;
			smdr1 <= smdr1;
			dw <= dw;
		end
	end
	//ALU
	reg cf_temp;
	always@(reg_A or reg_B or ex_ir[15:11])
	begin
		if(state == `exec)
		begin
			if(reset)
			begin
				ALUo <= 16'b0000_0000_0000_0000;
				cf_temp <= 0;
			end
			else
				case(ex_ir[15:11])
					`NOP:		{cf_temp, ALUo} <= {cf_temp, ALUo};
					`HALT:	{cf_temp, ALUo} <= {cf_temp, ALUo};
					`AND:		{cf_temp, ALUo} <= {cf_temp, reg_A & reg_B};
					`OR:		{cf_temp, ALUo} <= {cf_temp, reg_A | reg_B};
					`XOR:		{cf_temp, ALUo} <= {cf_temp, reg_A ^ reg_B};
					`SLL:		{cf_temp, ALUo} <= {cf_temp, reg_A << reg_B};
					`SRL:		{cf_temp, ALUo} <= {cf_temp, reg_A >> reg_B};
					`SLA:		{cf_temp, ALUo} <= {cf_temp, $signed(reg_A) <<< reg_B};
					`SRA:		{cf_temp, ALUo} <= {cf_temp, $signed(reg_A) >>> reg_B};
					`JUMP:	{cf_temp, ALUo} <= {cf_temp, reg_B};
					`LDIH:	{cf_temp, ALUo} <= {1'b0 + reg_A} + {1'b0 + reg_B};
					`ADD:		{cf_temp, ALUo} <= {1'b0 + reg_A} + {1'b0 + reg_B};
					`ADDI:	{cf_temp, ALUo} <= {1'b0 + reg_A} + {1'b0 + reg_B};
					`ADDC:	{cf_temp, ALUo} <= {1'b0 + reg_A} + {1'b0 + reg_B} + cf;
					`SUB:		{cf_temp, ALUo} <= {1'b0 + reg_A} - {1'b0 + reg_B};
					`SUBI:	{cf_temp, ALUo} <= {1'b0 + reg_A} - {1'b0 + reg_B};
					`SUBC:	{cf_temp, ALUo} <= {1'b0 + reg_A} - {1'b0 + reg_B} - cf;
					`CMP:		{cf_temp, ALUo} <= {1'b0 + reg_A} - {1'b0 + reg_B};
					`LOAD:	begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`STORE:	begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`JMPR:	begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BZ:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BNZ:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BN:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BNN:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BC:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					`BNC:		begin ALUo <= reg_A + reg_B; cf_temp <= cf_temp; end
					default:	{cf_temp, ALUo} <= {cf_temp, ALUo};
				endcase
		end
	end
	/***************************************/
	
	/***************MEM*********************/
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			reg_C1 <= 16'b0000_0000_0000_0000;
			wb_ir <= 16'b0000_0000_0000_0000;
		end
		else if(state == `exec)
		begin
			wb_ir <= mem_ir;
			cf <= cf_temp;
			if(mem_ir[15:11] == `LOAD)
				reg_C1 <= d_datain;
			else
				reg_C1 <= reg_C;
		end
	end
	/***************************************/
	
	/****************WB********************/
	always@(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			gr[0] <= 16'b0000_0000_0000_0000;
			gr[1] <= 16'b0000_0000_0000_0000;
			gr[2] <= 16'b0000_0000_0000_0000;
			gr[3] <= 16'b0000_0000_0000_0000;
			gr[4] <= 16'b0000_0000_0000_0000;
			gr[5] <= 16'b0000_0000_0000_0000;
			gr[6] <= 16'b0000_0000_0000_0000;
			gr[7] <= 16'b0000_0000_0000_0000;
		end
		else if(state == `exec)
		begin
			if((wb_ir[15:11] == `LOAD)
			 ||(wb_ir[15:11] == `ADD)
			 ||(wb_ir[15:11] == `ADDI)
			 ||(wb_ir[15:11] == `ADDC)
			 ||(wb_ir[15:11] == `SUB)
			 ||(wb_ir[15:11] == `SUBI)
			 ||(wb_ir[15:11] == `SUBC)
			 ||(wb_ir[15:11] == `AND)
			 ||(wb_ir[15:11] == `OR)
			 ||(wb_ir[15:11] == `XOR)
			 ||(wb_ir[15:11] == `SLL)
			 ||(wb_ir[15:11] == `SRL)
			 ||(wb_ir[15:11] == `SLA)
			 ||(wb_ir[15:11] == `SRA)
			 ||(wb_ir[15:11] == `LDIH))
				gr[wb_ir[10:8]] <= reg_C1;
		end
		else
		begin
				gr[wb_ir[10:8]] <= gr[wb_ir[10:8]];
		end
	end
	/***************************************/
	
	/**************select Y*****************/
	always@(*)
	begin
		case(select_y)
			4'b0000:	y <= reg_C;
			4'b0001:	y <= reg_A;
			4'b0010:	y <= reg_B;
			4'b0011:	y <= {pc, 8'b0000_0000};
			4'b0100:	y <= id_ir;
			4'b0101:	y <= smdr;
			4'b0110:	y <= reg_C1;
			4'b0111:	y <= smdr1;
			4'b1000:	y <= ex_ir;
			4'b1001:	y <= mem_ir;
			4'b1010:	y <= wb_ir;
			default: y <= reg_C;
		endcase
	end
	/***************************************/
endmodule
