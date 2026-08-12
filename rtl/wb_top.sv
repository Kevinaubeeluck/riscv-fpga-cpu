module wb_top(
    input logic         RegWriteW_in,
    input logic [2:0]   ResultSrcW,
    input logic [31:0]  ALUResultW,
    input logic [31:0]  ReadDataW,
    input logic [31:0]  PcPlus4W,
    input logic [31:0]  PcTargetW,
    input logic [31:0]  ImmExtW,
    output logic        RegWriteW_out,
    output logic [31:0] ResultW
);
    
always_comb begin
    RegWriteW_out = RegWriteW_in;
        case(ResultSrcW)
        3'b000:begin
            ResultW = ALUResultW;
        end
        3'b001:begin
            ResultW = ReadDataW;
        end
        3'b010:begin
            ResultW = ImmExtW;
        end
        3'b011:begin
            ResultW = PcPlus4W;
        end
        3'b100:begin
            ResultW = PcTargetW;
        end
        default: begin
            ResultW = PcPlus4W;
        end
    endcase
end

endmodule
