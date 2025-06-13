module mouse_monitor (
    input clk,
    input [11:0] x_pos, // 鼠标X坐标
    input [11:0] y_pos, // 鼠标Y坐标
    input left_btn, // 鼠标左键
    input right_btn, // 鼠标右键
    output reg [11:0] mouse_click_mole, // 鼠标是否击中地鼠
    output reg mouse_click_pausebutton, // 鼠标是否点击暂停按钮
    output reg mouse_click, // 鼠标是否点击
    output reg mouse_right_click // 鼠标右键点击
);

    reg prev_left_btn = 0;
    reg prev_right_btn = 0;

    always @(negedge clk) begin
        if (left_btn && !prev_left_btn) begin
            // 坐标判断逻辑待补充
            mouse_click <= 1;
        end else begin
            // 鼠标左键未按下时，重置悬停状态
            mouse_click_mole <= 0;
            mouse_click_pausebutton <= 0;
            mouse_click <= 0;
        end

        if (right_btn && !prev_right_btn) begin
            mouse_right_click <= 1;
        end else begin
            mouse_right_click <= 0;
        end
    end

endmodule