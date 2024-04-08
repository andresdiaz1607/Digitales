`timescale 1ns/1ps
module ALU_Unit #(Bits) (
  input wire [Bits-1:0] A,
  input wire [Bits-1:0] B,
  input wire [1:0] sel,
  output reg zero,
  output reg [Bits-1:0] resultado
);
  reg [Bits-1:0] sub; //variable para la bandera de cero
  reg [Bits-1:0] bn; //variable para calcular la Resta con complemento a2
  reg [Bits-1:0] bj;
  always@(*) begin
    case(sel)
      00:
        begin
	  assign resultado = A + B; //Función de suma
        end 
      01: 
        begin
          assign bn = ( A < B) ? A : B;
          assign bj = ( A < B) ? B : A;
          assign bn = ~bn + 1;
          assign sub = bj + bn;
          if (sub == 64'b0)
	    begin
	      zero = 1'b1;
              resultado = 64'd0;
            end
	  else begin
	    resultado = sub;
            zero = 0;
	  end
        end
      10: 
        begin
          assign resultado = A & B ; //Función AND
          zero = 1'b0;
        end
      11: 
        begin
          resultado = A | B; //Función OR
          zero = 1'b0;
        end
      default: begin
          zero = 1'b0;
          resultado = 64'd0;
       end
   endcase
 end
endmodule

