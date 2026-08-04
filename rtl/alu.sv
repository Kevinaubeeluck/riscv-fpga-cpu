module alu (
    input  logic [31:0] a, b,
    input  logic [2:0]  alu_op,
    output logic [31:0] result,
    output logic        zero       // result == 0 flag
);

localparam ADD  = 3'b000;
localparam SUB  = 3'b001;
localparam AND  = 3'b010;
localparam OR   = 3'b011;
localparam XOR  = 3'b100;
localparam SLT  = 3'b101;
localparam SLL  = 3'b110;
localparam SRL  = 3'b111;
// localparam SRA  = 4'b1000;
// localparam SLTU = 4'b1001;

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
        // SLTU: begin 
        //     if(a<b)begin
        //         result = 32'b1;
        //     end 
        //     else begin
        //         result = 32'b0;
        //     end
        // end
        SLL: begin 
            result = a<<b[4:0];
        end
        SRL: begin 
            result = a>>b[4:0];
        end
        // SRA: begin 
        //     result = $signed(a)>>>$signed(b[4:0]);
        // end
        default: result = a;
    endcase
    zero = (result == '0);
end


endmodule
