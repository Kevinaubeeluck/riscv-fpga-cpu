module IF_ID(
    input clk,
    input logic [31:0]  InstrF,
    input logic [31:0]  PCF,
    input logic         en,
    input logic [31:0]  PCPlus4F,
    output logic [31:0] InstrD,
    output logic [31:0] PcD,
    output logic [31:0] PCPlus4D
);

always_ff @(posedge clk) begin
    if(en)begin
        PcD <= PCF;
        InstrD <= InstrF;
        PCPlus4D <= PCPlus4F;
    end
    else begin
        PcD <= PcD;
        InstrD <= InstrD;
        PCPlus4D <= PCPlus4F;        
    end

end

endmodule
