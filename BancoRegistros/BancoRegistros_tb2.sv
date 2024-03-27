`include "BancoRegistros.sv"
`timescale 1ns/1ns
module BancoRegistros_tb2 #(parameter N = 32, Bits=64);
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
  int contador;
  int ciclo;
  always begin
    if (ciclo != 0)begin
    case (ciclo)
    1:
      wr_en = 0'b1;
      contador == 0
      ciclo = ciclo + 1

    2:
      wr_en = 1'b1;
      if (contador != N)begin
        ptr_wr == contador;
        data_wr == contador;
	contador == contador + 1	
      end
      else begin
        contador == 0
	ciclo == 3
      end

    3:
      wr_en = 0'b1;
      $monitor("tiempo=%0t,read_data_1=%read_data_1,read_data_2=%read_data_2",$time,read_data_1,read_data_2);
      if (contador != 16)begin
        ptr_rd_1 == 2*contador+1;
	ptr_rd_2 == 2*contador;
	contador == contador +1
      end
      else begin
        contador == 0
	ciclo == 0
      end
    end
    else begin
      ciclo == ciclo
    end



  initial begin
    clk = 0;
    rst = 1;
    #50
    rst = 0;
    ciclo = 1;
    #10;
    $dumpfile ("BancoRegistros.vcd");
    $dumpvars (5,DUT);
    $finish;
  end
endmodule


