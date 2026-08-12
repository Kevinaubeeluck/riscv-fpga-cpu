module tb;
//  Paste parameters 
    parameter   ADDRESS_WIDTH =32;
    parameter   DATA_WIDTH = 32;

//  Paste ports list from module under test here removing input/output
    logic clk;
    logic [31:0]      InstrD;
    logic [31:0]      PcD_in;
    logic [31:0]      PcPlus4D_in;
    logic             RegWriteW;
    logic [4:0]       RdW;
    logic [31:0]      ResultW;
    logic            RegWriteD;
    logic            ALUSrcD;
    logic [3:0]      ALUControlD;
    logic            MemwriteD;
    logic [2:0]      ResultSrcD;
    logic [31:0]     ImmExtD;
    logic [4:0]      RdD;
    logic [31:0]     Rd1D;
    logic [31:0]     PcD_out;
    logic            BranchD;
    logic            JumpD;
    logic [31:0]     Rd2D;
    logic [31:0]     PcPlus4D_out;
    logic            eq_checkD;


    decode_top uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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
        We just need to test the outputs of the extend and deocde plumbing 
        So we use only one test with an I-type as this uses every part of the 
        decode top. Testing is less intense here because we already verified functionality.
        */

        #20;
        InstrD = 32'h02000093; 
        #20;
        check("I-type add RegWrite",   uut.RegWriteD,   1);
        check("I-type add ImmSrc",     uut.ImmSrcD,     1);
        check("I-type add ImmExtd",     uut.ImmSrcD,    1);
        check("I-type add ALUSrc",     uut.ALUSrcD,     1);
        check("I-type add MemWrite",   uut.MemwriteD,   0);
        check("I-type add ResultSrc",  uut.ResultSrcD,  0);
        check("I-type add ALUControl", uut.ALUControlD, 0);
        check("I-type add ImmExtD",   uut.ImmExtD, 20'h20);
        check("I-type add RD1D",          uut.Rd1D, '0);
        check("I-type add Branchd",        uut.BranchD, 0);
        check("I-type add Jumpd",          uut.JumpD, 0);
        #20;
        /*
        
        */
        #20;

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
