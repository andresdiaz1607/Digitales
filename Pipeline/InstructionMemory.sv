`timescale 1ns/1ps
module InstructionMemory#(
    parameter NumInst
) (
    input clk,
    input wire [31 : 0] Addres,//Dirección
    output reg [31 : 0] Instruction //
);
  reg [31 : 0] Memory [NumInst -1 : 0];
  wire [$clog2(NumInst)-1 : 0] rom_addr = Addres[$clog2(NumInst)+2 : 2];
  initial
  begin
   $readmemb("Prog.mem", Memory);
  end
  assign Instruction = Memory[rom_addr];
endmodule

