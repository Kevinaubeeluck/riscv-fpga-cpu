module alu (
    input  logic [31:0] a, b,
    input  logic [3:0]  alu_op,
    output logic [31:0] result,
    output logic        zero       // result == 0 flag
);

localparam ADD  = 4'b0000;
localparam SUB  = 4'b0001;
localparam AND  = 4'b0010;
localparam OR   = 4'b0011;
localparam XOR  = 4'b0100;
localparam SLT  = 4'b0101;
localparam SLL  = 4'b0110;
localparam SRL  = 4'b0111;
localparam SRA  = 4'b1000;
localparam SLTU = 4'b1001;

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
