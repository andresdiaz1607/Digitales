`include "InstructionMemory.sv"
`include "Decodificador_Instrucciones.sv"
`include "BancoRegistros.sv"
`include "DataMemory.sv"
`include "GeneradorImm.sv"
`include "ALU_Unit.sv"
`include "Fowarding_Unit.sv"
`include "Fowarding_Unit_2.sv" 
`include "HazardUnit.sv"
module Datapath_Unit#(Bits, MemSize, N, NumInst)(
  input clk, rst,
  input beq,mem_read,mem_write,alu_src,mem_to_reg,reg_write,
  input [1:0] alu_op,
  output [2:0] Opcode
  );
  reg [31:0] pc_current;
  wire [31:0] pc_next, pc2;
  wire [31:0] offset, Instruction;
  wire [2:0] cod_ins;
  wire [$clog2(N)-1:0] reg_write_dest;
  wire [Bits-1:0] reg_write_data;
  wire [$clog2(N)-1:0] reg_read_addr_1;
  wire [Bits-1:0] reg_read_data_1;
  wire [$clog2(N)-1:0] reg_read_addr_2;
  wire [Bits-1:0] reg_read_data_2;
  wire [Bits-1:0] im_ext,read_data2, read_data1;
  wire [Bits-1:0] ALU_out;
  wire zero_flag;
  wire PCSrc;
  wire [31:0] PC_beq;
  wire [Bits-1:0] mem_read_data;
  wire [Bits-1:0] reg_read_data2;
  wire [1:0] SelOpA;
  wire [1:0] SelOpB;
  wire Sel_1;
  wire Sel_2;
  wire PCWrite, IF_ID_Write, ControlMuxSel, IF_Flush;
  reg beq1,mem_read1,mem_write1,alu_src1,mem_to_reg1,reg_write1;
  reg [1:0] alu_op1;
  reg [Bits-1:0] OperandDataA;
  reg [Bits-1:0] OperandDataB;

  //Datapath registers
  //If: Instruction fetch
  //Id: Instruction decode
  //Ex: Execute
  //Mem: Memory acces
  //Wb: Write back

  //IF/ID registros
  reg [31:0] IF_ID_pc;
  reg [31:0] IF_ID_Instruction;

  //ID/EX registros
  reg [$clog2(N)-1:0] ID_EX_Rs1;
  reg [$clog2(N)-1:0] ID_EX_Rs2;
  reg [Bits-1:0] ID_EX_ReadData1;
  reg [Bits-1:0] ID_EX_ReadData2;
  reg [$clog2(N)-1:0] ID_EX_Rd;
  reg [Bits-1:0] ID_EX_Inmediato;

  //EX/MEM registros
  reg EX_MEM_zero;
  reg [Bits-1:0] EX_MEM_ALUresult;
  reg [$clog2(N)-1:0] EX_MEM_Rd;
  reg [Bits-1:0] EX_MEM_RegData;
  
  //MEM/WEB registros
  reg [Bits-1:0] MEM_WB_MemData;
  reg [Bits-1:0] MEM_WB_ALUresult;
  reg [$clog2(N)-1:0] MEM_WB_Rd;

  //Control Signal Registers
  //EX stage
  reg [1:0] Ex_ALUOp;
  reg Ex_ALUSrc;
  reg Ex_Branch;
  reg Ex_MemWrite;
  reg Ex_MemRead;
  reg Ex_MemtoReg;
  reg Ex_RegWrite;

  //MEM stage
  reg Mem_Branch;
  reg Mem_MemWrite;
  reg Mem_MemRead;
  reg Mem_MemtoReg;
  reg Mem_RegWrite;

  //WB Stage
  reg Wb_MemtoReg;
  reg Wb_RegWrite;

  //Datapatah Stages
  //Instruction Fetch
  always @(posedge clk or posedge rst or negedge PCWrite) 
    if (rst) begin
      pc_current <= 32'd0;
    end
    else if (PCWrite) begin
	   pc_current <= pc_next;
          end
  assign pc2 = pc_current + 32'd4;
  assign pc_next = (PCSrc == 1'b1) ? PC_beq : pc2;

  //Memoria de Instrucciones|
  InstructionMemory #(
    .NumInst(NumInst)
    ) Memoria_Instrucciones (
    .clk(clk), 
    .Addres(pc_current),
    .Instruction(Instruction));

  //IF/ID Pipe
  always @(posedge clk or posedge rst or posedge IF_Flush)
     if (rst || IF_Flush) begin
	IF_ID_pc <= 32'b0;
        IF_ID_Instruction <= 32'b0;
     end 
     else if(IF_ID_Write) begin
            IF_ID_pc <= pc_current;
            IF_ID_Instruction <= Instruction;
     end
          
  //Instruction Decode Stage
  
  //Lógica de porgram counter del branch
  assign PC_beq = IF_ID_pc + im_ext;
  //Decodificador De Instrucciones
  Decodificador_Instrucciones Decodificador (.clk(clk), .Instruction(IF_ID_Instruction), .Opcode(cod_ins), .Rs1(reg_read_addr_1), .Rs2(reg_read_addr_2), .Rd(reg_write_dest), .Offset(offset));
  //Registros de propósito general
    BancoRegistros 
    #(.N(N), 
    .Bits(Bits))
    GPRs (
   .clk(clk), 
   .rst(rst), 
   .wr_en(Wb_RegWrite), 
   .ptr_rd_1(reg_read_addr_1), 
   .ptr_rd_2(reg_read_addr_2), 
   .ptr_wr(MEM_WB_Rd), 
   .data_wr(reg_write_data), 
   .data_rd_1(reg_read_data_1), 
   .data_rd_2(reg_read_data_2));

    //Generador de Inmediato
    GeneradorImm #(
       .Bits(Bits)) 
      InmSext (
       .Offset(offset),
       .Inmediato(im_ext));

    //Hazard Detection Unit
    HazardDetectionUnit Unidad_de_riesgo (.IF_ID_RegisterRs1(reg_read_addr_1), .IF_ID_RegisterRs2(reg_read_addr_2), .ID_EX_RegisterRd(ID_EX_Rd), .ID_EX_MemRead(Ex_MemRead), .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .ControlMuxSel(ControlMuxSel), .IF_Flush(IF_Flush), .zero(zero_flag));

    //Mux de señales de control para meter stalls
    always_comb begin
      if (ControlMuxSel) begin
	alu_op1 <= 1'b0;
        alu_src1 <= 1'b0;
        beq1 <= 1'b0; 
        mem_write1 <= 1'b0;
        mem_read1 <= 1'b0;
        mem_to_reg1 <= 1'b0;
        reg_write1 <= 1'b0;
     end
     else begin
	alu_op1 <= alu_op ;
        alu_src1 <= alu_src ;
        beq1 <= beq;
        mem_write1 <= mem_write;
        mem_read1 <= mem_read;
        mem_to_reg1 <= mem_to_reg;
        reg_write1 <= reg_write;
     end

    end

    //código para control
    assign Opcode = cod_ins;

    //ID/EX Pipe
    always @(posedge clk or posedge rst) 
      if (rst) begin
        ID_EX_Rs1 <= 5'b0;
        ID_EX_Rs2 <= 5'b0;
        ID_EX_ReadData1 <= 64'b0;
        ID_EX_ReadData2 <= 64'b0;
        ID_EX_Rd <= 32'b0;
        ID_EX_Inmediato <= 64'b0;
     end
      else begin
        ID_EX_Rs1 <= reg_read_addr_1;
        ID_EX_Rs2 <= reg_read_addr_2;
        ID_EX_ReadData1 <= reg_read_data_1;
        ID_EX_ReadData2 <= reg_read_data_2;
        ID_EX_Rd <= reg_write_dest;
        ID_EX_Inmediato <= im_ext;
    end

    //Control Signal registers
    //ID/EX Pipe
    always @(posedge clk or posedge rst) 
      if (rst) begin
        Ex_ALUOp <= 2'b0;
        Ex_ALUSrc <= 1'b0;
        Ex_Branch <= 1'b0;
        Ex_MemWrite <= 1'b0;
        Ex_MemRead <= 1'b0;
        Ex_MemtoReg <= 1'b0;
        Ex_RegWrite <= 1'b0;
      end
      else begin
        Ex_ALUOp <= alu_op1;
        Ex_ALUSrc <= alu_src1;
        Ex_Branch <= beq1;
        Ex_MemWrite <= mem_write1;
        Ex_MemRead <= mem_read1;
        Ex_MemtoReg <= mem_to_reg1;
        Ex_RegWrite <= reg_write1;
    end


    //Execute Stage
    //Unidad de Adelantamiento numero 1
    forwarding_unit Unidad_de_Adelantamiento_1 (.id_ex_rs1(ID_EX_Rs1), .id_ex_rs2(ID_EX_Rs2), .ex_mem_rd(EX_MEM_Rd), .mem_wb_rd(MEM_WB_Rd), .ex_mem_regwrite(Mem_RegWrite), .mem_wb_regwrite(Wb_RegWrite), .forward_a(SelOpA), .forward_b(SelOpB));
    
    //Unidad de adelantamiento 2
    forwarding_unit_2 Unidad_de_Adelantamiento_2 (.ID_EX_MemWrite(Ex_MemWrite), .EX_MEM_RegWrite(Mem_RegWrite), .ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .Sel_A(Sel_1), .Sel_B(Sel_2));
    
    //Muxes de operandos de ALU
    always_comb begin 
	    case(SelOpA) 
	      00:
		      assign OperandDataA = ID_EX_ReadData1;

	      01:
		      assign OperandDataA = reg_write_data;

	      10:
		      assign OperandDataA = EX_MEM_ALUresult;
           endcase

           case(SelOpB)
		   00:
			   OperandDataB = ID_EX_ReadData2;

	           01:
                           OperandDataB = reg_write_data;

                   10:
                           OperandDataB = EX_MEM_ALUresult;
           endcase
   end
    //Mux fuente para operando B de Alu
    assign read_data2 = (Ex_ALUSrc == 1'b1) ? ID_EX_Inmediato : OperandDataB;

    //Mux fuente para operando B de Alu
    assign read_data1 = (Sel_1 == 1'b1) ?  mem_read_data : OperandDataA;
    assign reg_read_data2 = (Sel_2 == 1'b1) ? mem_read_data : OperandDataB;

    //Unidad ALU
    ALU_Unit #(
     .Bits(Bits)) 
    UnidadALU (
     .A(read_data1), 
     .B(read_data2), 
     .sel(Ex_ALUOp), 
     .resultado(ALU_out),
     .zero(zero_flag));
    
    
    //EX/MEM Pipe
    always @(posedge clk or posedge rst) 
      if (rst) begin
        EX_MEM_ALUresult <= 64'b0;
        EX_MEM_zero <= 1'b0;
        EX_MEM_Rd <= 5'b0;
        EX_MEM_RegData <= 64'b0;
     end
     else begin
       EX_MEM_ALUresult <= ALU_out;
       EX_MEM_zero <= zero_flag;
       EX_MEM_Rd <= ID_EX_Rd;
       EX_MEM_RegData <= reg_read_data2;
     end

    //Data Control signals
    //EX/MEM Pipe
    always @(posedge clk or posedge rst)
      if (rst) begin
        Mem_Branch <= 1'b0;
        Mem_MemWrite <= 1'b0;
        Mem_MemRead <= 1'b0;
        Mem_MemtoReg <= 1'b0;
        Mem_RegWrite <= 1'b0;
      end 
      else begin
        Mem_Branch <= Ex_Branch;
        Mem_MemWrite <= Ex_MemWrite;
        Mem_MemRead <= Ex_MemRead;
        Mem_MemtoReg <= Ex_MemtoReg;
        Mem_RegWrite <= Ex_RegWrite;
    end


    //Memory Access Stage
    //Lógica de program counter de beq o siguiente inst
    assign PCSrc = Mem_Branch & EX_MEM_zero;


    //Banco de memoria de informacióni
    Data_Memory #(
      .Bits(Bits), 
      .MemSize(MemSize)) 
      Memoria_Informacion (
      .clk(clk), 
      .mem_access_addr(EX_MEM_ALUresult), 
      .mem_write_data(EX_MEM_RegData), 
      .mem_write_en(Mem_MemWrite), 
      .mem_read(Mem_MemRead), 
      .mem_read_data(mem_read_data));

    //MEM/WB Pipe
    always @(posedge clk or posedge rst) 
      if (rst) begin
        MEM_WB_MemData <= 64'b0;
        MEM_WB_Rd <= 5'b0;
        MEM_WB_ALUresult <= 64'b0;
      end
      else begin
        MEM_WB_MemData <= mem_read_data;
        MEM_WB_Rd <= EX_MEM_Rd;
        MEM_WB_ALUresult <= EX_MEM_ALUresult;
    end

    //Control signal
    always @(posedge clk or posedge rst)
      if (rst) begin
        Wb_MemtoReg <= 1'b0;
        Wb_RegWrite <= 1'b0;
      end
      else begin
        Wb_MemtoReg <= Mem_MemtoReg;
        Wb_RegWrite <= Mem_RegWrite;
    end



 //Mux para información a escribir en registros para ld
  
  assign reg_write_data = (Wb_MemtoReg == 1'b1) ? MEM_WB_MemData : MEM_WB_ALUresult;
endmodule
