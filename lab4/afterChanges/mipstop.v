
// CHANGES START
module top     (input clk, reset,
		output [31:0] writedata, dataadr,
		output memwrite);

  wire [31:0] pc, instr, readdata;
  
  // CHANGES END
  
  // processor and memories are instantiated here 
  mips mips(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
  imem immedimem(pc[7:2], instr);
  dmem datamem(clk, memwrite, dataadr, writedata, readdata);

endmodule
