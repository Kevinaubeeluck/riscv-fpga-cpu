module tb;
    input reg [6:0] op;
    input reg [2:0] func3;
    input reg funct7;
    input reg zero; 
    input reg clk;
    output logic PCSrc;
    output logic ResultSrc;
    output logic Memwrite;
    output logic [2:0] ALUControl;
    output logic ALUSrc;
    output logic [2:0] ImmSrc;
    output logic regwrite;


    decoder uut(.*);

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("waves.vcd");
        $dumpvars(0,tb);
        op = '0; func3 = '0; funct7 = '0; zero = '0;  

        #20; op = 7'b0000011; func3 = '0; funct7 = '0; zero = '0;
        #10; 

        #20; $finish;
    end
endmodule
