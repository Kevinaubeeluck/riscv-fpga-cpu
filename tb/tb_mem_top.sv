module tb;
//  Paste ports list from module under test here removing input/output
    logic         clk;
    logic         RegWriteM_in;
    logic [1:0]   ResultSrcM_in;
    logic         MemwriteM;
    logic [31:0]  ALUResultM;
    logic [31:0]  WriteDataM;
    logic [31:0]  RdM_in;
    logic [31:0]  PcPlus4M_in;
    logic [31:0] PcPlus4M_out;
    logic [31:0] RdM_out;
    logic [1:0]  ResultSrcM_out;
    logic        RegWriteM_out;
    logic [31:0] ReadDataM;


    mem_top uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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

        
        #20; ALUResultM = 32'd30; WriteDataM = 32'h112344; MemwriteM = 1'b1;
        #20;
        check("Write test",   ReadDataM,   32'h112344);
        
        #20; ALUResultM = 32'd30; WriteDataM = 32'h555555; MemwriteM = 1'b0;
        #20;
        check("Read test",   ReadDataM,   32'h112344);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
