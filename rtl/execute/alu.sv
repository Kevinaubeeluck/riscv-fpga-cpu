module alu (
    input  logic [31:0] a, b,
    input  logic [3:0]  alu_op,
    output logic [31:0] result,
    output logic        zero       // result == 0 flag
);

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


always_comb begin
    case (alu_op)
        ADD: begin 
            result = a+b;
        end
        SUB: begin 
            result = a-b;
        end
        AND: begin 
            result = a&b;
        end
        OR: begin 
            result = a|b;
        end
        XOR: begin 
            result = a^b;
        end
        SLT: begin 
            if($signed(a)<$signed(b))begin
                result = 32'b1;
            end 
            else begin
                result = 32'b0;
            end
        end
        SLTU: begin 
            if(a<b)begin
                result = 32'b1;
            end 
            else begin
                result = 32'b0;
            end
        end
        SLL: begin 
            result = a<<b[4:0];
        end
        SRL: begin 
            result = a>>b[4:0];
        end
        SRA: begin 
            result = $signed(a)>>>$signed(b[4:0]);
        end
        default: result = a;
    endcase
    zero = (result == '0);
end


endmodule
