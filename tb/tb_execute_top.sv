module tb;
//  Paste ports list from module under test here removing input/output
    logic            RegWriteE;
    logic            ALUSrcE;
    logic [3:0]      ALUControlE;
    logic            MemwriteE;
    logic [2:0]      ResultSrcE;
    logic [31:0]     ImmExtE;
    logic [4:0]      RdE_in;
    logic [31:0]     Rd1E;
    logic [31:0]     PcE;
    logic            BranchE;
    logic            JumpE;
    logic [31:0]     Rd2E;
    logic [31:0]     PcPlus4E_in;
    logic            eq_checkE;
    logic [31:0]    PcTargetE;
    logic [31:0]    ALUResultE;
    logic [31:0]    WriteDataE;
    logic [31:0]    PcPlus4E_out;
    logic [4:0]     RdE_out;
    logic [1:0]    PCSrcE;
    logic clk;


    execute_top uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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

        /*
        We test the PCSrcE logic first, 
        We try the branches where eq check is 1
        This branches when zero is 1 meaning our branch bit 
        should be 1. Our jump bit is 1 unconditinally so our 
        output should be 2'b11;
        */
        #20; eq_checkE = 1; BranchE = 1; JumpE = 1;
        ALUSrcE = 0; Rd1E = 5; Rd2E = 5; ALUControlE =1; 
        #20;
        check("PcSrc test",   PCSrcE,   2'b11);

        /*
        We test the false logic now, 
        We try the branches where eq check is 1
        This branches when zero is 1 meaning our branch bit 
        should be 0. Our jump bit is 1 unconditinally so our 
        output should be 2'b10;
        */
        #20; eq_checkE = 1; BranchE = 0; JumpE = 1;
        ALUSrcE = 0; Rd1E = 5; Rd2E = 5; ALUControlE =1; 
        #20;
        check("PcSrc test",   PCSrcE,   2'b10);


        /*
        We just test our PcTargetE now (basic add)
        */
        #20; PcE = 1; ImmExtE = 1;
        check("PcSrc test",   PCSrcE,   2);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
