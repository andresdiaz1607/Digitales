`include "ControlUnit.sv"
`include "DatapathUnit.sv"
`timescale 1ns/1ps
module Procesador_RISC_V #(Bits, N, MemSize, NumInst)(input clk, rst);
  wire beq,mem_read,mem_write,alu_src,mem_to_reg,reg_write; 
  wire[1:0] alu_op;
  wire [2:0] opcode;
  //Datapath
  Datapath_Unit #(.Bits(Bits), .N(N), .MemSize(MemSize), .NumInst(NumInst)) DatapathUnit
  (
 .clk(clk),
 .rst(rst),
 .beq(beq),
 .mem_read(mem_read),
 .mem_write(mem_write),
 .alu_src(alu_src),
 .mem_to_reg(mem_to_reg),
 .reg_write(reg_write),
 .alu_op(alu_op),
 .Opcode(opcode));
// control unit
  Control_Unit ControlUnit
  (
 .Opcode(opcode),
 .mem_to_reg(mem_to_reg),
 .alu_op(alu_op),
 .beq(beq),
 .mem_read(mem_read), 
 .mem_write(mem_write), 
 .alu_src(alu_src), 
 .reg_write(reg_write)); 
endmodule
