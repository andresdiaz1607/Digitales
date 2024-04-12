`timescale 1ns/1ps
module ALU_Unit #(Bits) (
  input wire [Bits-1:0] A,
  input wire [Bits-1:0] B,
  input wire [1:0] sel,
  output zero,
  output reg [Bits-1:0] resultado
);
 always @(*) begin
    case(sel)
	 3'b00: resultado = A + B; // add
         3'b01: resultado = A - B; // sub
         3'b10: resultado = A & B; // and
	 3'b11: resultado = A | B; // or
	 default: resultado = A + B;
   endcase
 end
 assign zero = (resultado == 64'd0) ? 1'b1 : 1'b0;
endmodule

