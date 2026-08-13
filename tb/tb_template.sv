module tb;
//  Paste parameters 
    parameter   ADDRESS_WIDTH =32;
    parameter   DATA_WIDTH = 32;

    logic clk;
//  Paste ports list from module under test here removing input/output
    logic [ADDRESS_WIDTH-1:0] addr; 
    logic [DATA_WIDTH-1:0] wd;
    logic clk;
    logic we;
    logic [DATA_WIDTH-1:0] rd;


    d_mem uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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

        
      //  #20; addr = 32'd30; wd = 32'h112344; we = 1'b1;
      //  #20;
      //  check("Write test",   rd,   32'h112344);
        
        // if you want to test internal logic do uut.logic
      //  check("Reg test", uut.registers[30], 32'h112344);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
