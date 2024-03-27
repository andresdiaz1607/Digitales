`timescale 1ns/1ps
module Onehot #(parameter N = 32) 
  (
  input [$clog2(N)-1:0] Selector,
  output Outn [N-1:0]
  );
  genvar i;
  generate
    for(i=0; i < N; i = i + 1) begin
	localparam localsel = i;
	assign Outn[i] = (localsel == Selector) ? 1:0;
    end
  endgenerate
endmodule
