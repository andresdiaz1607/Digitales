`include "BancoRegistros.sv"
`timescale 1ns/1ps
module BancoRegistros_tb #(parameter N = 32, Bits=64);
  reg [$clog2(N)-1:0] ptr_rd_1; //Puntero rs1
  reg [$clog2(N)-1:0] ptr_rd_2; //Puntero rs2
  reg [$clog2(N)-1:0] ptr_wr; //Puntero de rd
  reg [Bits-1:0] data_wr;  //Info para rd
  reg wr_en; //Habilitador de escritura
  reg rst, clk;
  wire [Bits-1:0] data_rd_1;
  wire [Bits-1:0] data_rd_2;
  BancoRegistros #(.N(N), .Bits(Bits)) DUT (.ptr_rd_1(ptr_rd_1), .ptr_rd_2(ptr_rd_2), .ptr_wr(ptr_wr), .data_wr(data_wr), .wr_en(wr_en), .rst(rst), .clk(clk), .data_rd_1(data_rd_1), .data_rd_2(data_rd_2));
  always #50 clk=~clk;
  initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    ptr_wr = 5'd0;
    ptr_rd_1 = 5'd0;
    ptr_rd_2 = 5'd0;
    $dumpfile ("BancoRegistros.vcd");
    $dumpvars (5,DUT);
    ptr_rd_1 = 5'd1;
    ptr_rd_2 = 5'd4;
    wr_en = 1'b1;
    data_wr = 64'd1;
    ptr_wr = 5'd1;
    #50;
    data_wr = 64'd2;
    ptr_wr = 5'd2;
    #50;
    ptr_rd_1 = 5'd2;
    ptr_rd_2 = 5'd3;
    data_wr = 64'd3;
    ptr_wr = 5'd3;
    #50;
    data_wr = 64'd4;
    ptr_wr = 5'd4;
    #50;
    ptr_rd_1 = 5'd0;
    ptr_rd_2 = 5'd4;
    #150
    $finish;
  end
endmodule

