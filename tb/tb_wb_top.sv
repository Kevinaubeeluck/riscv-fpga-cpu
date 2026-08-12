module tb;
//  Paste ports list from module under test here removing input/output
    logic clk;
    logic         RegWriteW_in;
    logic [2:0]   ResultSrcW;
    logic [31:0]  ALUResultW;
    logic [31:0]  ReadDataW;
    logic [31:0]  PcTargetW;
    logic [31:0]  ImmExtW;
    logic [31:0]  PcPlus4W;
    logic        RegWriteW_out;
    logic [31:0] ResultW;


    wb_top uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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

        
        #20; ALUResultW = 32'd30; ReadDataW = 32'd29; ImmExtW = 32'd28;
        PcPlus4W = 32'd27; PcTargetW = 32'd26; ResultSrcW = 3'b000;
        #20;
        check("Alu result test",   ResultW,   32'd30);

        #20; ALUResultW = 32'd30; ReadDataW = 32'd29; ImmExtW = 32'd28;
        PcPlus4W = 32'd27; PcTargetW = 32'd26; ResultSrcW = 3'b001;
        #20;
        check("Read data test",   ResultW,   32'd29);

        #20; ALUResultW = 32'd30; ReadDataW = 32'd29; ImmExtW = 32'd28;
        PcPlus4W = 32'd27; PcTargetW = 32'd26; ResultSrcW = 3'b010;
        #20;
        check("Immext test",   ResultW,   32'd28);

        #20; ALUResultW = 32'd30; ReadDataW = 32'd29; ImmExtW = 32'd28;
        PcPlus4W = 32'd27; PcTargetW = 32'd26; ResultSrcW = 3'b011;
        #20;
        check("PCPlus4W test",   ResultW,   32'd27);

        #20; ALUResultW = 32'd30; ReadDataW = 32'd29; ImmExtW = 32'd28;
        PcPlus4W = 32'd27; PcTargetW = 32'd26; ResultSrcW = 3'b100;
        #20;
        check("Pc target test",   ResultW,   32'd26);

 
        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
