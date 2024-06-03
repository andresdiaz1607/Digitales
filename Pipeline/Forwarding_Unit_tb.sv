`include "Fowarding_Unit.sv"
module forwarding_unit_tb;
    // Inputs
    logic [4:0] id_ex_rs1, id_ex_rs2;
    logic [4:0] ex_mem_rd;
    logic [4:0] mem_wb_rd;
    logic ex_mem_regwrite;
    logic mem_wb_regwrite;
    
    // Outputs
    logic [1:0] forward_a;
    logic [1:0] forward_b;

    // Instantiate the forwarding unit
    forwarding_unit uut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),
        .ex_mem_regwrite(ex_mem_regwrite),
        .mem_wb_regwrite(mem_wb_regwrite),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Test procedure
    initial begin
 	$dumpfile("ForwardingUnit.vcd");
      	$dumpvars(0,uut);
        // Test case 1: No forwarding
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00011; mem_wb_rd = 5'b00100;
        ex_mem_regwrite = 0; mem_wb_regwrite = 0;
        #10;
        assert(forward_a == 2'b00 && forward_b == 2'b00) else $fatal("Test case 1 failed");

        // Test case 2: Forwarding from EX/MEM to id_ex_rs1
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00001; mem_wb_rd = 5'b00100;
        ex_mem_regwrite = 1; mem_wb_regwrite = 0;
        #10;
        assert(forward_a == 2'b10 && forward_b == 2'b00) else $fatal("Test case 2 failed");

        // Test case 3: Forwarding from MEM/WB to id_ex_rs1
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00011; mem_wb_rd = 5'b00001;
        ex_mem_regwrite = 0; mem_wb_regwrite = 1;
        #10;
        assert(forward_a == 2'b01 && forward_b == 2'b00) else $fatal("Test case 3 failed");

        // Test case 4: Forwarding from EX/MEM to id_ex_rs2
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00010; mem_wb_rd = 5'b00100;
        ex_mem_regwrite = 1; mem_wb_regwrite = 0;
        #10;
        assert(forward_a == 2'b00 && forward_b == 2'b10) else $fatal("Test case 4 failed");

        // Test case 5: Forwarding from MEM/WB to id_ex_rs2
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00011; mem_wb_rd = 5'b00010;
        ex_mem_regwrite = 0; mem_wb_regwrite = 1;
        #10;
        assert(forward_a == 2'b00 && forward_b == 2'b01) else $fatal("Test case 5 failed");

        // Test case 6: No forwarding to zero register (x0)
        id_ex_rs1 = 5'b00000; id_ex_rs2 = 5'b00000;
        ex_mem_rd = 5'b00000; mem_wb_rd = 5'b00000;
        ex_mem_regwrite = 1; mem_wb_regwrite = 1;
        #10;
        assert(forward_a == 2'b00 && forward_b == 2'b00) else $fatal("Test case 6 failed");

        // Test case 7: Forwarding both from EX/MEM to id_ex_rs1 and MEM/WB to id_ex_rs2
        id_ex_rs1 = 5'b00001; id_ex_rs2 = 5'b00010;
        ex_mem_rd = 5'b00001; mem_wb_rd = 5'b00010;
        ex_mem_regwrite = 1; mem_wb_regwrite = 1;
        #10;
        assert(forward_a == 2'b10 && forward_b == 2'b01) else $fatal("Test case 7 failed");

        $display("All test cases passed!");
        $finish;
    end
endmodule
