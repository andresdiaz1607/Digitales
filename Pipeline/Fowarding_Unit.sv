module forwarding_unit(
    input wire [4:0] id_ex_rs1, id_ex_rs2,    //Registros Source
    input wire [4:0] ex_mem_rd,   // Registro destino de EX/MEM
    input wire [4:0] mem_wb_rd,   // Registro destino de MEM/WB 
    input wire ex_mem_regwrite,   // Registro señal escritura EX/MEM 
    input wire mem_wb_regwrite,   // Registro señal escritura MEM/WB 
    output reg [1:0] forward_a,  // MUX rs1
    output reg [1:0] forward_b   // MUX rs2
);

always_comb begin
        forward_a = 2'b00;
        forward_b = 2'b00;

        //forward al rs1 desde EX/MEM
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1)) begin
            forward_a = 2'b10;
        end

        //forward al rs1 desde MEM/WB
        if (mem_wb_regwrite && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs1)) begin
            forward_a = 2'b01;
        end

        //forward al rs2 desde EX/MEM
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2)) begin
            forward_b = 2'b10;
        end

        //forward al rs2 desde MEM/WB
        if (mem_wb_regwrite && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs2)) begin
            forward_b = 2'b01;
        end
    end

endmodule
