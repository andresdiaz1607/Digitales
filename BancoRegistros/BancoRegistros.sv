`include "MuxParam.sv"
`include "hotbit.sv"
`include "RegistroFFD.sv"
module BancoRegistros #(parameter N = 32, Bits = 64) 
  ( 
  input [$clog2(N)-1:0] ptr_rd_1, ptr_rd_2, ptr_wr, //Puntero de rs1, rs2 y rd respectivamente
  input [Bits-1:0] data_wr, //Info para rd
  input wr_en, //Habilitador de escritura
  input rst, clk,
  output reg [Bits-1:0] data_rd_1, data_rd_2 //Info de rs1 y rs2
);  
  wire Enable [N-1:0];
  wire [Bits-1:0] D_out [N-1:0] ;
  hotbit #(.N(N)) Habilitador_escritura (.wr_en(wr_en), .reg_wr_cod(ptr_wr), .Outn(Enable));
  genvar i;
  generate
    for(i=0; i < N; i = i + 1) begin: Registro_
      RegistroFFD #(.Bits(Bits))(.data(data_wr), .clk(Enable[i]) ,.rst(rst), .q(D_out[i]));
    end
  endgenerate
  MuxParam #(.N(N), .Bits(Bits)) Mux_rd_1(.read_code(ptr_rd_1), .D(D_out), .Q(data_rd_1));
  MuxParam #(.N(N), .Bits(Bits)) Mux_rd_2(.read_code(ptr_rd_2), .D(D_out), .Q(data_rd_2));
  endmodule
