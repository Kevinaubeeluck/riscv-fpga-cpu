module MEM_WB(
    input logic        clk,
    input logic [31:0] PcPlus4M_out,
    input logic [31:0] ALUResultM_out,
    input logic [31:0] ImmExtM_out,
    input logic [31:0] PcTargetM_out,
    input logic [4:0]  RdM_out,
    input logic [2:0]  ResultSrcM_out,
    input logic        RegWriteM_out,
    input logic [31:0] ReadDataM,
    
    output logic         RegWriteW_in,
    output logic [2:0]   ResultSrcW,
    output logic [4:0]   RdW_in,
    output logic [31:0]  ALUResultW,
    output logic [31:0]  ReadDataW,
    output logic [31:0]  PcPlus4W,
    output logic [31:0]  PcTargetW,
    output logic [31:0]  ImmExtW
);

always_ff @(posedge clk) begin
    RegWriteW_in <= RegWriteM_out;
    ResultSrcW <= ResultSrcM_out;
    ALUResultW <= ALUResultM_out;
    ReadDataW <= ReadDataM;
    PcPlus4W <= PcPlus4M_out;
    PcTargetW <= PcTargetM_out;
    ImmExtW <= ImmExtM_out;
    RdW_in <= RdM_out;
end
    
endmodule
