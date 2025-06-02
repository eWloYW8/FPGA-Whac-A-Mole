module ps2_recorder (
    input clk,
    input reset,
    input ps2_clk,
    input ps2_data,
    output reg [31:0] record,
    output wire finished
);

    reg [1:0] sync_reg;      // PS/2时钟同步寄存器
    reg [10:0] shift_reg;    // 11位移位寄存器（起始位1 + 数据位8 + 校验位1 + 停止位1）
    reg [3:0] bit_count;      // 接收位计数器（0-10）
    wire ps2_clk_falling;    // PS/2时钟下降沿检测
    reg [2:0] count = 0;         // 用于记录接收的PS/2数据包数量

    assign finished = (count == 3'b011); // 当接收到3个数据包时完成

    // 同步PS/2时钟信号，检测下降沿
    always @(posedge clk or posedge reset) begin
        if (reset)
            sync_reg <= 2'b11;
        else
            sync_reg <= {sync_reg[0], ps2_clk};
    end
    assign ps2_clk_falling = (sync_reg == 2'b10);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 复位：计数器置零，移位寄存器置全1（空闲状态）
            bit_count <= 0;
            shift_reg <= 11'h7FF;
            record <= 0;
        end
        else if (ps2_clk_falling) begin  // PS/2时钟下降沿处理
            // 更新移位寄存器：高位存入新数据，低位右移
            shift_reg <= {ps2_data, shift_reg[10:1]};

            if (bit_count == 4'd10) begin  // 完成11位接收
                bit_count <= 0;            // 重置计数器
                // 更新record：左移8位，低8位存入新数据
                record <= {record[23:0], shift_reg[9:2]};
                count <= count + 1;       // 增加接收计数
                if (count == 3'b100) begin
                    // 当接收到3个数据包时，重置计数器
                    count <= 1;
                end
            end
            else begin
                bit_count <= bit_count + 1; // 继续接收
            end
        end
    end

endmodule