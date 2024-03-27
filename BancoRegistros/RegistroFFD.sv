module RegistroFFD #(parameter Bits = 64)(data, clk, rst, q);
  input [Bits-1:0] data;
  input clk, rst;
  output reg [Bits-1:0] q;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <=  0; 
    end 
    else begin
        q <= data;
    end
  end   
endmodule
