module maindec (input  [5:0] 	op,
		output 		memtoreg, memwrite,
		output 		branch, alusrc,
		output 		regdst, regwrite,
		output 		jump,
		output [1:0] 	aluop);

  reg [8:0] controls;

  assign {regwrite, regdst, alusrc, branch, memwrite,
		memtoreg, jump, aluop} = controls;

  always @*
  	case(op)
		6'b000000: controls <= 9'b110000010; // RTYPE 
		6'b100011: controls <= 9'b101001000; // LW 
		6'b101011: controls <= 9'b001010000; // SW 
		6'b000100: controls <= 9'b000100001; // BEQ 
		6'b001000: controls <= 9'b101000000; // ADDI 
		6'b000010: controls <= 9'b000000100; // J


		// CHANGES START
		// added functionallity of ORI and BNE to opcodes
		6'b001101: controls <= 9'b101000011; // ORI
		6'b000101: controls <= 9'b000100001; // BNE
		// CHANGES END

		default:   controls <= 9'bxxxxxxxxx;  // Not found, illegal 
	endcase 
endmodule


module aludec  (input [5:0]      funct,
		input [1:0]      aluop,
		output reg [2:0] alucontrol);

  always @*
  	case(aluop)
  		2'b00: alucontrol <= 3'b010;


		// CHANGES START 
		// added beq and ori
		// included sub needed to beq 
  		2'b01: alucontrol <= 3'b110; 
        2'b11: alucontrol <= 3'b001; 
		// CHANGES END 


  		default: case(funct) 	     // R-type instructions
  			6'b100000: alucontrol <= 3'b010; // add 
  			6'b100010: alucontrol <= 3'b110; // sub 
  			6'b100100: alucontrol <= 3'b000; // and 
  			6'b100101: alucontrol <= 3'b001; // or 
  			6'b101010: alucontrol <= 3'b111; // slt 
  			default:   alucontrol <= 3'bxxx; // ???
  		endcase 
  	endcase
endmodule
