`timescale 1ns / 1ps
`include"headfile.v"

module I_mem(
	input mem_clk,
	input [7:0] addr,
	output wire [15:0] rdata
    );

	reg [15:0] i_mem [255:0];
	assign rdata = i_mem[addr];
	
	// Test by me
	/*initial begin
		i_mem[0] <= {`ADDI, `gr1, 4'b1010, 4'b1011}; // gr1 = 00AB;
		i_mem[1] <= {`LDIH, `gr2, 4'b0011, 4'b1100}; // gr2 = 3C00;
		i_mem[2] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2}; // gr3 = 3CAB;
		i_mem[3] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0000}; // dm0 = 3CAB;
		i_mem[4] <= {`ADDI, `gr1, 4'b0001, 4'b0001}; // gr1 = 00BC;
		i_mem[5] <= {`LDIH, `gr2, 4'b0001, 4'b0001}; // gr2 = 4D00;
		i_mem[6] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2}; // gr3 = 4DBC;
		i_mem[7] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0001}; // dm1 = 4DBC;
		i_mem[8] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000}; // gr1 = 3CAB;
		i_mem[9] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0001}; // gr2 = 4DBC;
		i_mem[10] <= {`SUB, `gr3, 1'b0, `gr2, 1'b0, `gr1}; // gr3 = 1111;
		i_mem[11] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010}; // dm2 = 1111;
		i_mem[12] <= {`JUMP, 3'b000, 4'b0001, 4'b0000}; // Jump to 16
		i_mem[13] <= {`ADDI, `gr1, 4'b1010, 4'b1011};//Not Used
		i_mem[14] <= {`ADDI, `gr1, 4'b1010, 4'b1011};//Not Used
		i_mem[15] <= {`ADDI, `gr1, 4'b1010, 4'b1011};//Not Used
		i_mem[16] <= {`ADDI, `gr4, 4'b0001, 4'b0100}; // gr4 = 20(0014);
		i_mem[17] <= {`CMP, 3'b000, 1'b0, `gr1, 1'b0, `gr1}; // let zf = 1
		i_mem[18] <= {`BZ, `gr4, 4'b0000, 4'b0010}; // Branch true to 22
		i_mem[19] <= {`SUBI, `gr1, 4'b0010, 4'b1000};//Not Used
		i_mem[20] <= {`SUBI, `gr1, 4'b0010, 4'b1000};//Not Used
		i_mem[21] <= {`SUBI, `gr1, 4'b0010, 4'b1000};//Not Used
		i_mem[22] <= {`ADDI, `gr1, 4'b1010, 4'b1010}; // gr1 = 3D55;
		i_mem[23] <= {`CMP, 3'b000, 1'b0, `gr1, 1'b0, `gr2}; // let nf = 1
		i_mem[24] <= {`BNN, `gr4, 4'b0000, 4'b0101}; // Branch false to 25
		i_mem[25] <= {`SUBI, `gr1, 4'b1010, 4'b1010}; // gr1 = 3CAB;
		i_mem[26] <= {`ADDI, `gr1, 4'b1010, 4'b1010}; // gr1 = 3D55;
		i_mem[27] <= {`SUBI, `gr1, 4'b1010, 4'b1010}; // gr1 = 3CAB;
		i_mem[28] <= {`NOP, `gr1, 4'b1010, 4'b1010};
		i_mem[29] <= {`NOP, `gr1, 4'b1010, 4'b1010};
		i_mem[30] <= {`JUMP, 3'b000, 4'b0010, 4'b1000}; // Jump to 40
		i_mem[40] <= {`HALT, 11'b000_0000_0000}; // Stop
	end*/
	
	// Bubble Test
	/*initial begin
		i_mem[0] <= {`LOAD, `gr3, 4'b0000, 4'b0000};
		i_mem[1] <= {`SUBI, `gr3, 4'b0000, 4'b0010};
		i_mem[2] <= {`ADD, `gr1, 1'b0, `gr0, 1'b0, `gr0};
		i_mem[3] <= {`ADD, `gr2, 1'b0, `gr3, 1'b0, `gr0}; // loop1
		i_mem[4] <= {`LOAD, `gr4, 1'b0, `gr2, 4'b0001}; // loop2
		i_mem[5] <= {`LOAD, `gr5, 1'b0, `gr2, 4'b0010};
		i_mem[6] <= {`CMP, 3'b000, 1'b0, `gr5, 1'b0, `gr4};
		i_mem[7] <= {`BN, `gr0, 4'b0000, 4'b1010};// Jump to 10 or not
		i_mem[8] <= {`STORE, `gr4, 1'b0, `gr2, 4'b0010};
		i_mem[9] <= {`STORE, `gr5, 1'b0, `gr2, 4'b0001};
		i_mem[10] <= {`SUBI, `gr2, 4'b0000, 4'b0001};     //bunkisaki
		i_mem[11] <= {`CMP, 3'b000, 1'b0, `gr2, 1'b0, `gr1};
		i_mem[12] <= {`BNN, `gr0, 4'b0000, 4'b0100};//Jump to 4 or not
		i_mem[13] <= {`ADDI, `gr1, 4'b0000, 4'b0001};
		i_mem[14] <= {`CMP, 3'b000, 1'b0, `gr3, 1'b0, `gr1};
		i_mem[15] <= {`BNN, `gr0, 4'b0000, 4'b0011};//Jump to 3 or not
		i_mem[16] <= {`HALT, 11'b000_0000_0000};
	end*/
	
	// Gcd Test
	/*initial begin
		i_mem[0] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001}; //GCM
		i_mem[1] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010}; 
		i_mem[2] <= {`ADD, `gr3, 1'b0, `gr0, 1'b0, `gr1}; //(1)
		i_mem[3] <= {`SUB, `gr1, 1'b0, `gr1, 1'b0, `gr2};
		i_mem[4] <= {`BZ, `gr0, 4'b0000, 4'b1001}; //jump to (2)
		i_mem[5] <= {`BNN, `gr0, 4'b0000, 4'b0010}; //jump to (1)
		i_mem[6] <= {`ADD, `gr1, 1'b0, `gr0, 1'b0, `gr2};
		i_mem[7] <= {`ADD, `gr2, 1'b0, `gr0, 1'b0, `gr3};
		i_mem[8] <= {`JUMP, 3'b000, 4'b0000, 4'b0010}; //jump to (1)
		i_mem[9] <= {`STORE, `gr2, 1'b0, `gr0, 4'b0011}; //(2)
		i_mem[10] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001};  //LCM
		i_mem[11] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010};
		i_mem[12] <= {`ADDI, `gr4, 4'b0000, 4'b0001}; //(3)
		i_mem[13] <= {`SUB, `gr2, 1'b0, `gr2, 1'b0, `gr3};
		i_mem[14] <= {`BZ, `gr0, 4'b0001, 4'b0000}; //jump to (4)
		i_mem[15] <= {`JUMP, 3'b000, 4'b0000, 4'b1100}; //jump to (3)
		i_mem[16] <= {`SUBI, `gr4, 4'b0000, 4'b0001}; //(4)
		i_mem[17] <= {`BN, `gr0, 4'b0001, 4'b0100}; //jump to (5)
		i_mem[18] <= {`ADD, `gr5, 1'b0, `gr5, 1'b0, `gr1};
		i_mem[19] <= {`JUMP, 3'b000, 4'b0001, 4'b0000}; //jump to (4)
		i_mem[20] <= {`STORE, `gr5, 1'b0, `gr0, 4'b0100}; //(5)
		i_mem[21] <= {`HALT, 11'b000_0000_0000};
	end*/
	
	// Sort Test
	/*initial begin
		i_mem[0] <= {`ADDI, `gr1, 4'b0000, 4'b1001};// init
		i_mem[1] <= {`ADDI, `gr2, 4'b0000, 4'b1001};
		i_mem[2] <= {`JUMP, 3'b000, 8'b00000101};// jump to START
		i_mem[3] <= {`SUBI, `gr1, 4'b0000, 4'b0001};// NEW_ROUND
		i_mem[4] <= {`BZ, `gr7, 4'b0000, 4'b0001};// jump to END
		i_mem[5] <= {`LOAD, `gr3, 1'b0, `gr0, 4'b0000};// START
		i_mem[6] <= {`LOAD, `gr4, 1'b0, `gr0, 4'b0001};
		i_mem[7] <= {`CMP, 3'b000, 1'b0, `gr3, 1'b0, `gr4};
		i_mem[8] <= {`BN, `gr7, 8'b00001011};// jump to NO_OP
		i_mem[9] <= {`STORE, `gr3, 1'b0, `gr0, 4'b0001};// store back
		i_mem[10] <= {`STORE, `gr4, 1'b0, `gr0, 4'b0000};
		i_mem[11] <= {`ADDI, `gr0, 4'b0000, 4'b0001}; // NO_OP
		i_mem[12] <= {`CMP, 3'b000, 1'b0, `gr0, 1'b0, `gr2};
		i_mem[13] <= {`BN, `gr7, 8'b00010001}; // jump to CONTINUE
		i_mem[14] <= {`SUBI, `gr2, 8'b00000001}; // UPDATE
		i_mem[15] <= {`SUB, `gr0, 1'b0, `gr0, 1'b0, `gr0};
		i_mem[16] <= {`JUMP, 3'b000, 8'b00000011};// jump to NEW_ROUND
		i_mem[17] <= {`JUMP, 3'b000, 8'b00000101};// jump to START #CONTINUE#
		i_mem[18] <= {`HALT, 11'b000_0000_0000};
	end*/
	
	// 64Add Test
	initial begin
		i_mem[0] <= {`ADDI, `gr4, 4'b0000, 4'b0100};
		i_mem[1] <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000};
		i_mem[2] <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0100};
		i_mem[3] <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
		i_mem[4] <= {`BNC, `gr5, 4'b0000, 4'b0110};//bnc to 6 11111 101 0000 0110
		i_mem[5] <= {`ADDI, `gr6, 4'b0000, 4'b0001};
		i_mem[6] <= {`ADD, `gr3, 1'b0, `gr3, 1'b0, `gr7};
		i_mem[7] <= {`BNC, `gr5, 4'b0000, 4'b1011};//bnc to 11 // 11111 101 0000 1011
		i_mem[8] <= {`SUBI, `gr6, 4'b0000, 4'b0000};                               // {`}
		i_mem[9] <= {`BNZ, `gr5, 4'b0000, 4'b1011} ;//bnz to 11        // 11011 101 0000 1011               // {`BNZ, }
		i_mem[10] <= {`ADDI, `gr6, 4'b0000, 4'b0001};  			//01001'110'0000'0001 // {`ADDC, `gr6, 1'b0, `gr0, 1'b0, `gr1}
		i_mem[11] <= {`SUB, `gr7, 1'b0, `gr7, 1'b0, `gr7};	  			//01010'111'0111'0111 // {`SUB, `gr7, 1'b0, `gr7, 1'b0, `gr7}
		i_mem[12] <= {`ADD, `gr7, 1'b0, `gr7, 1'b0, `gr6};   			//01000'111'0111'0110 // {`ADD, `gr7, 1'b0, `gr7, 1'b0, `gr6}
		i_mem[13] <= {`SUB, `gr6, 1'b0, `gr6, 1'b0, `gr6};	  			//01010'110'0110'0110 // {`SUB, `gr6, 1'b0, `gr6, 1'b0, `gr6}
		i_mem[14] <= {`STORE, `gr3, 4'b0000, 4'b1000};	  			//00011'011'0000'1000 // {`STORE, `gr3, 4'b0000, 4'b1000}
		i_mem[15] <= {`ADDI, `gr0, 4'b0000, 4'b0001};		  			//01001'000'0000'0001 // {`ADDC, `gr0, 1'b0, `gr0, 1'b0, `gr1}
		i_mem[16] <= {`CMP, 3'b000, 1'b0, `gr0, 1'b0, `gr4};   			//01100'000'0000'0100 // {`CMP, 3'b000, 1'b0, `gr0, 1'b0, `gr4}
		i_mem[17] <= {`BN, `gr5, 4'b0000, 4'b0001};//bn to 1 //11100'101'0000'0001 // {`BZ, `gr5, 4'b0000, 4'b0001}
		i_mem[18] <= {`HALT, 11'b000_0000_0000};				//00001'000'0000'0000 // {`HALT, 11'b000_0000_0000};
	end
	
	// Test All
	/*initial begin
		i_mem[0]={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h10 for store address
		i_mem[1]={`LDIH,`gr1,4'b1011,4'b0110};        // test for LDIH  gr1<="16'hb600"
		i_mem[2]={`STORE,`gr1,1'b0,`gr7,4'h0};        // store to mem10	
		i_mem[3]={`LOAD,`gr1,1'b0,`gr0,4'h0};         // gr1 <= fffd 
		i_mem[4]={`LOAD,`gr2,1'b0,`gr0,4'h1};         // gr2 <= 4
		i_mem[5]={`ADDC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= fffd + 4 + cf(=0) = 1, cf<=1
		i_mem[6]={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem11		
		i_mem[7]={`ADDC,`gr3,1'b0,`gr0,1'b0,`gr2};    // gr3 <= 0 + 4 + cf(=1) = 5, cf<=0
		i_mem[8]={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem12
		i_mem[9]={`LOAD,`gr1,1'b0,`gr0,4'h2};          // gr1 <= 5 
		i_mem[10]={`SUBC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= 5 - 4 + cf(=0) =1, cf<=0    
		i_mem[11]={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem13		
		i_mem[12]={`SUB,`gr3,1'b0,`gr2,1'b0,`gr1};     // gr3 <= 4 - 5 = -1, cf<=1    
		i_mem[13]={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem14		
		i_mem[14]={`SUBC,`gr3,1'b0,`gr2,1'b0,`gr1};    // gr3 <= 5 - 4 - cf(=1) =2, cf<=0 
		i_mem[15]={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem15		
		i_mem[16]={`LOAD,`gr1,1'b0,`gr0,4'h3};         // gr1 <= c369
		i_mem[17]={`LOAD,`gr2,1'b0,`gr0,4'h4};         // gr2 <= 69c3		
		i_mem[18]={`AND,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 & gr2 = 4141
		i_mem[19]={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem16		
		i_mem[20]={`OR,`gr3,1'b0,`gr1,1'b0,`gr2};      // gr3 <= gr1 | gr2 = ebeb
		i_mem[21]={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem17		
		i_mem[22]={`XOR,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 ^ gr2 = aaaa
		i_mem[23]={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem18
		i_mem[24]={`SLL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0 
		i_mem[25]={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem19		
		i_mem[26]={`SLL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1 
		i_mem[27]={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem1a		
		i_mem[28]={`SLL,`gr3,1'b0,`gr1,4'h4};          // gr3 <= gr1 < 8 
		i_mem[29]={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem1b	
		i_mem[30]={`SLL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15 
		i_mem[31]={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem1c
		i_mem[32]={`SRL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
		i_mem[33]={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem1d		
		i_mem[34]={`SRL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
		i_mem[35]={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem1e		
		i_mem[36]={`SRL,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
		i_mem[37]={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem1f		
		i_mem[38]={`SRL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
		i_mem[39]={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h20 for store address
		i_mem[40]={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem20
		i_mem[41]={`SLA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0
		i_mem[42]={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem21
		i_mem[43]={`SLA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1 
		i_mem[44]={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem22
		i_mem[45]={`SLA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 < 8 
		i_mem[46]={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem23
		i_mem[47]={`SLA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15
		i_mem[48]={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem24
		i_mem[49]={`SLA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 < 0
		i_mem[50]={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem25
		i_mem[51]={`SLA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 < 1
		i_mem[52]={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem26
		i_mem[53]={`SLA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 < 8
		i_mem[54]={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem27
		i_mem[55]={`SLA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 < 15
		i_mem[56]={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem28
		i_mem[57]={`SRA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
		i_mem[58]={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem29
		i_mem[59]={`SRA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
		i_mem[60]={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem2a
		i_mem[61]={`SRA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
		i_mem[62]={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem2b
		i_mem[63]={`SRA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
		i_mem[64]={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem2c
		i_mem[65]={`SRA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 > 0
		i_mem[66]={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem2d
		i_mem[67]={`SRA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 > 1
		i_mem[68]={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem2e
		i_mem[69]={`SRA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 > 8
		i_mem[70]={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem2f
		i_mem[71]={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h30 for store address
		i_mem[72]={`SRA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 > 15
		i_mem[73]={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem30		
		i_mem[74]={`LOAD,`gr1,1'b0,`gr0,4'h5};         // gr1 <= 41
		i_mem[75]={`LOAD,`gr2,1'b0,`gr0,4'h6};         // gr2 <= ffff
		i_mem[76]={`LOAD,`gr3,1'b0,`gr0,4'h7};         // gr3 <= 1
		i_mem[77]={`JUMP, 3'd0,8'h4f};                 // jump to 4f
		i_mem[78]={`STORE,`gr7,1'b0,`gr7,4'h1};        // store to mem31
		i_mem[79]={`JMPR, `gr1,8'h10};                 // jump to 41+10 = 51
		i_mem[80]={`STORE,`gr7,1'b0,`gr7,4'h2};        // store to mem32
		i_mem[81]={`ADD, `gr4,1'b0,`gr2,1'b0,`gr3};    // gr4<= ffff + 1,cf<=1
		i_mem[82]={`BNC,`gr1,8'h28};                   // if(cf==0) jump to 69
		i_mem[83]={`BC,`gr1,8'h14};                    // if(cf==1) jump to 55
		i_mem[84]={`STORE,`gr7,1'b0,`gr7,4'h3};        // store to mem33
		i_mem[85]={`ADD, `gr4,1'b0,`gr3,1'b0,`gr3};    // gr4<= 1 + 1 , cf<=0
		i_mem[86]={`BC,`gr1,8'h28};                   // if(cf==1) jump to 69
		i_mem[87]={`BNC,`gr1,8'h18};                  // if(cf==0) jump to 59
		i_mem[88]={`STORE,`gr7,1'b0,`gr7,4'h4};        // store to mem34
		i_mem[89]={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr3};    // 1-1=0 , zf<=1,nf<=0
		i_mem[90]={`BNZ,`gr1,8'h28};                   // if(zf==0) jump to 69
		i_mem[91]={`BZ,`gr1,8'h1c};                    // if(zf==1) jump to 5d
		i_mem[92]={`STORE,`gr7,1'b0,`gr7,4'h5};        // store to mem35
		i_mem[93]={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};    // 2-1=1 , zf<=0,nf<=0 
		i_mem[94]={`BZ,`gr1,8'h28};                    // if(zf==1) jump to 69
		i_mem[95]={`BNZ,`gr1,8'h20};                   // if(zf==0) jump to 61
		i_mem[96]={`STORE,`gr7,1'b0,`gr7,4'h6};        // store to mem36
		i_mem[97]={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr4};    // 1-2=-1, nf<=1,zf<=0
		i_mem[98]={`BNN,`gr1,8'h28};                   // if(nf==0) jump to 69
		i_mem[99]={`BN,`gr1,8'h24};                    // if(nf==1) jump to 65 
		i_mem[100]={`STORE,`gr7,1'b0,`gr7,4'h7};        // store to mem37
		i_mem[101]={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};    // 2-1=1, nf<=0,zf<=0
		i_mem[102]={`BN,`gr1,8'h28};                    // if(nf==1) jump to 69
		i_mem[103]={`BNN,`gr1,8'h27};                   // if(nf==0) jump to 68
		i_mem[104]={`STORE,`gr7,1'b0,`gr7,4'h8};        // store to mem38
		i_mem[105]={`HALT, 11'd0};                      // STOP
	end*/
	

endmodule
