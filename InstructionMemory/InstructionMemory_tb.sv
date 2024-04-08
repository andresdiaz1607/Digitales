`include "InstructionMemory.sv"
`timescale 1ns/1ps
module InstructionMemory_tb #(Ancho = 32, NumInst = 7);
  reg [31:0] PC;
  wire [2:0] Opcode;
  wire [4:0] Rs1, Rs2, Rd;
  wire [31:0] Offset;
  InstructionMemory #(.Ancho(Ancho), .NumInst(NumInst)) uut (.PC(PC), .Opcode(Opcode), .Rs1(Rs1), .Rs2(Rs2), .Rd(Rd), .Offset(Offset));
  initial begin
    $dumpfile("InstructionMemory.vcd");
    $dumpvars(0,uut);
    PC = 'b0;
    $monitor ($realtime, " Read Data = %0b", Offset);
    repeat(7)
    begin
    #10;
    PC = PC + 32'd4;
    end
  end

endmodule
