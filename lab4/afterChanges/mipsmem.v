
// Todo: Implement data memory
module datamem(input          clk, we,
            input   [31:0] a, wd,
            output  [31:0] rd);

// **PUT YOUR CODE HERE**
  reg [31:0] RAM[63:0];

  assign rd = RAM[a[31:2]]; // word aligned

  always @(posedge clk)
  	if (we) RAM[a[31:2]] <= wd;  
endmodule


// Instruction memory (already implemented)
module immedimem12(input   [5:0]  a,
            output  [31:0] rd);

  reg [31:0] RAM[63:0];

  initial
    begin


      // CHANGES STARt
      $readmemh("memfile2.dat",RAM);
      // CHANGES END

      

  assign rd = RAM[a]; // word aligned
endmodule

