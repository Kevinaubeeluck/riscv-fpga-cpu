module d_mem #(
    parameter   ADDRESS_WIDTH =32,
                DATA_WIDTH = 32
) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    input logic [DATA_WIDTH-1:0] wd,
    input logic clk,
    input logic we,
    output logic [DATA_WIDTH-1:0] rd
);

logic [DATA_WIDTH-1:0] mem_array [10*ADDRESS_WIDTH-1:0];

always_ff @(posedge clk) begin
    if (we == 1'b1) begin
        mem_array[addr] <= wd;
    end
end

always_comb begin
    rd = mem_array[addr];
end
    
endmodule
