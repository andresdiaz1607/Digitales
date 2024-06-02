`include "MuxParam.sv"
`include "hotbit.sv"
`include "RegistroFFD.sv"
`timescale 1ns/1ps
module BancoRegistros #(parameter N, Bits) 
  ( 
  input [$clog2(N)-1:0] ptr_rd_1, ptr_rd_2, ptr_wr, //Puntero de rs1, rs2 y rd respectivamente
  input [Bits-1:0] data_wr, //Info para rd
  input wr_en, //Habilitador de escritura
  input rst, clk,
  output reg [Bits-1:0] data_rd_1, data_rd_2 //Info de rs1 y rs2
);
  wire Enable [N-1:0];
  wire [Bits-1:0] D_out [N-1:0];
  wire inverted_clk;
  reg clk_reg;
  always @(posedge clk or negedge clk) begin
    clk_reg <= clk;	  
  end
  assign inverted_clk = !clk_reg;
  hotbit #(.N(N)) Habilitador_escritura (.wr_en(wr_en), .reg_wr_cod(ptr_wr), .Outn(Enable));
  assign D_out[0] = 64'b0;
  genvar i;
  generate
    for(i=1; i < N; i = i + 1) begin: Registro_
      RegistroFFD #(.Bits(Bits)) Registro (.data(data_wr), .enable(Enable[i]) , .clk(clk_reg) ,.rst(rst), .q(D_out[i]));
    end
  endgenerate
  MuxParam #(.N(N), .Bits(Bits)) Mux_rd_1(.read_code(ptr_rd_1), .D(D_out), .Q(data_rd_1));
  MuxParam #(.N(N), .Bits(Bits)) Mux_rd_2(.read_code(ptr_rd_2), .D(D_out), .Q(data_rd_2));
  endmodule
