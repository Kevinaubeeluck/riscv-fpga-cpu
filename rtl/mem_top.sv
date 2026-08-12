module mem_top(
    input logic         clk,
    input logic         RegWriteM_in,
    input logic [2:0]   ResultSrcM_in,
    input logic         MemwriteM,
    input logic [31:0]  ALUResultM_in,
    input logic [31:0]  PcTargetM_in,
    input logic [31:0]  ImmExtM_in,
    input logic [31:0]  WriteDataM,
    input logic [4:0]  RdM_in,
    input logic [31:0]  PcPlus4M_in,
    output logic [31:0] PcPlus4M_out,
    output logic [31:0] ALUResultM_out,
    output logic [31:0] ImmExtM_out,
    output logic [31:0] PcTargetM_out,
    output logic [4:0] RdM_out,
    output logic [2:0]  ResultSrcM_out,
    output logic        RegWriteM_out,
    output logic [31:0] ReadDataM
);

always_comb begin
    ImmExtM_out = ImmExtM_in;
    RdM_out = RdM_in;
    PcPlus4M_out = PcPlus4M_in;
    RegWriteM_out = RegWriteM_in;
    ResultSrcM_out = ResultSrcM_in;
    ALUResultM_out = ALUResultM_in;
    PcTargetM_out = PcTargetM_in;
end


d_mem d_mem (
    .addr(ALUResultM_in),
    .wd(WriteDataM),
    .clk(clk),
    .we(MemwriteM),
    .rd(ReadDataM)
);    

endmodule
