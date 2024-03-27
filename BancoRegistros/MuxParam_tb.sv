`include "MuxParam.sv" 
`timescale 1ns/1ps
module MuxParam_tb #(parameter N = 32, Bits=64);
  reg [$clog2(N)-1:0] read_code;
  reg [Bits-1:0] D [N-1:0];
  wire [Bits-1:0] Q;
  MuxParam #(.N(N), .Bits(Bits)) uut (.read_code(read_code), .D(D), .Q(Q));
  initial begin
    $dumpfile ("MuxParam.vcd");
    $dumpvars (5,uut);
    D[6] = 64'd32;
    read_code = 5'd6;
    #10
    D[6] = 64'd30;
    #10
    read_code = 5'd2;
    #10
    D[2] = 64'd6;
    #15
    $finish;
  end
endmodule
