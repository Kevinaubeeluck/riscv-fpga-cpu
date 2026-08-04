module tb;
    logic [31:0] a, b;
    logic [3:0]  alu_op;
    logic [31:0] result;
    logic        clk,zero;       // result == 0 flag

    alu uut(.*);

    typedef enum logic [3:0] {
    ADD  = 4'b0000,
    SUB  = 4'b0001,
    SLL  = 4'b0010,
    SLT  = 4'b0011,
    SLTU = 4'b0100,
    XOR  = 4'b0101,
    SRL  = 4'b0110,
    SRA  = 4'b0111,
    OR   = 4'b1000,
    AND  = 4'b1001
} alu_ctrl_t;

    int pass_count = 0;
    int fail_count = 0;

    always #5 clk = ~clk;
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
        a = 0; b = 0; alu_op = 0;

        #20; a = 32'd4; b = 32'd5;alu_op=ADD;
        #10; check("Add test", result, 9);

        #20; a = 32'd5; b = 32'd4;alu_op=SUB;
        #10; check("Sub test", result, 1);

        #20; a = 32'b1010; b = 32'b0010;alu_op=AND;
        #10; check("AND test", result, 32'h2);

        #20; a = 32'b1010; b = 32'b0010;alu_op=OR;
        #10; check("OR test", result, 32'ha);

        #20; a = 32'b1010; b = 32'b0010;alu_op=XOR;
        #10; check("XOR test", result, 32'h8);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=SLT;
        #10; check("SLT test", result, 32'h1);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=SLL;
        #10; check("SLL test", result, 32'hFFFC48D0);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=SRL;
        #10; check("SRL test", result, 32'h3fffc48d);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=SRA;
        #10; check("SRA test", result, 32'hFFFFC48D);
        #20; check("Zero test", zero, '0);

        #20; a = 32'hFFFF1234; b = 32'b0010;alu_op=SLTU;
        #10; check("SLTU test", result, 0);

        #20; check("Zero test", zero, 1'b1);
        
        $display("\n===== Results: %0d passed, %0d failed =====", pass_count, fail_count);

        $display("End of testing");
        #20; $finish;
    end
endmodule
