module cpu_top(
    input clk,
    input rst
);
    


logic [31:0]    Pc;
logic [31:0]    PcNext;
logic [31:0]    Instr;
logic           RegWrite;
logic [2:0]     ImmSrc;
logic           ALUSrc;
logic [3:0]     ALUControl;
logic           Memwrite;
logic [1:0]     ResultSrc;
logic [1:0]     PCSrc;
logic [31:0]    PCPlus4;
logic [31:0]    SrcA;
logic [31:0]    SrcB;
logic [31:0]    ReadData;
logic [31:0]    WriteData;
logic [31:0]    ImmExt;
logic [31:0]    PCTarget;
logic [31:0]    Result;
logic           Zero;
logic [31:0]    ALUResult;
logic [1:0]     RegDataSrc;
logic [31:0]    RegDataWire;



always_ff @(posedge clk) begin
    if (rst) begin
        Pc <='0;
        PcNext <= '0;
    end
    else begin
        Pc <= PcNext;
    end
end


/*
Adding the muxes and adders
*/
always_comb begin

    /*
    MASSIVE note to self here, i forgot that always_comb is sequential and
    executes top to bottom leading to me assigning RegDataWire BEFORE i 
    assign my result and this caused my RegDataWirte to be XXX despite having
    a valid result. I need to ALWAYS keep in mind that always_comb is sequential
    and keep dependencies in mind
    */
    SrcB = ALUSrc ? (ImmExt):(WriteData);
    case(ResultSrc)
        2'b00:begin
            Result = ALUResult;
        end
        2'b01:begin
            Result = ReadData;
        end
        2'b10:begin
            Result = ImmExt;
        end
        2'b11:begin
            Result = PCPlus4;
        end
    endcase

    case(RegDataSrc) // change this
        2'b00:begin //AGAIN NEVER USE BARE LITERALS LIKE 00 ALWAYS USE 2'B00 OR SOMETHING
            RegDataWire = Result;
        end
        2'b01:begin
            RegDataWire = PCTarget;
        end
    endcase

    case(PCSrc)
        2'b00:begin //AGAIN NEVER USE BARE LITERALS LIKE 00 ALWAYS USE 2'B00 OR SOMETHING
            PcNext = PCPlus4;
        end
        2'b01:begin
            PcNext = PCTarget;
        end
        2'b10:begin
            PcNext = ImmExt;
        end
        2'b11:begin
            PcNext = ALUResult & ~1;
        end
    endcase
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
    .wd(RegDataWire),       
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
    .regwrite(RegWrite),
    .RegDataSrc(RegDataSrc)
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