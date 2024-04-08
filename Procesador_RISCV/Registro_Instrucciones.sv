`timescale 1ns/1ps
module Memory#(
    parameter NumInst
) (
    input clk,
    input wire [31 : 0] Addres,//Dirección
    output reg [0 : 31] Instruction //
);
  reg [0 : 31] Memory [NumInst -1 : 0]; 
  wire [$clog2(NumInst)-1 : 0] rom_addr = Addres[$clog2(NumInst)+2 : 2]; 
  initial
  begin
   $readmemb("Prog.mem", Memory); 
  end
  assign Instruction = Memory[rom_addr]; 
endmodule
