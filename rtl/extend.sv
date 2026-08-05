module extend(
    input logic [31:7] imm,
    input logic [2:0] immsrc,
    output logic [31:0] immext
);

typedef enum logic[2:0] {  
    TYPE_R = 3'b000,
    TYPE_I = 3'b001,
    TYPE_S = 3'b010,
    TYPE_B = 3'b011,
    TYPE_U = 3'b100,
    TYPE_J = 3'b101
} imm_src_sel;

always_comb begin
    case(immsrc)
        TYPE_I:begin
            immext = {{20{imm[31]}},imm[31:20]};
        end
        TYPE_S:begin
            immext = {{20{imm[31]}},{imm[31:25],imm[11:7]}};
        end 
        TYPE_B:begin
            immext = {{19{imm[31]}},{imm[31],imm[7],imm[30:25],imm[11:8],1'b0}}; 
            /*
            Remember B and J immediates are implicitly zero biased bc of their 2-byte align thingy
            */
        end
        TYPE_U:begin
            immext = {{12{imm[31]}},{imm[31:12]}};
            immext = immext << 12;
        end
        TYPE_J:begin
            immext = {{11{imm[31]}},{imm[31],imm[19:12],imm[20],imm[30:21],1'b0}};
            immext = immext << 1;
        end
        default:begin
            immext = '0;
        end
    endcase
end
    
endmodule
