`include "GeneradorImm.sv"
`timescale 1ns/1ps 
module GeneradorImm_tb;
  reg [0:31] Instruccion;
  wire [63:0] Inmediato;
  GeneradorImm DUT (.Offset(Instruccion), .Inmediato(Inmediato));
    initial begin
      $dumpfile("GeneradorImm.vcd");
      $dumpvars(0,DUT);
      Instruccion = 32'b00000000101000000010000010000011;//imm = 10
      #20
      Instruccion = 32'b00000000111100000010000100000011; //imm = 15
      #20
      Instruccion = 32'b00000000001100000010000100100011; // imm = 2
      #20
      Instruccion = 32'b00000010000000000000000000110000;
      #20
  $finish;
  end
endmodule
