module EX_MEM(
    input logic           clk,
    input logic           RegWriteE_out,
    input logic [2:0]     ResultSrcE_out,
    input logic           MemwriteE_out,
    input logic [31:0]    PcTargetE,
    input logic [31:0]    ALUResultE,
    input logic [31:0]    ImmExtE_out,
    input logic [31:0]    WriteDataE,
    input logic [31:0]    PcPlus4E_out,
    input logic [4:0]     RdE_out,
    output logic         RegWriteM_in,
    output logic [2:0]   ResultSrcM_in,
    output logic         MemwriteM,
    output logic [31:0]  ALUResultM_in,
    output logic [31:0]  PcTargetM_in,
    output logic [31:0]  ImmExtM_in,
    output logic [31:0]  WriteDataM,
    output logic [4:0]  RdM_in,
    output logic [31:0]  PcPlus4M_in
);
    

always_ff @(posedge clk) begin
    RegWriteM_in <= RegWriteE_out;
    ResultSrcM_in <= ResultSrcE_out;
    MemwriteM <= MemwriteE_out;
    ALUResultM_in <= ALUResultE;
    PcTargetM_in <= PcTargetE;
    ImmExtM_in <= ImmExtE_out;
    WriteDataM <= WriteDataE;
    RdM_in <= RdE_out;
    PcPlus4M_in <=PcPlus4M_in;
end

endmodule
