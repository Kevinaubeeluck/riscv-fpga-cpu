module decode_top(
    input logic clk,
    input logic [31:0]      InstrD,
    input logic [31:0]      PcD_in,
    input logic [31:0]      PcPlus4D_in,
    input logic             RegWriteW,
    input logic [4:0]       RdW,
    input logic [31:0]      ResultW,
    output logic            RegWriteD,
    output logic            ALUSrcD,
    output logic [3:0]      ALUControlD,
    output logic            MemwriteD,
    output logic [2:0]      ResultSrcD,
    output logic [31:0]     ImmExtD,
    output logic [4:0]      RdD,
    output logic [31:0]     Rd1D,
    output logic [31:0]     PcD_out,
    output logic            BranchD,
    output logic            JumpD,
    output logic [31:0]     Rd2D,
    output logic [31:0]     PcPlus4D_out,
    output logic            eq_checkD
);  

logic [2:0]     ImmSrcD;

always_comb begin
    RdD = InstrD[11:7];
    PcD_out = PcD_in;
    PcPlus4D_out = PcPlus4D_in;
end

decoder decoder (
    .op(InstrD[6:0]),
    .func3(InstrD[14:12]),
    .funct7(InstrD[30]),
    .ResultSrc(ResultSrcD),
    .Memwrite(MemwriteD),
    .ALUControl(ALUControlD),
    .ALUSrc(ALUSrcD),
    .Jump(JumpD),
    .Branch(BranchD),
    .eq_check(eq_checkD),
    .ImmSrc(ImmSrcD),
    .regwrite(RegWriteD)
);

regfile regfile(
    .clk(clk),
    .we(RegWriteW),         
    .ra1(InstrD[19:15]),
    .ra2(InstrD[24:20]),  
    .wa(RdW),        
    .wd(ResultW),       
    .rd1(Rd1D),
    .rd2(Rd2D)   
);

extend extend (
    .imm(InstrD[31:7]),
    .immsrc(ImmSrcD),
    .immext(ImmExtD)
);


endmodule
