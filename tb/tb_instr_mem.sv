module tb;
    parameter       ADDRESS_WIDTH = 32;
    parameter       DATA_WIDTH = 32;

    logic [ADDRESS_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] dout;
    logic clk;


    instr_mem uut(.*);

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

        #20; addr = 0;
        #10; 
        check("Addr 0", dout, 32'h00500113);

        #20; addr = 4;
        #10; 
        check("Addr 0", dout, 32'h00C00193);

        #20; addr = 8;
        #10; 
        check("Addr 0", dout, 32'h003100B3);

        #20; addr = 12;
        #10; 
        check("Addr 0", dout, 32'h40310133);
        
        #20; addr = 16;
        #10; 
        check("Addr 0", dout, 32'h0021A233);
        
        #20; addr = 20;
        #10; 
        check("Addr 0", dout, 32'h0041A283);
        
        #20; addr = 24;
        #10; 
        check("Addr 0", dout, 32'h00510463);
        
        #20; addr = 28;
        #10; 
        check("Addr 0", dout, 32'h00000013);
        
        #20; addr = 32;
        #10; 
        check("Addr 0", dout, 32'h006281B3);
        
        
        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
