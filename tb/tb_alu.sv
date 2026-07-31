module tb;
    logic [31:0] a, b;
    logic [3:0]  alu_op;
    logic [31:0] result;
    logic        clk,zero;       // result == 0 flag

    alu uut(.*);

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("waves.vcd");
        $dumpvars(0,tb);
        a = 0; b = 0; alu_op = 0;

        #20; a = 32'd4; b = 32'd5;alu_op=4'b0;
        #10; $display("4 + 5 = %d(should be 9)",result);

        #20; a = 32'd4; b = 32'd5;alu_op=4'b1;
        #10; $display("4 - 5 = %d(should be -1)",result);

        #20; a = 32'b1010; b = 32'b0010;alu_op=4'b10;
        #10; $display("1010 & 0010 = %h(should be 0x2)",result);

        #20; a = 32'b1010; b = 32'b0010;alu_op=4'b11;
        #10; $display("1010 | 0010 = %h(should be 0xa)",result);

        #20; a = 32'b1010; b = 32'b0010;alu_op=4'b100;
        #10; $display("1010 ^ 0010 = %h(should be 0x8)",result);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=4'b101;
        #10; $display("FFFF1234 SLT 0010 = %h(should be 0x1)",result);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=4'b110;
        #10; $display("FFFF1234 SLL 2 = %h(should be 0xFFFC48D0)",result);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=4'b111;
        #10; $display("FFFF1234 SRL 2 = %h(should be 0x3fffc48d)",result);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=4'b1000;
        #10; $display("FFFF1234 SRA 2 = %h(should be 0xFFFFC48D)",result);
        #20; $display("Checking on zero: zero = %h",zero);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=4'b1001;
        #10; $display("FFFF1234 SLTU 2 = %h(should be 0)",result);

        #20; $display("Checking on zero: zero = %h",zero);
        #20; $finish;
    end
endmodule
