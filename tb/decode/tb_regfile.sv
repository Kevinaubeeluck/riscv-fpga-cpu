module tb;
    logic        clk,we;         
    logic [4:0]  ra1,ra2,wa;
    logic [31:0] wd;
    wire [31:0] rd1,rd2 ;   

    regfile uut(
    .clk(clk),
    .we(we),         // write enable
    .ra1(ra1), 
    .ra2(ra2),   // read addresses (2 ports)
    .wa(wa),         // write address
    .wd(wd),         // write data
    .rd1(rd1), 
    .rd2(rd2)   // read data (2 ports)
);

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
        clk = 0; we = 0; ra1 = 0; ra2 = 0; wa = 0; wd = 0; 

        #20; wa = 5; wd = 32'hDEADBEEF;we = 1;
        #10; we = 0;

        #10; ra1 = 5; #20;
        check("RD1 read", rd1, 32'hDEADBEEF);
        #20; wa = 0; wd = 32'hDEADBEEF;we = 1;
        #10; we = 0;

        #10; ra2 = 0;#20;
        check("X0 hardwired read", rd2, '0);

        
        #20; wa = 3; wd = 32'h01234567;we = 1;
        #10; we = 0;
    
        #10; ra2 = 3; #20;
        check("Dual read", rd1, 32'hDEADBEEF);
        check("Dual read", rd2, 32'h01234567);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");

        #20; $finish;
    end
endmodule
