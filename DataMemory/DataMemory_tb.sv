`include "DataMemory.sv"
`timescale 1ns/1ps
module Data_Memory_tb #(Bits=64, MemSize=16);

  reg clk;
  reg [Bits-1:0] mem_access_addr;// dirección de acceso, Compartido por read and write port
  reg [Bits-1:0] mem_write_data;// Puerto de escritura
  reg mem_write_en;
  reg mem_read;
  reg [Bits-1:0] mem_read_data;// Puerto de lectura
  Data_Memory #(.Bits(Bits), .MemSize(MemSize)) dut ( .clk(clk), .mem_access_addr(mem_access_addr), .mem_write_data(mem_write_data), .mem_write_en(mem_write_en), .mem_read(mem_read), .mem_read_data(mem_read_data));
  always begin
        #5 clk = ~clk;
  end
  initial 
    begin
      clk <= 0;
      mem_access_addr = 64'd0;
      mem_write_en = 1'b0;
      mem_write_data = 64'd0;
      $dumpfile("DataMemory.vcd");
      $dumpvars(5,dut);
    //Revisamos la información de las posiciones de memoria 1, 2 y 3
      mem_read = 1'b1;
      mem_access_addr = 64'd1;
      #10
      mem_access_addr = 64'd2;
      #10
      mem_access_addr = 64'd3;
      #10
      mem_read = 1'b0;
      #10
    //Guardamos información en la posicion de memoria 1
      mem_write_en = 1'b1;
      #10
      mem_access_addr = 64'd1;
      mem_write_data = 64'hfa5b9;
      #10
      mem_write_en = 1'b0;
      #10
    //Accesamos a la información de la posición de memoria
      mem_read = 1'b1;
      mem_access_addr = 64'd1;
      mem_read = 1'b0;
      #10
    //Se repite el proceso sin habilitar la lectura ni la escirtura
      mem_read = 1'b0;
      mem_access_addr = 64'd1;
      #10
      mem_write_data = 64'd256;
      mem_access_addr = 64'd5;
      #10
    //Hacemos lectura del registro 1  para corrobar la información que se
    //guardó
      mem_read = 1'b1;
      mem_access_addr = 64'd1;
      #10
      mem_read = 1'b0;
      #10
      $finish;
   end 
endmodule
