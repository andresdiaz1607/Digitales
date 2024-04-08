`timescale 1ns / 1ps 
module Control_Unit(
  input[2:0] Opcode,
  input z,
  output reg [1:0] alu_op,
  output reg beq,mem_read,mem_write,alu_src,mem_to_reg,reg_write);
  always @(*)
    begin

      case(Opcode) 
        3'b000: // LW
          begin
	    alu_src = 1'b1;
            mem_to_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            mem_write = 1'b0;
            beq = 1'b0;
	    alu_op = 2'b00;
          end
        3'b001: // SW
          begin
            alu_src = 1'b1;
            mem_to_reg = 1'b0;
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b1;
            beq = 1'b0;
            alu_op = 2'b00;
          end
        3'b010: // Data Processing: Suma
          begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            beq = 1'b0;
            alu_op = 2'b00;
          end
	3'b011: // Data Processing: Resta
          begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            beq = 1'b0;
            alu_op = 2'b01;
          end
        3'b100: // Data Processing: And lógico
          begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            beq = 1'b0;
            alu_op = 2'b10;
          end
        3'b101: // Data Processing: Or lógico
          begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            beq = 1'b0;
            alu_op = 2'b11;
          end
        3'b110: // BEQ
          begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
	    beq = 1'b1;
            alu_op = 2'b01;
          end
	default:
	  begin
            alu_src = 1'b0;
            mem_to_reg = 1'b0;
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            beq = 1'b0;
            alu_op = 2'b00;
          end

        endcase
     end
endmodule
