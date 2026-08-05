module tb;
    logic [6:0] op;
    logic [2:0] func3;
    logic funct7;
    logic zero; 
    logic clk;
    logic PCSrc;
    logic [1:0] ResultSrc;
    logic Memwrite;
    logic [3:0] ALUControl;
    logic ALUSrc;
    logic [2:0] ImmSrc;
    logic regwrite;


    decoder uut(.*);

    always #5 clk = ~clk;

    localparam lw = 7'b0000011;
    localparam sw = 7'b0100011;
    localparam Rtype = 7'b0110011;
    localparam tree = 7'b1100011; //again calling tree instead of branch for consistency with decoder
    localparam Utype = 7'b0110111;

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
        op = '0; func3 = '0; funct7 = '0; zero = 1;  

        /*
        LW test:
        Regwrite : 1 - We want to load word into register
        ImmSrc: 0 - lw is I type 
        ALUSrc: 1 - We want the immediate hence our MUX takes the extended imm
        Memwrite: 0 - we want to load not store to mem
        ResultSrc: 1 - We're reading from memory hence we take the memory output
        ALUControl : 0 - lw is a positive offset hence the ALU does an add operation
        PCSrc : 0 - we're not branching hence PCSrc is 0
        */

        #20; op = lw; func3 = '0; funct7 = '0; zero = '0;
        #20;
        check("LW RegWrite",   regwrite,   1);
        check("LW ImmSrc",     ImmSrc,     1);
        check("LW ALUSrc",     ALUSrc,     1);
        check("LW MemWrite",   Memwrite,   0);
        check("LW ResultSrc",  ResultSrc,  1);
        check("LW ALUControl", ALUControl, 0);
        check("LW PCSrc",      PCSrc,      0);

        /*
        sw test:
        Regwrite : 0 - Not Writing to a register
        ImmSrc: 1 - sw is S-type 
        ALUSrc: 1 - We're calcuating integer offset from an addresshence we want the immediate
        Memwrite: 1 - We store the word in memory hence memwrite high
        ResultSrc: X - ResultSrc is fed into a mux to decide the output of result but 
        since we do a store, we don't care if the output is stored in the regfile
        ALUControl : 0 - offset hence we add 
        PCSrc : 0 - we're not branching hence PCSrc is 0
        */
        #20; op = sw; func3 = '0; funct7 = '0; zero = '0;
        #20;

        check("SW RegWrite",   regwrite,   0);
        check("SW ImmSrc",     ImmSrc,     2);
        check("SW ALUSrc",     ALUSrc,     1);
        check("SW MemWrite",   Memwrite,   1);
      //  check("SW ResultSrc",  ResultSrc,  'x);
        check("SW ALUControl", ALUControl, 0);
        check("SW PCSrc",      PCSrc,      0);

        /*
        Rtype add test:
        Regwrite : 1 - We want to write to a register
        ImmSrc: X - we're not using it's output so it can be whatever
        ALUSrc: 0 - Our ALU input is from the regfile not the imm
        Memwrite: 0 - We're storing values into regs not mem
        ResultSrc: 0 -we're reading from ALU output
        ALUControl : 0 - func3 is 0, op[5] and func7 is 0
        PCSrc : 0 - we're not branching hence PCSrc is 0
        */
        #20; op = Rtype; func3 = '0; funct7 = '0; zero = '0;
        #20;

        check("R-type add RegWrite",   regwrite,   1);
       // check("R-type add ImmSrc",     ImmSrc,     'x);
        check("R-type add ALUSrc",     ALUSrc,     0);
        check("R-type add MemWrite",   Memwrite,   0);
        check("R-type add ResultSrc",  ResultSrc,  0);
        check("R-type add ALUControl", ALUControl, 0);
        check("R-type add PCSrc",      PCSrc,      0);

        /*
        Rtype sub test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = '0; funct7 = '1; zero = '0;
        #20;

        check("R-type sub ALUControl", ALUControl, 1);

        /*
        Rtype sll test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b001; funct7 = '0; zero = '0;
        #20;

        check("R-type SLL ALUControl", ALUControl, 4'b0010);

        /*
        Rtype slt test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b010; funct7 = '0; zero = '0;
        #20;

        check("R-type SLT ALUControl", ALUControl, 4'b0011);

        /*
        Rtype sltu test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b011; funct7 = '0; zero = '0;
        #20;

        check("R-type SLTU ALUControl", ALUControl, 4'b0100);

        /*
        Rtype xor test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b100; funct7 = '0; zero = '0;
        #20;

        check("R-type XOR ALUControl", ALUControl, 4'b0101);

        /*
        Rtype sra test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b101; funct7 = '0; zero = '0;
        #20;

        check("R-type SRA ALUControl", ALUControl, 4'b0111);

        /*
        Rtype srl test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b101; funct7 = 1'b1; zero = '0;
        #20;

        check("R-type SLTU ALUControl", ALUControl, 4'b0110);


        /*
        Rtype OR test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b110; funct7 = '0; zero = '0;
        #20;

        check("R-type AND ALUControl", ALUControl, 4'b1000);

        /*
        Rtype AND test:
        Same outputs except ALUControl
        */
        #20; op = Rtype; func3 = 3'b111; funct7 = '0; zero = '0;
        #20;
        check("R-type OR ALUControl", ALUControl, 4'b1001);

        /*
        UTYPE test:
        Regwrite : 1 because we write to registers
        ImmSrc: 4 - U type
        ALUSrc: 0 - Our ALU input is from an immediate
        Memwrite: 0 - We don't write any output to memory
        ResultSrc: 2 - Selects our immediate
        ALUControl : 'x we bypass the ALU hence we dont care
        PCSrc : 0 - we're not branching
        */

        #20; op = Utype; func3 = 3'b000; funct7 = '0; zero = 1'b1;
        #20;

        check("Utype RegWrite",   regwrite,   1);
        check("Utype ImmSrc",     ImmSrc,     4);
        check("Utype ALUSrc",     ALUSrc,     1);
        check("Utype MemWrite",   Memwrite,   0);
        check("Utype ResultSrc",  ResultSrc,  2);
    //    check("Utype ALUControl", ALUControl, 1);
        check("Utype PCSrc",      PCSrc,      0);
        /*
        Branch BEQ test:
        Regwrite : 0 - There is no destination register
        ImmSrc: 2 - BEQ is B type
        ALUSrc: 0 - Our ALU input is from the regfile not the imm
        Memwrite: 0 - Due to being a branch, we don't write any output to memory
        ResultSrc: 0 - We don't want to accidentally write garbage
        ALUControl : 5 - we check for equality through an AND condition
        PCSrc : 1 - we're branching hence PCSrc is 1
        */
        #20; op = tree; func3 = 3'b000; funct7 = '0; zero = 1'b1;
        #20;

        check("BEQ TRUE RegWrite",   regwrite,   0);
        check("BEQ TRUE ImmSrc",     ImmSrc,     3);
        check("BEQ TRUE ALUSrc",     ALUSrc,     0);
        check("BEQ TRUE MemWrite",   Memwrite,   0);
     // check("BEQ TRUE ResultSrc",  ResultSrc,  'x);
        check("BEQ TRUE ALUControl", ALUControl, 1);
        check("BEQ TRUE PCSrc",      PCSrc,      1);

        /*
        Branch BEQ false test:
        Same outputs except PcSrc
        */        
        #20; op = tree; func3 = 3'b000; funct7 = '0; zero = 0;
        #20;

        check("BEQ FALSE PCSrc",      PCSrc,      0);

        /*
        Branch BNE true test:
        */
        #20; op = tree; func3 = 3'b001; funct7 = '0; zero = '0;
        #20;
        check("BNE true PCSrc", PCSrc, 1);

        /*
        Branch BNE false test:
        */
        #20; op = tree; func3 = 3'b001; funct7 = '0; zero = 1'b1;
        #20;
        check("BNE false PCSrc", PCSrc, 0);

        /*
        Branch blt true test:
        */
        #20; op = tree; func3 = 3'b010; funct7 = '0; zero = 1'b0;
        #20;
        check("BLT true PCSrc", PCSrc, 1);

        /*
        Branch blt false test:
        */
        #20; op = tree; func3 = 3'b010; funct7 = '0; zero = 1'b1;
        #20;
        check("BLT false PCSrc", PCSrc, 0);

        /*
        Branch bge true test:
        */
        #20; op = tree; func3 = 3'b101; funct7 = '0; zero = 1'b1;
        #20;
        check("BG3 true PCSrc", PCSrc, 1);

        /*
        Branch bge false test:
        */
        #20; op = tree; func3 = 3'b101; funct7 = '0; zero = 1'b0;
        #20;
        check("BGE false PCSrc", PCSrc, 0);


        /*
        Branch bltu true test:
        */
        #20; op = tree; func3 = 3'b110; funct7 = '0; zero = 1'b0;
        #20;
        check("BLTu true PCSrc", PCSrc, 1);

        /*
        Branch bltu false test:
        */
        #20; op = tree; func3 = 3'b110; funct7 = '0; zero = 1'b1;
        #20;
        check("BLTu false PCSrc", PCSrc, 0);

        /*
        Branch bgeu true test:
        */
        #20; op = tree; func3 = 3'b111; funct7 = '0; zero = 1'b1;
        #20;
        check("BGEU true PCSrc", PCSrc, 1);

        /*
        Branch bge false test:
        */
        #20; op = tree; func3 = 3'b111; funct7 = '0; zero = 1'b0;
        #20;
        check("BGEU false PCSrc", PCSrc, 0);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
