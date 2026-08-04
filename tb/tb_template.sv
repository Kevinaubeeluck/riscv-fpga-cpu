module tb;
    parameter       ADDRESS_WIDTH = 32,
                    DATA_WIDTH = 32

    logic [ADDRESS_WIDTH-1:0] addr,
    logic [DATA_WIDTH-1:0] dout
    logic clk;


    decoder uut(.*);

    always #5 clk = ~clk;


    int pass_count = 0;
    int fail_count = 0;

    task check(string name, logic [31:0] actual, logic [31:0] expected);
    if (actual !== expected) begin
        $error("%s: expected %0h, got %0h", name, expected, actual);
        fail_count++;
    end else
        pass_count++;
    endtask


    initial begin 
        $dumpfile("waves.vcd");
        $dumpvars(0,tb);
       

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
