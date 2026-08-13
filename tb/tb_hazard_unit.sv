module tb;
//  Paste parameters 
    parameter   ADDRESS_WIDTH =32;
    parameter   DATA_WIDTH = 32;

    logic clk;
//  Paste ports list from module under test here removing input/output
    logic [4:0]         Rs1E_out;
    logic [4:0]         Rs2E_out;
    logic [31:0]        ALUResultM_out;
    logic [4:0]         RdM_out;
    logic [4:0]         RdW_out;
    logic               RegWriteW_out;
    logic               RegWriteM_out;
    logic [1:0]         ForwardAE;
    logic [1:0]         ForwardBE;


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

        
        

        // if you want to test internal logic do uut.logic
       // check("Reg test", uut.registers[30], 32'h112344);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
