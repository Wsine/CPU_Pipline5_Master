`ifndef HEADFILE_H_

//State for CPU
`define	idle		1'b0
`define	exec		1'b1

//Data transfer & Arithmetic
`define  NOP		5'b00000
`define  HALT		5'b00001
`define  LOAD		5'b00010
`define  STORE		5'b00011
`define  LDIH		5'b10000
`define  ADD		5'b01000
`define	ADDI		5'b01001
`define	ADDC		5'b10001
`define	CMP		5'b01100

//Logical / shift
`define	AND		5'b01101
`define	SLL		5'b00100
`define	SLA		5'b00101

//Control
`define	JUMP		5'b11000
`define	JMPR		5'b11001
`define	BZ			5'b11010
`define	BNZ		5'b11011
`define	BN			5'b11100
`define	BC			5'b11110

//Add by myself
`define	SUB   	5'b01010
`define 	SUBI  	5'b01011
`define 	SUBC  	5'b10010
`define 	OR    	5'b01110
`define 	XOR   	5'b01111
`define 	SRL   	5'b00110
`define 	SRA   	5'b00111
`define 	BNN   	5'b11101
`define 	BNC   	5'b11111

//gr
`define gr0 3'b000
`define gr1 3'b001
`define gr2 3'b010
`define gr3 3'b011
`define gr4 3'b100
`define gr5 3'b101
`define gr6 3'b110
`define gr7 3'b111

`endif
