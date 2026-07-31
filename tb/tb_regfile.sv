module tb;
    logic        clk,we;         
    logic [4:0]  ra1,ra2,wa;
    logic [31:0] wd;
    wire [31:0] rd1,rd2 ;   

    regfile uut(
    .clk(clk),
    .we(we),         // write enable
    .ra1(ra1), 
    .ra2(ra2),   // read addresses (2 ports)
    .wa(wa),         // write address
    .wd(wd),         // write data
    .rd1(rd1), 
    .rd2(rd2)   // read data (2 ports)
);

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("waves.vcd");
        $dumpvars(0,tb);
        clk = 0; we = 0; ra1 = 0; ra2 = 0; wa = 0; wd = 0; 

        #20; wa = 5; wd = 32'hDEADBEEF;we = 1;
        #10; we = 0;

        #10; ra1 = 5;
        #10; $display("rd1 = %h(should be DEADBEEF)",rd1);

        #20; wa = 0; wd = 32'hDEADBEEF;we = 1;
        #10; we = 0;

        #10; ra2 = 0;
        #10; $display("ra2(reg %h) = %h(should be 0)",ra2,rd2);

        
        #20; wa = 3; wd = 32'h01234567;we = 1;
        #10; we = 0;
    
        #10; ra2 = 3;
        #10; $display("rd2 = %h(should be 01234567), rd1 = %h(should be DEADBEEF)",rd2,rd1); 

        #20; $finish;
    end
endmodule
