module decoder(
    input logic [6:0]       op,
    input logic [2:0]       func3,
    input logic             funct7,
//    input logic             zero, 
 //   output logic [1:0]      PCSrc,
    output logic [2:0]      ResultSrc,
    output logic            Memwrite,
    output logic [3:0]      ALUControl,
    output logic            ALUSrc,
    output logic            Jump,
    output logic            Branch,
    output logic            eq_check,
    output logic [2:0]      ImmSrc,
    output logic            regwrite
);

/*
Using enums here makes the code 10 billion percent easier to read
also remember to never use bare literals
*/

typedef enum logic[2:0] {
    IMM_I = 3'b001,
    IMM_S = 3'b010,
    IMM_B = 3'b011,
    IMM_U = 3'b100,
    IMM_J = 3'b101
} imm_src_t;

typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b0001,
    ALU_SLL  = 4'b0010,
    ALU_SLT  = 4'b0011,
    ALU_SLTU = 4'b0100,
    ALU_XOR  = 4'b0101,
    ALU_SRL  = 4'b0110,
    ALU_SRA  = 4'b0111,
    ALU_OR   = 4'b1000,
    ALU_AND  = 4'b1001
} alu_ctrl_t;


typedef enum logic [6:0] { 
    LW = 7'b0000011,
    SW = 7'b0100011,
    RTYPE = 7'b0110011,
    BTYPE = 7'b1100011,
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    ITYPE = 7'b0010011,
    JAL = 7'b1101111,
    JALR = 7'b1100111
} opcodes;

typedef enum logic[1:0]{
    offset = 2'b00,
    sub = 2'b01,
    rtype = 2'b10,
    tree = 2'b11 /// We're already using Branch as a wire so calling this state tree is easier to think about
}alu_op_cases;

logic [1:0] AluOp;


// logic Zero_temp;




always_comb begin
  //  PCSrc = '0;

    case(op)
        LW: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_I;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b1;
            Jump        = '0;
            Branch      = 1'b0;
            AluOp       = offset;
        end

        SW: begin
            regwrite    = 1'b0;
            ImmSrc      = IMM_S;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b1;
            ResultSrc   = 'x; //don't care
            Branch      = 1'b0;
            Jump        = '0;
            AluOp       = offset;
        end

        RTYPE: begin
            regwrite    = 1'b1;
            ImmSrc      = 'x; //don't care
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b0; 
            Jump        = 1'b0;
            Branch      = 1'b0;
            AluOp       = rtype;
        end

        ITYPE: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_I; 
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b0; 
            Branch      = 1'b0;
            Jump        = '0;
            AluOp       = rtype;
        end

        LUI: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_U; 
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b10; 
            Branch      = 1'b0;
            Jump        = '0;
            AluOp       = 'x;
        end



        AUIPC: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_U; 
            ALUSrc      = 'x;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b100; 
            Branch      = 1'b0;
            Jump        = '0;
            AluOp       = 'x;
        end

        JAL:begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_J; 
            ALUSrc      = 'x;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b11; 
            Jump        = 1'b1;
            Branch      = '0;
            AluOp       = 'x;  
        end

        JALR: begin
            regwrite    = 1'b1;
            ImmSrc      = IMM_I;
            ALUSrc      = 1'b1;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b11;
            Jump        = 1'b1;
            Branch       = 1'b1;
            AluOp       = offset;
        end
        BTYPE: begin
            regwrite    = 1'b0;
            ImmSrc      = IMM_B; 
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 'x; //don't care
            Branch      = 1'b1;
            AluOp       = tree;
        end
        default:begin
            regwrite    = 1'b0;
            ImmSrc      = 3'b0; 
            ALUSrc      = 1'b0;
            Memwrite    = 1'b0;
            ResultSrc   = 3'b0; 
            Branch      = 1'b0;
            AluOp       = 2'b0;
        end
    endcase

    case(AluOp)
        offset:begin
            ALUControl = ALU_ADD; //add 
        end
        tree:begin
            case(func3)
                3'b000:begin
                    ALUControl = ALU_SUB; //beq
                    eq_check = 1'b1;
                end
                3'b001:begin
                    ALUControl = ALU_SUB; //bne
                    eq_check = 1'b0;
                end
                3'b100:begin
                    ALUControl = ALU_SLT; //blt
                    eq_check = 1'b0;
                end
                3'b101:begin 
                    ALUControl = ALU_SLT; //bge
                    eq_check = 1'b1;
                end
                3'b110:begin
                    ALUControl = ALU_SLTU; //bltu
                    eq_check = 1'b0;
                end
                3'b111:begin
                    ALUControl = ALU_SLTU; //bgeu  
                    eq_check = 1'b1;
                end
                default: begin
                    ALUControl = ALU_ADD; //This way i can tell if i put in an incorrect func3
                    eq_check = 1'b1;
                end
            endcase
            //Zero_temp = (eq_check) ? (zero) : (!zero);
           // PCSrc = (Branch & Zero_temp) ? (2'b01) : (2'b00);
        end
        rtype: begin 
            case(func3)
                3'b000:begin 
                    case({op[5],funct7})
                        2'b11: begin
                            ALUControl = ALU_SUB; //sub
                        end
                        2'b10:begin
                            ALUControl = ALU_ADD; //add
                        end
                        default: begin
                            ALUControl = ALU_ADD;// add
                        end
                    endcase
                end
                3'b001: begin
                    ALUControl = ALU_SLL;//sll
                end
                3'b010:begin
                    ALUControl = ALU_SLT; //slt 
                end
                3'b011: begin
                    ALUControl = ALU_SLTU; //sltu
                end
                3'b100: begin
                    ALUControl = ALU_XOR; //xor
                end
                3'b101:begin
                    case({op[5],funct7})
                        2'b11: begin
                            ALUControl = ALU_SRL; //srl
                        end
                        2'b10:begin
                            ALUControl = ALU_SRA; //sra
                        end
                        default: begin
                            ALUControl = ALU_SRL;// srl
                        end
                    endcase                end
                3'b110:begin
                    ALUControl = ALU_OR; //or
                end
                3'b111:begin
                    ALUControl = ALU_AND;   //and 
                end
                default:begin
                    ALUControl = ALU_ADD; //add
                end
            endcase
        end
        default:begin
            ALUControl = ALU_ADD;
        end
    endcase

end

endmodule
