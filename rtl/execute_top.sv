module execute_top(
    input logic            RegWriteE_in,
    input logic            ALUSrcE,
    input logic [3:0]      ALUControlE,
    input logic            MemwriteE_in,
    input logic [2:0]      ResultSrcE_in,
    input logic [31:0]     ImmExtE_in,
    input logic [4:0]      RdE_in,
    input logic [31:0]     Rd1E,
    input logic [31:0]     PcE,
    input logic            BranchE,
    input logic            JumpE,
    input logic [31:0]     Rd2E,
    input logic [31:0]     PcPlus4E_in,
    input logic            eq_checkE,
    output logic           RegWriteE_out,
    output logic [1:0]     ResultSrcE_out,
    output logic           MemwriteE_out,
    output logic [31:0]    PcTargetE,
    output logic [31:0]    ALUResultE,
    output logic [31:0]    ImmExtE_out,
    output logic [31:0]    WriteDataE,
    output logic [31:0]    PcPlus4E_out,
    output logic [4:0]     RdE_out,
    output logic [1:0]    PCSrcE
);
    
logic           zeroE;
logic [31:0]    SrcBE;
logic           Zero_temp;
logic           Branch_check;

always_comb begin
    Zero_temp = (eq_checkE) ? (zeroE) : (!zeroE);
    Branch_check = (BranchE & Zero_temp) ? (1'b1) : (1'b0);
    PCSrcE = {JumpE,Branch_check};

    RdE_out = RdE_in;
    PcPlus4E_out = PcPlus4E_in;
    RegWriteE_out = RegWriteE_out;
    MemwriteE_out = MemwriteE_in;
    ResultSrcE_out = ResultSrcE_in;
    ImmExtE_out = ImmExtE_in;

    
    PcTargetE = PcE + ImmExtE_in;

    SrcBE = (ALUSrcE) ? (ImmExtE_in) : (Rd2E);

    WriteDataE = Rd2E;
end

alu alu(
    .a(Rd1E),
    .b(SrcBE),
    .alu_op(ALUControlE),
    .result(ALUResultE),
    .zero(zeroE)      // result == 0 flag
);

endmodule
