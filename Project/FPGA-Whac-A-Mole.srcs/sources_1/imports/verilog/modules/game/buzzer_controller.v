module buzzer_controller(
    input wire clk,        // 时钟信号
    input wire [15:0] score, // 分数
    input wire mouse_click, // 鼠标是否点击
    input wire is_win,
    input wire is_lose,
    input wire [2:0] live, // 生命值
    input wire enabled, // 蜂鸣器是否启用
    input wire reset, // 重置信号
    output reg [5:0] note // 6位音调
);

    reg is_playing = 0; // 蜂鸣器是否正在播放
    reg prev_is_win = 0; // 上一帧是否胜利状态
    reg prev_is_lose = 0; // 上一帧是否失败状态
    reg [2:0] prev_live = 3'd0; // 上一帧的生命值
    reg [15:0] prev_score = 16'd0; // 上一帧的分数
    
    reg [511:0] current_notelist; // 当前音符列表 512 = 64 * 8
    reg [511:0] current_notelist_length; // 当前音符列表长度

    reg [31:0] current_playtime; // 当前播放时间

    wire [31:0] div_res;

    clkdiv u_clkdiv (
        .clk(clk),
        .rst(reset),
        .div_res(div_res)
    );

    always @(posedge div_res[17]) begin
        if (reset) begin
            is_playing <= 0;
            note <= 8'd0;
            current_playtime <= 32'd0;
        end else if (enabled) begin
            if (is_playing) begin
                current_playtime <= current_playtime + 1;
                if (current_playtime >= current_notelist_length[7:0]) begin // 此处待分频
                    current_notelist_length <= current_notelist_length >> 8; // 每次播放完一段音符，长度右移8位，播放下一段
                    current_notelist <= current_notelist >> 8;
                    current_playtime <= 32'd0; // 重置播放时间
                    if (current_notelist_length == 0) begin
                        is_playing <= 0; // 如果没有音符了，停止播放
                        note <= 8'd0;
                    end else begin
                        note <= current_notelist[7:0]; // 获取当前音符
                    end
                end
            end else if (is_win && !prev_is_win) begin
                // 播放胜利音效
                is_playing <= 1;
                current_notelist <= {
                    8'd15, // C4
                    8'd22, // G4
                    8'd15, // C4
                    8'd19, // E4
                    8'd24, // A4
                    8'd22, // G4
                    8'd19, // E4
                    8'd22, // G4
                    8'd15, // C4
                    8'd19, // E4
                    8'd22, // G4
                    8'd15  // C4
                };
                current_notelist_length <= {
                    8'd100, // C4
                    8'd80,  // G4
                    8'd80,  // C4
                    8'd80,  // E4
                    8'd100, // A4
                    8'd80,  // G4
                    8'd80,  // E4
                    8'd80,  // G4
                    8'd80,  // C4
                    8'd80,  // E4
                    8'd100, // G4
                    8'd120  // C4
                };
                current_playtime <= 32'd0;
            end else if (is_lose && !prev_is_lose) begin
                // 播放失败音效
                is_playing <= 1;
                current_notelist <= {
                    8'd25, // C4
                    8'd20, // G3
                    8'd17, // E3
                    8'd15, // D3
                    8'd13, // C3
                    8'd10  // A2
                };
                current_notelist_length <= {
                    8'd100, // C4
                    8'd100, // G3
                    8'd100, // E3
                    8'd100, // D3
                    8'd120, // C3
                    8'd140  // A2
                };
                current_playtime <= 32'd0;
            end else if (score > prev_score) begin
                is_playing <= 1;
                current_notelist <= {
                    8'd27, // C5 — 短促高音，命中瞬间
                    8'd22, // G4 — 上跳音
                    8'd19, // E4 — 中音铺垫
                    8'd15  // C4 — 起始低音
                };

                current_notelist_length <= {
                    8'd20,  // C5 — 击中瞬间（短）
                    8'd30,  // G4 — 稍短
                    8'd30,  // E4 — 中
                    8'd30   // C4 — 起手
                };
                current_playtime <= 32'd0;
            end else if (live < prev_live) begin
                is_playing <= 1;
                current_notelist <= {
                    8'd12, // A3 — 生命流失感，下坠
                    8'd18, // D#4 — 尖锐惊吓感
                    8'd26, // B4 — 紧张
                    8'd30, // D#5 — 突兀尖锐
                    8'd34, // G5 — 高频警报
                    8'd36  // A5 — 命中/警告音
                };

                current_notelist_length <= {
                    8'd50, // A3 — 收尾下坠
                    8'd30,  // D#4
                    8'd30,  // B4
                    8'd20,  // D#5
                    8'd20,  // G5
                    8'd20   // A5
                };
                current_playtime <= 32'd0;
            end else if (mouse_click) begin
                // 播放点击音效
                is_playing <= 1;
                current_notelist <= {
                    8'd15, // C4 — 收尾下坠，模拟空振
                    8'd16, // C#4 — 落空提示
                    8'd17, // D4 — 次级点击声
                    8'd19  // E4 — 起始“点击”
                };

                current_notelist_length <= {
                    8'd30, // C4
                    8'd20, // C#4
                    8'd20, // D4
                    8'd30  // E4
                };
                current_playtime <= 32'd0;
            end else begin
                is_playing <= 0;
                note <= 8'd0;
            end
        end else begin
            is_playing <= 0;
            note <= 8'd0;
            current_playtime <= 32'd0;
        end
        prev_is_win <= is_win; // 更新上一帧的胜利状态
        prev_is_lose <= is_lose; // 更新上一帧的失败状态
        prev_live <= live; // 更新上一帧的生命值
        prev_score <= score; // 更新上一帧的分数
    end

endmodule