`include "Registro_Instrucciones.sv"
`timescale 1ns/1ps
module InstructionMemory #(
    parameter NumInst
) (
    input clk,
    input wire [31:0] pc, //Program Counter
    output reg [2:0] Opcode, // Código de lectura para la máquina de control 
    output reg [4:0] Rs1, Rs2, Rd, //Dirección de punteros rs1, rs2 y rd 
    output reg [31:0] Offset //Inmediato 
);
  wire [0:31] Instruction;
  Memory #(.NumInst(NumInst)) Bloque_de_instrucciones (.clk(clk), .Addres(pc), .Instruction(Instruction));
  wire [2:0] Sel = Instruction[4:6];
  wire [2:0] DataProcessingOp = Instruction[12:14]; //Selector Suma, Resta, Or o And
  wire SumOrSub = Instruction[30]; //Selector de suma o resta
  parameter A=3'b000, B=3'b010, C=3'b011, D=3'b110; //A = load, B = Store,  D = BEQ, C = Data Proccesing
  always @(*) begin
    Offset = {Instruction[31], Instruction[30], Instruction[29], Instruction[28], Instruction[27], Instruction[26], Instruction[25], Instruction[24], Instruction[23], Instruction[22], Instruction[21], Instruction[20], Instruction[19], Instruction[18], Instruction[17], Instruction[16], Instruction[15], Instruction[14], Instruction[13], Instruction[12], Instruction[11], Instruction[10], Instruction[9], Instruction[8], Instruction[7], Instruction[6], Instruction[5], Instruction[4], Instruction[3], Instruction[2], Instruction[1], Instruction[0]};
    Rs1 <= Offset[19:15];
    Rs2 <= Offset[24:20];
    Rd <= Offset[11:7];
    case(Sel)
               A:
                assign Opcode = 3'b000;

               B:
                assign Opcode = 3'b001;
            
               C:
                assign Opcode = 3'b110;

               D:
                 if (DataProcessingOp == 3'b000) begin
                    if(SumOrSub) begin 
                      assign Opcode = 3'b011;
                    end

                    else begin
                      assign Opcode = 3'b010;
                    end
                 end
                 else begin
                   if(DataProcessingOp == 3'b111) begin
                     assign Opcode = 3'b100;
                   end

                   else begin
                     assign Opcode = 3'b101;
                   end
                 end
          default: Opcode =3'b000;
      endcase
  end
endmodule
