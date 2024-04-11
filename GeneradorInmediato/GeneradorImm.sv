`timescale 1ns/1ps
module GeneradorImm #(Bits=64)(
input wire [31:0] Offset,
    output reg [Bits - 1:0] Inmediato
   );
  wire [2:0] Selector = Offset[6:4];
  parameter A = 3'b000, B = 3'b010, C = 3'b110; //A = load, B = save, C = BEQ
  always @(*) begin
    case(Selector) 
    A:
      Inmediato = {{52{Offset[31]}},Offset[30:20]};
    B:
      Inmediato = {{52{Offset[31]}},Offset[30:25],Offset[11:7]};
    C:
      Inmediato = 1<<{{50{Offset[31]}},Offset[7],Offset[30:25],Offset[11:8],1'b0};
    default:
      Inmediato = 64'b0;
  endcase
  end
endmodule
