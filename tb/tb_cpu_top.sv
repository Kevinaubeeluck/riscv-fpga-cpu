module tb;
    logic clk;

    cpu_top uut(.*); //ADD MODULE UNDER TEST HERE 

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
        clk = 0; //ADD INITIALISATION HERE

        #20;#20;
        
        $display("\n===== Resu  lts: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
