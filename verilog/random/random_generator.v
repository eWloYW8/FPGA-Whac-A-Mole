module random_generator (
    input wire clk,                   // 时钟信号
    input wire [15:0] max_value,      // 随机数最大值（不包括）
    output reg [15:0] random_number   // 输出的随机数
);

    reg [15:0] lfsr = 16'hACE1;       // 初始种子
    wire feedback;

    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clk) begin
        lfsr <= {lfsr[14:0], feedback};

        if (max_value != 0)
            random_number <= lfsr % max_value;
        else
            random_number <= 0;
    end

endmodule