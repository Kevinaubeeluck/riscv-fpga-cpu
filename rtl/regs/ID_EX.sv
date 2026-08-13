module ID_EX(
    input logic            clk,
    input logic            RegWriteD,
    input logic            ALUSrcD,
    input logic [3:0]      ALUControlD,
    input logic            MemwriteD,
    input logic [2:0]      ResultSrcD,
    input logic [31:0]     ImmExtD,
    input logic [4:0]      RdD,
    input logic [31:0]     Rd1D,
    input logic [31:0]     PcD_out,
    input logic            BranchD,
    input logic            JumpD,
    input logic [31:0]     Rd2D,
    input logic [31:0]     PcPlus4D_out,
    input logic            eq_checkD,
    input logic [4:0]     Rs1D,
    input logic [4:0]     Rs2D,
    output logic [4:0]     Rs1E,
    output logic [4:0]     Rs2E,
    output logic            RegWriteE_in,
    output logic            ALUSrcE,
    output logic [3:0]      ALUControlE,
    output logic            MemwriteE_in,
    output logic [2:0]      ResultSrcE_in,
    output logic [31:0]     ImmExtE_in,
    output logic [4:0]      RdE_in,
    output logic [31:0]     Rd1E,
    output logic [31:0]     PcE_in,
    output logic            BranchE,
    output logic            JumpE,
    output logic [31:0]     Rd2E,
    output logic [31:0]     PcPlus4E_in,
    output logic            eq_checkE
);
    
always_ff @(posedge clk) begin
    RegWriteE_in <= RegWriteD;
    ALUSrcE <= ALUSrcD;
    ALUControlE <= ALUControlD;
    MemwriteE_in <= MemwriteD;
    ResultSrcE_in <= ResultSrcD;
    ImmExtE_in <= ImmExtD;
    RdE_in <= RdD;
    Rd1E <= Rd1D;
    PcE_in <= PcD_out;
    BranchE <= BranchD;
    JumpE <= JumpD;
    Rd2E <= Rd2D;
    PcPlus4E_in <= PcPlus4D_out;
    eq_checkE <= eq_checkD;   
    Rs1E <= Rs1D;
    Rs2E <= Rs2D;
end

endmodule
