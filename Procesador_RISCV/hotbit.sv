`timescale 1ns/1ps
module hotbit#(parameter N) (
  input [$clog2(N)-1:0] reg_wr_cod,
  input wr_en,
  output reg Outn [N-1:0]
  );
  genvar i;
  generate
    for(i=0; i < N; i = i + 1) begin
      localparam localsel = i;
      assign Outn[i] = (localsel == reg_wr_cod && wr_en == 1) ? 1:0;
     end
  endgenerate
endmodule
