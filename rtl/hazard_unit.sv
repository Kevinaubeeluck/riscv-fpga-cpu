module hazard_unit(
    input logic [4:0]           Rs1E_out,
    input logic [4:0]           Rs2E_out,
    input logic [4:0]           Rs1D,
    input logic [4:0]           Rs2D,
    input logic [2:0]           ResultSrcE_out,
    input logic [4:0]           RdM_out,
    input logic [4:0]           RdW_out,
    input logic [4:0]           RdE_out,
    input logic                 RegWriteW_out,
    input logic                 RegWriteM_out,
    output logic [1:0]          ForwardAE,
    output logic [1:0]          ForwardBE,
    output logic                StallD,
    output logic                StallF,
    output logic                FlushE
);
    

always_comb begin
    /*
    IF TWO OUTPUTS CAN BE INDEPENDANTLY TRUE,
    THEY CAN'T SHARE AN IF ELSE CHAIN 
    
    THIS BROKE FOR A CASE WHERE REGWRITEM
    WAS TRUE FOR FORWARDAE BUT REGWRITEW
    WAS TRUE FOR FORWARDBE BUT I SKIPPED THE 
    CONDITION BECAUSE THE IF LEAVES THE CONDITION
    AFTER IT EXECUTES A BRANCH

    

    if(RegWriteM_out)begin
        ForwardAE = (RdM_out == Rs1E_out) ? (2'b10) : (2'b00);
        ForwardBE = (RdM_out == Rs2E_out) ? (2'b10) : (2'b00);
    end
    else if(RegWriteW_out) begin
        ForwardAE = (RdW_out == Rs1E_out) ? (2'b11) : (2'b00);
        ForwardBE = (RdW_out == Rs2E_out) ? (2'b11) : (2'b00);
    end
    else begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
    end

    */

    ForwardAE = ((RdM_out == Rs1E_out) && RegWriteM_out) ? (2'b10) : (((RdW_out == Rs1E_out) && RegWriteW_out) ? (2'b01):(2'b00));
    ForwardBE = ((RdM_out == Rs2E_out) && RegWriteM_out) ? (2'b10) : (((RdW_out == Rs2E_out) && RegWriteW_out) ? (2'b01):(2'b00));


    //active low makes more sense if used as en
    StallF = !((ResultSrcE_out == 3'b001) && ((RdE_out == Rs1D)||(RdE_out == Rs2D)));
    StallD = StallF;
    FlushE = StallF;

end


endmodule
