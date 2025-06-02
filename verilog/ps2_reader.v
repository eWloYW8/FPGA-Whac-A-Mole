module ps2_reader (
    input wire clk,         // 系统时钟
    input wire reset,       // 复位信号（在上升沿开始采集）
    input wire ps2_clk,     // PS/2 时钟
    input wire ps2_data,    // PS/2 数据
    output reg [31:0] record // 输出：四个数据字节拼成的记录
);

    reg [3:0] bit_count = 0;
    reg [7:0] data_byte = 0;
    reg [1:0] byte_count = 0;
    reg [31:0] record_temp = 0;

    reg ps2_clk_prev = 1;
    reg sampling = 0;
    reg [3:0] state = 0;
    reg reset_prev = 0;

    always @(posedge clk) begin
        // 检测 reset 上升沿
        reset_prev <= reset;
        if (reset && !reset_prev) begin
            // 进入采样状态
            sampling <= 1;
            bit_count <= 0;
            byte_count <= 0;
            record_temp <= 0;
            record <= 0;
            state <= 0;
        end

        // 边沿检测：PS/2 时钟下降沿
        ps2_clk_prev <= ps2_clk;
        if (sampling && ps2_clk_prev && !ps2_clk) begin
            case (state)
                0: begin
                    // 起始位，跳过（应为0）
                    state <= 1;
                end
                1,2,3,4,5,6,7,8: begin
                    // 接收8位数据（低位先发）
                    data_byte[state - 1] <= ps2_data;
                    state <= state + 1;
                end
                9: begin
                    // 奇偶校验位（可以忽略或校验）
                    state <= 10;
                end
                10: begin
                    // 停止位
                    // 保存当前字节
                    record_temp <= {data_byte, record_temp[31:8]};
                    byte_count <= byte_count + 1;

                    // 若已收集4个字节，完成采样
                    if (byte_count == 3) begin
                        record <= {data_byte, record_temp[31:8]};
                        sampling <= 0;
                    end
                    state <= 0;
                end
            endcase
        end
    end

endmodule
