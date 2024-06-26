module HazardDetectionUnit(
    input wire [4:0] IF_ID_RegisterRs1,
    input wire [4:0] IF_ID_RegisterRs2,
    input wire [4:0] ID_EX_RegisterRd,
    input wire ID_EX_MemRead,
    input wire IF_ID_MemWrite,
    input wire zero, beq,
    output reg IF_Flush,
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ControlMuxSel
);

    always_comb begin
        // Check for load-use hazard
	// Stall pipeline
        if (ID_EX_MemRead && !IF_ID_MemWrite  && (ID_EX_RegisterRd != 5'b0) && ((ID_EX_RegisterRd == IF_ID_RegisterRs1) || (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
          PCWrite = 1'b0;
          IF_ID_Write = 1'b0;
          ControlMuxSel = 1'b1;
	  IF_Flush = 1'b0;
        end
	
	// Default control signals
	else begin
          PCWrite = 1'b1;
          IF_ID_Write = 1'b1;
          ControlMuxSel = 1'b0;
	  IF_Flush = 1'b0;
	end

	if(zero && beq) begin
          PCWrite = 1'b0;
          IF_ID_Write = 1'b0;
          ControlMuxSel = 1'b1;
          IF_Flush = 1'b1;
        end

   end
endmodule
