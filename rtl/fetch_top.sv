module fetch_top(
    input logic clk,
    input logic rst,
    input logic [31:0] PCTargetE,
    input logic [31:0] ImmExtE,
    input logic [31:0] ALUResultE,
    input logic [1:0] PCSrcE,
    output logic [31:0] InstrF,
    output logic [31:0] PCF,
    output logic [31:0] PCPlus4F
);
    

logic[31:0] PCFPrime;


always_ff @(posedge clk) begin
    if (rst) begin
        PCF <= '0;
    end
    else begin
        PCF <= PCFPrime;
    end
    
end

always_comb begin
    PCPlus4F = PCF + 32'd4;
    if(rst)begin
        PCFPrime = '0;
    end
    else begin
        /*
        PcSrcE {JumpE,BranchE}
        
        00: No jump/branch
        10:Branch to pc + imm
        11: branch to pc + R[rs1]

        */
        case(PCSrcE)
            2'b00:begin //AGAIN NEVER USE BARE LITERALS LIKE 00 ALWAYS USE 2'B00 OR SOMETHING
                PCFPrime = PCPlus4F;
            end
            2'b10:begin
                PCFPrime = PCTargetE;
            end
            2'b11:begin
                PCFPrime = ALUResultE & ~1;
            end
            default: begin
                PCFPrime = PCPlus4F;
            end
        endcase
    end
end

instr_mem instr_mem_F(
    .addr(PCF),
    .dout(InstrF)
);

endmodule
