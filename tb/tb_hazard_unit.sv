module tb;
//  Paste parameters 
    parameter   ADDRESS_WIDTH =32;
    parameter   DATA_WIDTH = 32;

    logic clk;
//  Paste ports list from module under test here removing input/output
    logic [4:0]           Rs1E_out;
    logic [4:0]           Rs2E_out;
    logic [4:0]           Rs1D;
    logic [4:0]           Rs2D;
    logic [2:0]           ResultSrcE_out;
    logic [4:0]           RdM_out;
    logic [4:0]           RdW_out;
    logic [4:0]           RdE_out;
    logic [1:0]           PcSrcE;
    logic                 RegWriteW_out;
    logic                 RegWriteM_out;
    logic [1:0]          ForwardAE;
    logic [1:0]          ForwardBE;
    logic                StallD;
    logic                StallF;
    logic                FlushE;
    logic                FlushD;


    hazard_unit uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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
        We test Forward AE for routing from memory stage
        We're testing with rdm out and rdw out being different
        to start with to isolate that the forwarding logic works
        */


        #20; 
        Rs1E_out = 5; 
        RdM_out = 5;
        RdW_out = 10;
        RegWriteW_out = 1;
        RegWriteM_out = 1;
        #20;
        check("Forward AE memory test",   ForwardAE,   2'b10);
        
        /*
        We now check the priority of the ForwardAE, it should prioritise
        the memory stage over the writebackstage
        */

        #20; 
        Rs1E_out = 5; 
        RdM_out = 5;
        RdW_out = 5;
        RegWriteW_out = 1;
        RegWriteM_out = 1;
        #20;
        check("Forward AE priority test",   ForwardAE,   2'b10);
        /*
        We now check the logic of the RegWriteM_out, this ensures we 
        only forward if we're writing to that register
        */

        #20; 
        Rs1E_out = 5; 
        RdM_out = 5;
        RdW_out = 5;
        RegWriteM_out = 0;
        RegWriteW_out = 0;
        #20;
        check("Forward AE RegWriteM_out test",   ForwardAE,   2'b00);
        /*
        We now check the logic of the RegWriteW_out, this ensures we 
        only forward if we're writing to that register
        */

        #20; 
        Rs1E_out = 5; 
        RdM_out = 5;
        RdW_out = 5;
        RegWriteM_out = 0;
        RegWriteW_out = 1;
        #20;
        check("Forward AE RegWriteW_out test",   ForwardAE,   2'b01);
        /*
        We now check that we can achieve forwarding from writeback
        */

        #20; 
        Rs1E_out = 5; 
        RdM_out = 6;
        RdW_out = 5;
        RegWriteM_out = 1;
        RegWriteW_out = 1;
        #20;
        check("Forward AE writeback test",   ForwardAE,   2'b01);
        /*
        We now check that we can exeucte both writebacks simultanously
        */

        #20; 
        Rs1E_out = 5; 
        Rs2E_out = 6;
        RdM_out = 6;
        RdW_out = 5;
        RegWriteM_out = 1;
        RegWriteW_out = 1;
        #20;
        check("Forward AE writeback test",   ForwardAE,   2'b01);
        check("Forward BE writeback test",   ForwardBE,   2'b10);
        /*
        Let's check our StallF logic
        */

        #20; 
        ResultSrcE_out = 3'b001;
        RdE_out = 1;
        Rs1D = 1;
        Rs2D = 1;
        #20;
        check("StallF both matching check",   StallF,   1'b0);
        check("StallD both matching check",   StallD,   1'b0);
        check("FlushE both matching check",   FlushE,   1'b1);

        
        #20; 
        ResultSrcE_out = 3'b001;
        RdE_out = 1;
        Rs1D = 0;
        Rs2D = 1;
        #20;
        check("StallF 1 matching check",   StallF,   1'b0);
        check("StallD 1 matching check",   StallD,   1'b0);
        check("FlushE 1 matching check",   FlushE,   1'b1);

        #20; 
        ResultSrcE_out = 3'b001;
        PcSrcE = 0;
        RdE_out = 1;
        Rs1D = 0;
        Rs2D = 0;
        #20;
        check("StallF None matching check",   StallF,   1'b1);
        check("StallD None matching check",   StallD,   1'b1);
        check("FlushE None matching check",   FlushE,   1'b0);

        #20; 
        ResultSrcE_out = 3'b010;
        RdE_out = 1;
        Rs1D = 1;
        Rs2D = 1;
        #20;
        check("StallF Wrong ResultSrcE_out check",   StallF,   1'b1);
        check("StallD Wrong ResultSrcE_out check",   StallD,   1'b1);
        check("FlushE Wrong ResultSrcE_out check",   FlushE,   1'b0);

        /*
        Let's check our FlushD logic, we drive our inputs
        such that stallf is high so !stallf is low and 
        flushD is high to test the 'or' logic and flushD
        */

        #20; 
        ResultSrcE_out = 3'b010;
        RdE_out = 1;
        Rs1D = 1;
        Rs2D = 1;
        PcSrcE = 2'b01;
        #20;
        check("StallF check",   StallF,   1'b1);
        check("StallD check",   StallD,   1'b1);
        check("FlushE check",   FlushE,   1'b1);
        check("FlushD check",   FlushD,   1'b1);

        

        // if you want to test internal logic do uut.logic
       // check("Reg test", uut.registers[30], 32'h112344);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
