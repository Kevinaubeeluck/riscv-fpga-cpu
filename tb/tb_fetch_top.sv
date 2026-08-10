module tb;

    logic clk;
    logic rst;
    logic [31:0] PCTargetE;
    logic [31:0] ImmExtE;
    logic [31:0] ALUResultE;
    logic [1:0] PCSrcE;
    logic [31:0] InstrF;
    logic [31:0] PcFout;
        

    fetch_top uut(.*); //ADD MODULE UNDER TEST HERE, if (.*) doesn't work manually instantiate like in tb_regfile.sv

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
        clk = 0; rst = 1;  //ADD INITIALISATION HERE
        #12;
        check("rst check: PCF", uut.PCF, '0);
        rst = 0; PCTargetE = 32'h1234; ImmExtE = 32'h5678;
        ALUResultE = 32'h2468; 

        @(posedge clk);
        PCSrcE = 2'b00;
        #1;
        check("Mux test: PcPlus4F", uut.PCFPrime, 32'h4);

        @(posedge clk);
        PCSrcE = 2'b01; 
        #1;    
        check("Mux test: PcPlus4f propogation", uut.PCF, 32'h4);
        
        @(posedge clk);
        PCSrcE = 2'b01;
        #1;
        check("Mux test: PcTargetE", uut.PCFPrime, 32'h1234);

        @(posedge clk);
        PCSrcE = 2'b00;
        #1;    
        check("Mux test: PcTargetE propogation", uut.PCF, 32'h1234);

        @(posedge clk);
        PCSrcE = 2'b10;
        #1;
        check("Mux test: ImmExtE", uut.PCFPrime, 32'h5678);

        @(posedge clk);
        PCSrcE = 2'b00;
        #1;    
        check("Mux test: ImmExtE propogation", uut.PCF, 32'h5678);    
        
        @(posedge clk);
        PCSrcE = 2'b11;
        #1;
        check("Mux test: ALUResult", uut.PCFPrime, 32'h2468);

        @(posedge clk);
        PCSrcE = 2'b00;
        #1;    
        check("Mux test: ALUResult propogation", uut.PCF, 32'h2468);   

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        $finish;
    end
endmodule
