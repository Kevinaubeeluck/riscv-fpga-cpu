module pipeline_top(
    input clk,
    input rst 
);
    

logic [31:0] InstrF;
logic [31:0] PCF;
logic [31:0] PCPlus4F;
logic [31:0] InstrD;

logic [31:0]     PcD_in;
logic [31:0]     PcPlus4D_in;
logic            RegWriteW_out;
logic [4:0]      RdW_out;
logic [4:0]      RdW_in;
logic [31:0]     ResultW;
logic            RegWriteD;
logic            ALUSrcD;
logic [3:0]      ALUControlD;
logic            MemwriteD;
logic [2:0]      ResultSrcD;
logic [31:0]     ImmExtD;
logic [4:0]      RdD;
logic [31:0]     Rd1D;
logic [31:0]     PcD_out;
logic            BranchD;
logic            JumpD;
logic [31:0]     Rd2D;
logic [31:0]     PcPlus4D_out;
logic [4:0]     Rs2D;
logic [4:0]     Rs1D;
logic            eq_checkD;

logic            RegWriteE_in;
logic            ALUSrcE;
logic [3:0]      ALUControlE;
logic            MemwriteE_in;
logic [2:0]      ResultSrcE_in;
logic [31:0]     ImmExtE_in;
logic [4:0]      RdE_in;
logic [31:0]     Rd1E;
logic [4:0]     Rs2E;
logic [4:0]     Rs1E;
logic [31:0]     PcE_in;
logic            BranchE;
logic            JumpE;
logic [31:0]     Rd2E;
logic [31:0]     PcPlus4E_in;
logic            eq_checkE;

logic           RegWriteE_out;
logic [2:0]     ResultSrcE_out;
logic           MemwriteE_out;
logic [31:0]    PcTargetE;
logic [31:0]    ALUResultE;
logic [31:0]    ImmExtE_out;
logic [31:0]    WriteDataE;
logic [31:0]    PcPlus4E_out;
logic [4:0]     RdE_out;
logic [31:0]    PcE_out;
logic [1:0]     PcSrcE;

logic [31:0] PcPlus4M_out;
logic [31:0] PcPlus4M_in;
logic        MemwriteM;
logic [31:0] ALUResultM_out;
logic [31:0] ALUResultM_in;
logic [31:0] PcTargetM_out;
logic [31:0] WriteDataM;
logic [31:0] ImmExtM_out;
logic [31:0] ImmExtM_in;
logic [31:0] PcTargetM_in;
logic [4:0] RdM_out;
logic [4:0] RdM_in;
logic [2:0]  ResultSrcM_out;
logic [2:0]  ResultSrcM_in;
logic        RegWriteM_out;
logic        RegWriteM_in;
logic [31:0] ReadDataM;

logic         RegWriteW_in;
logic [2:0]   ResultSrcW;
logic [31:0]  ALUResultW;
logic [31:0]  ReadDataW;
logic [31:0]  PcPlus4W;
logic [31:0]  PcTargetW;
logic [31:0]  ImmExtW;

logic [1:0]    ForwardAE;
logic [1:0]    ForwardBE;
logic [4:0]      Rs1E_in;
logic [4:0]      Rs2E_in;
logic [4:0]      Rs1E_out;
logic [4:0]      Rs2E_out;



fetch_top fetch_top(
    .clk(clk),
    .rst(rst),
    .PCTargetE(PcTargetE),
    .ImmExtE(ImmExtE_out),
    .ALUResultE(ALUResultE),
    .PCSrcE(PcSrcE),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F)
);

IF_ID IF_ID(
    .clk(clk),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .InstrD(InstrD),
    .PcD(PcD_in),
    .PCPlus4D(PcPlus4D_in)
);

decode_top decode_top(
    .clk(clk),
    .InstrD(InstrD),
    .PcD_in(PcD_in),
    .PcPlus4D_in(PcPlus4D_in),
    .RegWriteW(RegWriteW_out),
    .RdW(RdW_out),
    .ResultW(ResultW),
    .RegWriteD(RegWriteD),
    .ALUSrcD(ALUSrcD),
    .ALUControlD(ALUControlD),
    .MemwriteD(MemwriteD),
    .ResultSrcD(ResultSrcD),
    .ImmExtD(ImmExtD),
    .RdD(RdD),
    .Rd1D(Rd1D),
    .PcD_out(PcD_out),
    .BranchD(BranchD),
    .JumpD(JumpD),
    .Rd2D(Rd2D),
    .PcPlus4D_out(PcPlus4D_out),
    .eq_checkD(eq_checkD),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D)
);

ID_EX ID_EX(
    .clk(clk),
    .RegWriteD(RegWriteD),
    .ALUSrcD(ALUSrcD),
    .ALUControlD(ALUControlD),
    .MemwriteD(MemwriteD),
    .ResultSrcD(ResultSrcD),
    .ImmExtD(ImmExtD),
    .RdD(RdD),
    .Rd1D(Rd1D),
    .PcD_out(PcD_out),
    .BranchD(BranchD),
    .JumpD(JumpD),
    .Rd2D(Rd2D),
    .PcPlus4D_out(PcPlus4D_out),
    .eq_checkD(eq_checkD),
    .RegWriteE_in(RegWriteE_in),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),
    .MemwriteE_in(MemwriteE_in),
    .ResultSrcE_in(ResultSrcE_in),
    .ImmExtE_in(ImmExtE_in),
    .RdE_in(RdE_in),
    .Rd1E(Rd1E),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .Rs1E(Rs1E_in),
    .Rs2E(Rs2E_in),
    .PcE_in(PcE_in),
    .BranchE(BranchE),
    .JumpE(JumpE),
    .Rd2E(Rd2E),
    .PcPlus4E_in(PcPlus4E_in),
    .eq_checkE(eq_checkE)
);

execute_top execute_top(
    .RegWriteE_in(RegWriteE_in),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),
    .MemwriteE_in(MemwriteE_in),
    .ResultSrcE_in(ResultSrcE_in),
    .ImmExtE_in(ImmExtE_in),
    .RdE_in(RdE_in),
    .Rd1E(Rd1E),
    .PcE_in(PcE_in),
    .BranchE(BranchE),
    .JumpE(JumpE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .Rs1E_in(Rs1E_in),
    .Rs2E_in(Rs2E_in),
    .Rs1E_out(Rs1E_out),
    .Rs2E_out(Rs2E_out),
    .ResultW(ResultW),
    .ALUResultM_out(ALUResultM_out),
    .Rd2E(Rd2E),
    .PcPlus4E_in(PcPlus4E_in),
    .eq_checkE(eq_checkE),
    .RegWriteE_out(RegWriteE_out),
    .ResultSrcE_out(ResultSrcE_out),
    .MemwriteE_out(MemwriteE_out),
    .PcTargetE(PcTargetE),
    .ALUResultE(ALUResultE),
    .ImmExtE_out(ImmExtE_out),
    .WriteDataE(WriteDataE),
    .PcPlus4E_out(PcPlus4E_out),
    .RdE_out(RdE_out),
    .PcE_out(PcE_out),
    .PCSrcE(PcSrcE)
);

EX_MEM EX_MEM(
    .clk(clk),
    .RegWriteE_out(RegWriteE_out),
    .ResultSrcE_out(ResultSrcE_out),
    .MemwriteE_out(MemwriteE_out),
    .PcTargetE(PcTargetE),
    .ALUResultE(ALUResultE),
    .ImmExtE_out(ImmExtE_out),
    .WriteDataE(WriteDataE),
    .PcPlus4E_out(PcPlus4E_out),
    .RdE_out(RdE_out),
    .RegWriteM_in(RegWriteM_in),
    .ResultSrcM_in(ResultSrcM_in),
    .MemwriteM(MemwriteM),
    .ALUResultM_in(ALUResultM_in),
    .PcTargetM_in(PcTargetM_in),
    .ImmExtM_in(ImmExtM_in),
    .WriteDataM(WriteDataM),
    .RdM_in(RdM_in),
    .PcPlus4M_in(PcPlus4M_in)
);

mem_top mem_top(
    .clk(clk),
    .RegWriteM_in(RegWriteM_in),
    .ResultSrcM_in(ResultSrcM_in),
    .MemwriteM(MemwriteM),
    .ALUResultM_in(ALUResultM_in),
    .PcTargetM_in(PcTargetM_in),
    .ImmExtM_in(ImmExtM_in),
    .WriteDataM(WriteDataM),
    .RdM_in(RdM_in),
    .PcPlus4M_in(PcPlus4M_in),
    .PcPlus4M_out(PcPlus4M_out),
    .ALUResultM_out(ALUResultM_out),
    .ImmExtM_out(ImmExtM_out),
    .PcTargetM_out(PcTargetM_out),
    .RdM_out(RdM_out),
    .ResultSrcM_out(ResultSrcM_out),
    .RegWriteM_out(RegWriteM_out),
    .ReadDataM(ReadDataM)
);

MEM_WB MEM_WB(
    .clk(clk),
    .PcPlus4M_out(PcPlus4M_out),
    .ALUResultM_out(ALUResultM_out),
    .ImmExtM_out(ImmExtM_out),
    .PcTargetM_out(PcTargetM_out),
    .RdM_out(RdM_out),
    .ResultSrcM_out(ResultSrcM_out),
    .RegWriteM_out(RegWriteM_out),
    .ReadDataM(ReadDataM),
    .RegWriteW_in(RegWriteW_in),
    .ResultSrcW(ResultSrcW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PcPlus4W(PcPlus4W),
    .RdW_in(RdW_in),
    .PcTargetW(PcTargetW),
    .ImmExtW(ImmExtW)
);

wb_top wb_top (
    .RegWriteW_in(RegWriteW_in),
    .ResultSrcW(ResultSrcW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PcPlus4W(PcPlus4W),
    .RdW_in(RdW_in),
    .PcTargetW(PcTargetW),
    .ImmExtW(ImmExtW),
    .RdW_out(RdW_out),
    .RegWriteW_out(RegWriteW_out),
    .ResultW(ResultW)
);

hazard_unit hazard_unit (
   .Rs1E_out(Rs1E_out),
   .Rs2E_out(Rs2E_out),
   .RdM_out(RdM_out),
   .RdW_out(RdW_out),
   .RegWriteW_out(RegWriteW_out),
   .RegWriteM_out(RegWriteM_out),
   .ForwardAE(ForwardAE),
   .ForwardBE(ForwardBE)
);

endmodule
