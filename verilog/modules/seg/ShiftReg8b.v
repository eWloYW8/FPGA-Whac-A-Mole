module ShiftReg
    #(parameter BIT_WIDTH = 8) (
    input clk,
    input shiftn_loadp,
    input shift_in,
    input [BIT_WIDTH-1:0] par_in,
    output [BIT_WIDTH-1:0] Q
);
    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH; i = i + 1) begin
            FD fd_inst (
                .clk(clk),
                .D(shiftn_loadp ? par_in[i] : (i == BIT_WIDTH-1 ? shift_in : Q[i+1])),
                .Q(Q[i]),
                .Qn()
            );
        end
    endgenerate
endmodule
