module decoder(
    input logic [6:0] op,
    input logic [2:0] func3,
    input logic funct7,
    input logic zero, 
    output logic PCSrc,
    output logic ResultSrc,
    output logic Memwrite,
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic [2:0] ImmSrc,
    output logic regwrite
);

localparam lw = 7'b0000011;
localparam sw = 7'b0000011;
localparam Rtype = 7'b0000011;
localparam beq = 7'b0000011;

localparam add = 2'b00;
localparam sub = 2'b01;
localparam alu = 2'b11;

logic [1:0] AluOp;

logic Branch;

always_comb begin
    case(op)
        lw: begin
            regwrite    = 1'b1;
            ImmSrc      = 2'b0;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b1;
            Branch      = 1'b0;
            AluOp       = 2'b0;
        end

        sw: begin
            regwrite    = 1'b0;
            ImmSrc      = 2'b1;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b1; //don't care
            Branch      = 1'b0;
            AluOp       = 2'b0;
        end

        Rtype: begin
            regwrite    = 1'b1;
            ImmSrc      = 2'b1; //don't care
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b0; 
            Branch      = 1'b0;
            AluOp       = 2'b10;
        end

        beq: begin
            regwrite    = 1'b0;
            ImmSrc      = 2'b10; //don't care
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b0; //don't care
            Branch      = 1'b0;
            AluOp       = 2'b10;
        end
        default:begin
            regwrite    = 1'b0;
            ImmSrc      = 2'b0; //don't care
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b0; 
            Branch      = 1'b0;
            AluOp       = 2'b0;
        end
    endcase

    case(alu_op)
        add:begin
            ALUControl = 3'b000;
        end
        sub:begin
            ALUControl = 3'b001;
        end
        alu: begin 
            case(func3)
                000:begin 
                    case({op[5],funct7[5]})
                        11: begin
                            ALUControl = 3'b001;
                        end
                        default: begin
                            ALUControl = 3'b000;
                        end
                    endcase
                end
                010:begin
                    ALUControl = 3'b101;
                end
                110:begin
                    ALUControl = 3'b011;
                end
                111:begin
                    ALUControl = 3'b010;
                end
            endcase
        end
    endcase

    PCSrc = Branch & zero;
end

endmodule