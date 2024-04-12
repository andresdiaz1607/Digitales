`include "InstructionMemory.sv"
`include "BancoRegistros.sv"
`include "DataMemory.sv"
`include "GeneradorImm.sv"
`include "ALU_Unit.sv"
module Datapath_Unit#(Bits, MemSize, N, NumInst)(
  input clk, rst,
  input beq,mem_read,mem_write,alu_src,mem_to_reg,reg_write,
  input[1:0] alu_op,
  output[2:0] Opcode
  );
  reg [31:0] pc_current;
  wire [31:0] pc_next,pc2;
  wire [31:0] offset;
  wire [2:0] cod_ins;
  wire [$clog2(N)-1:0] reg_write_dest;
  wire [Bits-1:0] reg_write_data;
  wire [$clog2(N)-1:0] reg_read_addr_1;
  wire [Bits-1:0] reg_read_data_1;
  wire [$clog2(N)-1:0] reg_read_addr_2;
  wire [Bits-1:0] reg_read_data_2;
  wire [Bits-1:0] im_ext,read_data2;
  wire [Bits-1:0] ALU_out;
  wire zero_flag;
  wire beq_control;
  wire [31:0] PC_beq;
  wire [Bits-1:0] mem_read_data;
  //PC
  initial begin
      pc_current <= 32'd0;
    end  
  always @(posedge clk) begin
    pc_current <= pc_next;
  end
  assign pc2 = pc_current + 32'd4;
 
  //Memoria de Instrucciones
  InstructionMemory #(
    .NumInst(NumInst)
    ) Memoria_Instrucciones (
    .clk(clk), 
    .pc(pc_current), 
    .Opcode(cod_ins), 
    .Rs1(reg_read_addr_1), 
    .Rs2(reg_read_addr_2), 
    .Rd(reg_write_dest), 
    .Offset(offset));

  //Registros de propósito general
    BancoRegistros 
    #(.N(N), 
    .Bits(Bits))
    GPRs (
   .clk(clk), 
   .rst(rst), 
   .wr_en(reg_write), 
   .ptr_rd_1(reg_read_addr_1), 
   .ptr_rd_2(reg_read_addr_2), 
   .ptr_wr(reg_write_dest), 
   .data_wr(reg_write_data), 
   .data_rd_1(reg_read_data_1), 
   .data_rd_2(reg_read_data_2));

    //Generador de Inmediato
    GeneradorImm #(
       .Bits(Bits)) 
      InmSext (
       .Offset(offset), 
       .Inmediato(im_ext));

    //Mux fuente para operando B de Alu
    assign read_data2 = (alu_src == 1'b1) ? im_ext : reg_read_data_2;

    //Unidad ALU
    ALU_Unit #(
     .Bits(Bits)) 
    UnidadALU (
     .A(reg_read_data_1), 
     .B(read_data2), 
     .sel(alu_op), 
     .resultado(ALU_out), 
     .zero(zero_flag));
    
    //Lógica de program counter de beq o siguiente inst
    assign PC_beq = pc2 + im_ext;
    assign beq_control = beq & zero_flag;
    assign pc_next = (beq_control==1'b1) ? PC_beq : pc2;

    //Banco de memoria de informacióni
    Data_Memory #(
      .Bits(Bits), 
      .MemSize(MemSize)) 
     Memoria_Informacion (
      .clk(clk), 
      .mem_access_addr(ALU_out), 
      .mem_write_data(reg_read_data_2), 
      .mem_write_en(mem_write), 
      .mem_read(mem_read), 
      .mem_read_data(mem_read_data));

 //Mux para información a escribir en registros para ld
  assign reg_write_data = (mem_to_reg == 1'b1) ? mem_read_data : ALU_out;
  assign Opcode = cod_ins;
endmodule
