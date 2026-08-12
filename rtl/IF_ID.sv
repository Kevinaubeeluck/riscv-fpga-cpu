module IF_ID(
    input clk,
    input logic [31:0] InstrF,
    input logic [31:0] PCF,
    input logic [31:0] PCPlus4F,
    output logic [31:0] InstrD,
    output logic [31:0] PcD,
    output logic [31:0] PCPlus4D
);

always_ff @(posedge clk) begin
    PcD <= PCF;
    InstrD <= InstrF;
    PCPlus4D <= PCPlus4F;
end

endmodule
