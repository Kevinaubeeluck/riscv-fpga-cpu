module cpu_top(
    input clk
);
    


logic [31:0] Pc;
logic [31:0] PcNext;
logic [31:0] Instr;
logic        RegWrite;
logic [1:0]  Immsrc;
logic        ALUSrc;
logic [2:0]  ALUControl;
logic        Memwrite;
logic        ResultSrc;
logic        PCSrc;
logic [31:0] PCPlus4;
logic [31:0] SrcA;
logic [31:0] SrcB;
logic [31:0] ReadData;
logic [31:0] WriteData;
logic [31:0] ImmExt;
logic [31:0] PCTarget;
logic [31:0] Result;
logic  Zero;
logic [31:0] ALUResult;


always_ff @(posedge clk) begin
    Pc <= PcNext;
end


/*
Adding the muxes and adders
*/
always_comb begin
    SrcB = ALUSrc ? (ImmExt):(WriteData);
    Result = ResultSrc ? (ReadData):(ALUResult);
    PcNext = PCSrc ? (PCTarget):(PCPlus4);
    PCTarget = Pc + ImmExt;
    PCPlus4 = Pc + 4;
end

instr_mem instr_mem(
    .addr(Pc),
    .dout(Instr)
);

regfile regfile(
    .clk(clk),
    .we(RegWrite),         
    .ra1(Instr[19:15]),
    .ra2(Instr[24:20]),  
    .wa(Instr[11:7]),        
    .wd(Result),       
    .rd1(SrcA),
    .rd2(WriteData)   
);

alu alu(
    .a(SrcA),
    .b(SrcB),
    .alu_op(ALUControl),
    .result(ALUResult),
    .zero(Zero)      // result == 0 flag
);

decoder decoder (
    .op(Instr[6:0]),
    .func3(Instr[14:12]),
    .funct7(Instr[30]),
    .zero(Zero), 
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .Memwrite(Memwrite),
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .regwrite(RegWrite)
);

extend extend (
    .imm(Instr[31:7]),
    .immsrc(ImmSrc),
    .immext(ImmExt)
);

d_mem d_mem (
    .addr(ALUResult),
    .wd(WriteData),
    .clk(clk),
    .we(Memwrite),
    .rd(ReadData)
);


endmodule