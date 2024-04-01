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
  always #10 clk=~clk;
  initial begin
    wr_en = 1'b0;
    ptr_wr = 5'd0;
    data_wr = 64'd0;
    ptr_rd_1 = 5'd0;
    ptr_rd_2 = 5'd0;
    $dumpfile ("BancoRegistros.vcd");
    $dumpvars (5,DUT);
    clk = 0;
    rst = 1;
    #20;
    rst = 0;
    wr_en = 1'b1;
    #20;
    ptr_wr = 5'd1;
    data_wr = 64'd10;
    #20
    ptr_wr = 5'd2;
    data_wr = 64'd20;
    #20
    ptr_wr = 5'd3;
    data_wr = 64'd30;
    #20
    ptr_wr = 5'd4;
    data_wr = 64'd40;
    #20
    ptr_wr = 5'd5;
    data_wr = 64'd50;
    #20
    ptr_wr = 5'd6;
    data_wr = 64'd60;
    #20
    ptr_rd_1 = 5'd1;
    ptr_rd_2 = 5'd2;
    #20
    ptr_rd_1 = 5'd3;
    ptr_rd_2 = 5'd4;
    wr_en = 1'b0;
    data_wr = 64'd1;
    ptr_wr = 5'd1;
    #20;
    data_wr = 64'd2;
    ptr_wr = 5'd2;
    #20;
    ptr_rd_1 = 5'd5;
    ptr_rd_2 = 5'd6;
    data_wr = 64'd3;
    ptr_wr = 5'd3;
    #20;
    data_wr = 64'd4;
    ptr_wr = 5'd4;
    #20;
    ptr_rd_1 = 5'd1;
    ptr_rd_2 = 5'd2;
    #40
    $finish;
  end
endmodule

