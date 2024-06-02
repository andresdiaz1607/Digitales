`include "Onehot.sv"
`timescale 1ns/1ps
module MuxParam #(parameter N = 32, Bits = 64) 
(
  input [$clog2(N)-1:0] read_code,
  input [Bits-1:0] D [N-1:0],
  output [Bits-1:0] Q 
);

  wire Enable [N-1:0];
  Onehot #(.N(N)) Decodificador (.Outn(Enable), .Selector(read_code));
  genvar i;
  generate
    for(i=0; i < N; i = i + 1) begin: Bit_
      assign Q = (Enable[i]==1) ? D[i] : {Bits{1'bz}};
    end
  endgenerate
endmodule
