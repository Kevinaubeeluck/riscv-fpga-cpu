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

typedef enum logic[2:0] {
    IMM_I = 3'b000,
    IMM_S = 3'b001,
    IMM_B = 3'b010
  } imm_src_t;

localparam lw = 7'b0000011;
localparam sw = 7'b0100011;
localparam Rtype = 7'b0110011;
localparam beq = 7'b1100011;

localparam add = 2'b00;
localparam sub = 2'b01;
localparam alu = 2'b10;

logic [1:0] AluOp;

logic Branch;

always_comb begin
    case(op)
        lw: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_I;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b1;
            Branch      = 1'b0;
            AluOp       = add;
        end

        sw: begin
            regwrite    = 1'b0;
            ImmSrc      = IMM_S;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b1;
            ResultSrc   = 'x; //don't care
            Branch      = 1'b0;
            AluOp       = add;
        end

        Rtype: begin
            regwrite    = 1'b1;
            ImmSrc      = 'x; //don't care
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b0; 
            Branch      = 1'b0;
            AluOp       = alu;
        end

        beq: begin
            regwrite    = 1'b0;
            ImmSrc      = IMM_B; 
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 'x; //don't care
            Branch      = 1'b1;
            AluOp       = sub;
        end
        default:begin
            regwrite    = 1'b0;
            ImmSrc      = 2'b0; 
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 1'b0; 
            Branch      = 1'b0;
            AluOp       = 2'b0;
        end
    endcase

    case(AluOp)
        add:begin
            ALUControl = 3'b000;
        end
        sub:begin
            ALUControl = 3'b001;
        end
        alu: begin 
            case(func3)
                3'b000:begin 
                    case({op[5],funct7})
                        2'b11: begin
                            ALUControl = 3'b001;
                        end
                        default: begin
                            ALUControl = 3'b000;
                        end
                    endcase
                end
                3'b010:begin
                    ALUControl = 3'b101;
                end
                3'b110:begin
                    ALUControl = 3'b011;
                end
                3'b111:begin
                    ALUControl = 3'b010;
                end
                default:begin
                    ALUControl = 3'b000;
                end
            endcase
        end
    endcase

    PCSrc = Branch & zero;
end

endmodule