`timescale 1ns/1ps
module Data_Memory#(Bits = 64, MemSize = 16)(
  input clk,
  input [Bits-1:0] mem_access_addr,// dirección de acceso, Compartido por read and write port
  input [Bits-1:0] mem_write_data,// Puerto de escritura
  input mem_write_en, 
  input mem_read,
  output [Bits-1:0] mem_read_data);// Puerto de lectura
  reg [Bits - 1:0] memory [MemSize - 1:0]; //Arreglo de memoria para cargar la ram
  wire [Bits-1:0] ram_addr = mem_access_addr[Bits-1:0]; 
  initial
  begin
    $readmemb("Data.mem", memory); //Lectura de memoria
  end
  always @(posedge clk) begin
    if (mem_write_en)
      memory[ram_addr] <= mem_write_data;
  end
  assign mem_read_data = (mem_read==1'b1) ? memory[ram_addr]:16'd0;
endmodule
