module random_generator (
    input wire clk,                   // 时钟信号
    output reg [15:0] random_number   // 输出的随机数
);

    // 16位线性反馈移位寄存器 (LFSR)
    reg [15:0] lfsr = 16'hACE1;

    always @(posedge clk) begin
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        random_number <= lfsr;
    end

endmodule