`include "GeneradorImm.sv"
`timescale 1ns/1ps 
module GeneradorImm_tb;
  reg [31:0] Instruccion;
  wire [63:0] Inmediato;
  GeneradorImm DUT (.Instruccion(Instruccion), .Inmediato(Inmediato));
    initial begin
      $dumpfile("GeneradorImm.vcd");
      $dumpvars(0,DUT);
      Instruccion = 32'b00000001010000000000000000000000; //imm = 20
      #20
      Instruccion = 32'b00000100100000000000010000100000; //imm = 24
      #20
      Instruccion = 32'b00000000000000000000100001100000; // imm = 8
      #20
      Instruccion = 32'b00000010000000000000000000110000;
      #20
  $finish;
  end
endmodule
