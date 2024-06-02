`include "Fowarding_Unit_2.sv"
module Forwarding_Unit_2_tb ();
  reg EX_MEM_MemWrite, MEM_WB_RegWrite;
  reg [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd;
  wire Sel_A, Sel_B;
  forwarding_unit_2 uut (.EX_MEM_MemWrite(EX_MEM_MemWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), .ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .Sel_A(Sel_A), .Sel_B(Sel_B));
  initial begin
    $dumpfile("Forwarding_Unit_2.vcd");
    $dumpvars(0,uut);
    //Rs1 == Rd
    EX_MEM_MemWrite = 1'b1;
    MEM_WB_RegWrite = 1'b1;
    ID_EX_Rs1 = 5'b1;
    ID_EX_Rs2 = 5'b0; 
    EX_MEM_Rd = 5'b1;
    #10
    
    //Rs2 == Rd
    EX_MEM_MemWrite = 1'b1;
    MEM_WB_RegWrite = 1'b1;
    ID_EX_Rs1 = 5'b0;
    ID_EX_Rs2 = 5'b1;
    EX_MEM_Rd = 5'b1;
    #10
    
    //Regwrite inhabiitado 
    EX_MEM_MemWrite = 1'b1;
    MEM_WB_RegWrite = 1'b0;
    ID_EX_Rs1 = 5'b1;
    ID_EX_Rs2 = 5'b0;
    EX_MEM_Rd = 5'b1;
    #10
    
    //MemWrite deshabilitado
    EX_MEM_MemWrite = 1'b0;
    MEM_WB_RegWrite = 1'b1;
    ID_EX_Rs1 = 5'b1;
    ID_EX_Rs2 = 5'b0;
    EX_MEM_Rd = 5'b1;
    #10
    $finish;
    end

endmodule

