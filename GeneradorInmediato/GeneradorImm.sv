`timescale 1ns/1ps
module GeneradorImm (
    input wire [31:0] Instruccion,
    output reg [63:0] Inmediato
   );
  wire [2:0] Selector = Instruccion[6:4];
  parameter A = 3'b000, B = 3'b010, C = 3'b110, D = 3'b011;
  always @(*) begin
    case(Selector) 
    A:
      Inmediato = {{52{Instruccion[31]}},Instruccion[30:20]};
    B:
      Inmediato = {{52{Instruccion[31]}},Instruccion[30:25],Instruccion[11:7]};
    C:
      Inmediato = {{50{Instruccion[31]}},Instruccion[7],Instruccion[30:25],Instruccion[11:8],2'b00};
    D:
      Inmediato = 64'b0;
  endcase
  end
endmodule
