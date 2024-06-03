`include "HazardUnit.sv"
module tb_HazardDetectionUnit;

    reg [4:0] IF_ID_RegisterRs1;
    reg [4:0] IF_ID_RegisterRs2;
    reg [4:0] ID_EX_RegisterRd;
    reg ID_EX_MemRead;
    reg IF_ID_MemWrite;
    reg zero,beq;
    wire PCWrite;
    wire IF_ID_Write;
    wire ControlMuxSel;
    wire IF_Flush;

    // Instantiate the hazard detection unit
    HazardDetectionUnit DUT (
        .IF_ID_RegisterRs1(IF_ID_RegisterRs1),
        .IF_ID_RegisterRs2(IF_ID_RegisterRs2),
        .ID_EX_RegisterRd(ID_EX_RegisterRd),
        .ID_EX_MemRead(ID_EX_MemRead),
	.IF_ID_MemWrite(IF_ID_MemWrite),
        .zero(zero),
	.beq(beq),
        .IF_Flush(IF_Flush),
	.PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ControlMuxSel(ControlMuxSel)
    );

    initial begin
	zero = 1'b0;
	beq = 1'b0;
	$dumpfile("HazardUnit.vcd");
      	$dumpvars(0,DUT);
        // Test case 1: No hazard
        IF_ID_RegisterRs1 = 5'd1;
        IF_ID_RegisterRs2 = 5'd2;
        ID_EX_RegisterRd = 5'd3;
        ID_EX_MemRead = 1'b0;
	IF_ID_MemWrite = 1'b0;
        #10;
	zero = 1'b1;
	beq = 1'b1;
	#10
	zero = 1'b0;
	beq = 1'b0;
        // Test case 2: Load-use hazard detected
        IF_ID_RegisterRs1 = 5'd1;
        IF_ID_RegisterRs2 = 5'd2;
        ID_EX_RegisterRd = 5'd1;
        ID_EX_MemRead = 1'b1;
	IF_ID_MemWrite = 1'b0;
        #10;
	
	zero = 1'b0;
	beq = 1'b0;
	#10

        // Test case 3: No hazard
        IF_ID_RegisterRs1 = 5'd6;
        IF_ID_RegisterRs2 = 5'd5;
        ID_EX_RegisterRd = 5'd6;
        ID_EX_MemRead = 1'b0;
	IF_ID_MemWrite = 1'b0;
        #10
        
	zero = 1'b1;
	beq = 1'b1;
        #100

        $finish;
    end
endmodule
