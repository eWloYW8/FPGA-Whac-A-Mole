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
            mouse_click_mole[0] <= (x_pos >= 106 && x_pos <= 151 && y_pos >= 273 && y_pos <= 307);
            mouse_click_mole[1] <= (x_pos >= 230 && x_pos <= 274 && y_pos >= 270 && y_pos <= 305);
            mouse_click_mole[2] <= (x_pos >= 350 && x_pos <= 392 && y_pos >= 271 && y_pos <= 306);
            mouse_click_mole[3] <= (x_pos >= 470 && x_pos <= 513 && y_pos >= 270 && y_pos <= 306);
            mouse_click_mole[4] <= (x_pos >= 94 && x_pos <= 140 && y_pos >= 320 && y_pos <= 352);
            mouse_click_mole[5] <= (x_pos >= 224 && x_pos <= 269 && y_pos >= 320 && y_pos <= 352);
            mouse_click_mole[6] <= (x_pos >= 353 && x_pos <= 400 && y_pos >= 320 && y_pos <= 352);
            mouse_click_mole[7] <= (x_pos >= 480 && x_pos <= 528 && y_pos >= 320 && y_pos <= 352);
            mouse_click_mole[8] <= (x_pos >= 78 && x_pos <= 125 && y_pos >= 374 && y_pos <= 408);
            mouse_click_mole[9] <= (x_pos >= 218 && x_pos <= 271 && y_pos >= 374 && y_pos <= 408);
            mouse_click_mole[10] <= (x_pos >= 357 && x_pos <= 408 && y_pos >= 374 && y_pos <= 408);
            mouse_click_mole[11] <= (x_pos >= 496 && x_pos <= 550 && y_pos >= 374 && y_pos <= 408);

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