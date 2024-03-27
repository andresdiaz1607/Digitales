`include "hotbit.sv" 
`timescale 1ns/1ps
module DUT#(parameter N = 32);
  reg [$clog2(N)-1:0] reg_wr_cod;
  reg wr_en;
  wire  Outn [N-1:0];
  hotbit #(.N(N)) uut (.reg_wr_cod(reg_wr_cod), .wr_en(wr_en), .Outn(Outn));
  initial begin
    $dumpfile ("hotbit.vcd");
    $dumpvars (0,uut);
    reg_wr_cod =  5'd6;
    wr_en = 1'b1;
    #10
    wr_en = 1'b0;
    #10
    reg_wr_cod = 5'd2;
    #10
    wr_en = 1'b1;
    #15
    $finish;
  end
endmodule
