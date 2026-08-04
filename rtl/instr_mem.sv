module instr_mem #(
    parameter       ADDRESS_WIDTH = 32,
                    DATA_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout
);

logic [DATA_WIDTH-1:0] instr_array [10*ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading instr...");
    $readmemh("rtl/riscv.mem", instr_array);
end

always_comb begin
    dout = instr_array[addr>>2];
end


endmodule
