`timescale 1ns / 1ps 
`include "Procesador_RISC_V.sv"
module test_RISC_V #(Bits = 64, MemSize = 16, N = 32, NumInst = 7); 
  // Inputs
  reg clk, rst; 
  // Creación de una instancia de la unidad bajo prueba (UUT)
  Procesador_RISC_V #(.Bits(Bits), .N(N), .MemSize(MemSize), .NumInst(NumInst)) uut
  (.clk(clk), .rst(rst)); 
  initial 
    begin
      clk <= 0;
      $dumpfile("RISCV.vcd");
      $dumpvars(5,uut);
      rst = 1;
      #5
      rst = 0;
      #80;
      $finish; 
  end
  always 
    begin
      #5 clk = ~clk; 
  end
endmodule
