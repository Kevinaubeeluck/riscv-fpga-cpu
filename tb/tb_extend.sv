module tb;
    logic [31:7] imm;
    logic [2:0] immsrc;
    logic [31:0] immext;
    logic clk;

    extend uut(.*);

    always #5 clk = ~clk;

    typedef enum logic[2:0] {  
        TYPE_R = 3'b000,
        TYPE_I = 3'b001,
        TYPE_S = 3'b010,
        TYPE_B = 3'b011,
        TYPE_U = 3'b100,
        TYPE_J = 3'b101
    } imm_src_sel;


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

        /*I-type test 
        We use 25'h1555555 which is 1010101010101010101010101
        We use 25 bits as that is the size of the instruction after it's Opcode has been stripped 
        The top 12 bits of 101010101010 are extracted 
        It is then signextended to 11111111111111111111101010101010 or 32'hFFFFFAAA
        */
        #20;imm =  25'h1555555; immsrc = TYPE_I; 
        #20;
        check("I(sign extended) test",   immext,   32'hFFFFFAAA);
        /*
        Let's do an I-type test without sign extension 
        We use 25'AAAAAA which is 0101010101010101010101010
        The top 12 bits are extracted: 010101010101
        It's sign extneded to 00000000000000000000010101010101 or 32'h555
        */
        #20;imm =  25'hAAAAAA; immsrc = TYPE_I; 
        #20;
        check("I(no extension) test",   immext,   32'h555);

        /*
        S-type test
        Let's use a memorable 12bit hex like 12'h123 or 12'b0001_0010_0011
        imm[11:5] is 0001001 and imm[4:0] is 00011
        We fill the rest of the fields up with 1s
        Our 25 bit input is 25'b0001001111111111111100011 or 25'h27FFE3
        Our immediate should extend to just 32'h123
        */
        #20; imm = 25'h4344; immsrc = TYPE_S;
        #20;
        check("S(no extension) test", immext, 32'h123);
        /*
        Lets use 12'b1001_0010_0011 or 12'h923
        imm[11:5] is 1001001 and imm[4:0] is 00011
        Lets fill up the rest of the fields with 0s just to ensure theres no dependencies(not needed but no harm)
        Our 25 bit input is 25'b1001001000000000000000011 or 25'h1240003
        When sign extended our output is 32'b11111111111111111111100100100011 or 32'hFFFFF923
        */
        #20; imm = 25'h1240003; immsrc = TYPE_S;
        #20;
        check("S(extension) test", immext, 32'hFFFFF923);

        /*
        B-type test
        Let's use a memorable 13 bit hex like 13'h922 or 13'b0_1001_0010_0010(remember we end in a 0)
        imm[12] is 0, imm[10:5] is 001001, imm[4:1] is 0001, imm[11] is 1 and imm[0] is implicitly 0 as the branch targets are aligned to 2-byte boundaries
        We fill the rest of the fields up with 0s
        Our 25 bit input is 25'b0001001000000000000000011 or 25'h240003
        Our immediate should extend to just 32'h923
        */
        #20; imm = 25'h240003; immsrc = TYPE_B;
        #20;
        check("B(no extension) test", immext, 32'h922);
        /*
        Let's use a memorable 13 bit hex like 13'h1922 or 13'b1_1001_0010_0010(remember we end in a 0)
        imm[12] is 1, imm[10:5] is 001001, imm[4:1] is 0001, imm[11] is 1 and imm[0] is implicitly 0 as the branch targets are aligned to 2-byte boundaries
        We fill the rest of the fields up with 1s
        Our 25 bit input is 25'b1001001111111111111100011 or 25'h127FFE3
        Our immediate should extend to just 32'hFFFFF922
        */
        #20; imm = 25'h127FFE3; immsrc = TYPE_B;
        #20;
        check("B(extension) test", immext, 32'hFFFFF922);


        /*
        U-type test
        Let's use a memorable 20 bit hex like 20'h12345 osr 20'b0001_0010_0011_0100_0101
        We fill the rest of the fields up with 0s
        Our 25 bit input is 25'b0001_0010_0011_0100_0101_0000_0 or 25'h2468A0
        Our immediate is shifted to 32'h12345000
        */
        #20; imm = 25'h2468A0; immsrc = TYPE_U;
        #20;
        check("U(no extension) test", immext, 32'h12345000);

        /*
        Let's use a memorable 20 bit hex like 20'hF2345 osr 20'b1111_0010_0011_0100_0101
        We fill the rest of the fields up with 1s
        Our 25 bit input is 25'b1111_0010_0011_0100_0101_1111_1 or 25'h1E468BF
        Our immediate is shifted to 32'hF2345000
        */
        #20; imm = 25'h1E468BF; immsrc = TYPE_U;
        #20;
        check("U(extension) test", immext, 32'hF2345000);

        /*
        J-type test
        Let's use a memorable 21 bit hex like 21'h12344 or 21'b0_0001_0010_0011_0100_0100
        imm[20] is 0, imm[10:1] is 011_0100_010, imm[11] is 0,imm[19:12] is 00010010
        We fill the rest of the fields up with 0s
        Our 25 bit input is 25'b0011010001000001001000000 or 25'h688240
        Our immediate is shifted to 32'b000_0000_0000_0010_0100_0110_1000_1000 or 32'h24688
        */

        #20; imm = 25'h688240; immsrc = TYPE_J;
        #20;
        check("J(extension) test", immext, 32'h24688);

        /*
        Let's use a memorable 21 bit hex like 21'h112344 or 21'b1_0001_0010_0011_0100_0100
        imm[20] is 1, imm[10:1] is 011_0100_010, imm[11] is 0,imm[19:12] is 00010010
        We fill the rest of the fields up with 1s
        Our 25 bit input is 25'b1011010001000001001011111 or 25'h168825F
        Our immediate is shifted to 32'b1111_1111_1110_0010_0100_0110_1000_1000
        */

        #20; imm = 25'h168825F; immsrc = TYPE_J;
        #20;
        check("J(extension) test", immext, 32'hFFE24688);

        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
