module RegistroFFD #(parameter Bits)(data, clk, rst, enable, q);
  input [Bits-1:0] data;
  input clk, rst, enable;
  output reg [Bits-1:0] q;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      q <=  0; 
    end 
    else if (enable) begin
      q <= data;
    end
    else begin
      q <= q;
    end
  end   
endmodule
