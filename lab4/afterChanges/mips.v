// single-cycle MIPS processor
// instantiates a controller and a datapath module

module mips(input          clk, reset,
            output  [31:0] pc,
            input   [31:0] instr,
            output         memwrite,
            output  [31:0] aluout, writedata,
            input   [31:0] readdata);

  wire    memtoreg, branch, pcsrc, zero,
          alusrc, regdst, regwrite, jump;
  wire [2:0]    alucontrol;

  controller c(instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule


// Todo: Implement controller module
module controller(input   [5:0] op, funct,
                  input         zero,
                  output        memtoreg, memwrite,
                  output      pcsrc, alusrc,
                  output        regdst, regwrite,
                  output        jump,
                  output  [2:0] alucontrol);

// **PUT YOUR CODE HERE**
  wire [1:0] aluop;
  wire branch;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, aluop);
  aludec ad(funct, aluop, alucontrol);



  // CHANGES START
  // add bne functionality 
  assign pcsrc = (op == 6'b000101) ? branch & ~zero : branch & zero; 
  // CHANGES END: here



endmodule


// Todo: Implement datapath
module datapath(input          clk, reset,
                input          memtoreg, pcsrc,
                input          alusrc, regdst,
                input          regwrite, jump,
                input   [2:0]  alucontrol,
                output         zero,
                output  [31:0] pc,
                input   [31:0] instr,
                output  [31:0] aluout, writedata,
                input   [31:0] readdata);

// **PUT YOUR CODE HERE**  
  wire [4:0] writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch; 


  // CHANGES START
  wire [31:0] imm, signimmsh;
  // CHANGES END


  wire [31:0] srca, srcb;
  wire [31:0] result;   

  // next PC logic
  flochange #(32) registerPC12(clk, reset, pcnext, pc);
  adder       firstaddpc(pc, 32'b100, pcafter4); 
  sl2         imds(imm, signimds); // CHANGE: signimm to imm
  adder       pcchange2(pcafter4, signimds, pcbranch); 
  mux2 #(32)  pcmuxchange(pcafter4, pcbranch, pcsrc, pcnextafter); 
  mux2 #(32)  pcmux(pcnextafter, {pcafter4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21], instr[20:16], 
                 writereg, result, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11], 
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata, memtoreg, result);


  //CHANGES START
  extend     extendADD(instr[15:0], alucontrol[2:0], regdst, imm);

  mux2 #(32)  muxsourceADD(writedata, imm, alusrc, srcb); 
  //CHANGES END


  ALU         ALU(srca, srcb, alucontrol, aluout, zero);             
endmodule

