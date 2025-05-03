module instructionMemory(address, readData);
   input [31:0] address;
   output [31:0] readData;
   reg [31:0] RAM[0:63];
   initial $readmemh("instruction_memory_testbench.dat", RAM);
   assign readData = RAM[address];
endmodule

