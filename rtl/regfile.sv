module regfile (
    input  logic        clk,
    input  logic        we,         // write enable
    input  logic [4:0]  ra1, ra2,   // read addresses (2 ports)
    input  logic [4:0]  wa,         // write address
    input  logic [31:0] wd,         // write data
    output logic [31:0] rd1, rd2    // read data (2 ports)
);
    logic [31:0] registers [0:31];

    always_comb begin
        /*
        Keeping this logic here as good learning moment, this is bad because
        in the if and else if case we assign only ONE of the two outputs meaning
        the other one is inferred and latches at 0

        REMEMBER, EVERY signal must be assigned in EVERY branch of an always_comb block
        IF signals are independent, don't couple in the same if/else chain 
        */

        // if(ra1 =='0) begin
        //     rd1 = '0;
        // end
        // else if(ra2 == '0) begin
        //     rd2 = '0;
        // end
        // else begin
        //     rd1 = registers[ra1];
        //     rd2 = registers[ra2];
        // end
        rd1 = (ra1 == '0) ? ('0):(registers[ra1]);
        rd2 = (ra2 == '0) ? ('0):(registers[ra2]);
    end

    always_ff@(posedge clk)begin
        if(we)begin
            if(wa != '0)begin
                registers[wa] <= wd;
            end
        end
    end

endmodule
