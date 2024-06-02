module forwarding_unit_2 (
  input wire EX_MEM_MemWrite,
  input wire MEM_WB_RegWrite,
  input wire [4:0] ID_EX_Rs1,
  input wire [4:0] ID_EX_Rs2,
  input wire [4:0] EX_MEM_Rd,
  output reg Sel_A,
  output reg Sel_B
  );

  always_comb begin
    if ((ID_EX_Rs1 == EX_MEM_Rd) && (EX_MEM_Rd != 5'b0) && (EX_MEM_MemWrite) && (MEM_WB_RegWrite)) begin
      Sel_A = 1'b1;
      Sel_B = 1'b0;
      end
    else if ((ID_EX_Rs2 == EX_MEM_Rd) && (EX_MEM_Rd != 5'b0) && (EX_MEM_MemWrite) && (MEM_WB_RegWrite)) begin
      Sel_B = 1'b1;
      Sel_A = 1'b0;
      end
    else begin
      Sel_A = 1'b0;
      Sel_B = 1'b0;
      end
    end

endmodule
  
