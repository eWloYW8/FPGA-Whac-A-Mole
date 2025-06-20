module vga_driver (
    input wire        vga_clk,        // VGA时钟
    input wire        reset,          // 异步复位 (高电平有效)
    input wire [11:0] pixel_data,     // 像素数据 bbbb_gggg_rrrr
    
    output reg [10:0] row_address,    // 显存行地址
    output reg [10:0] col_address,    // 显存列地址
    output reg        read_pixel_n,   // 显存读取使能 (低电平有效)
    output reg [3:0]  red_out,        // 红色输出
    output reg [3:0]  green_out,      // 绿色输出
    output reg [3:0]  blue_out,       // 蓝色输出
    output reg        hor_sync,       // 水平同步信号
    output reg        ver_sync        // 垂直同步信号
);

// 时序参数
localparam h_active  =  640;
                       
localparam h_front   =  16;
                       
localparam h_pulse   =  96;
                       
localparam h_back    =  48;
                       
localparam v_active  =  480;
                       
localparam v_front   =  11;
                       
localparam v_pulse   =  2;
                       
localparam v_back    =  31;

// 计算总扫描周期
localparam h_whole = h_active + h_front + h_pulse + h_back;
localparam v_whole = v_active + v_front + v_pulse + v_back;

// 水平和垂直计数器
reg [11:0] h_count;
reg [11:0] v_count;

// 显示使能信号
reg display_enable;
wire next_display_enable;

// 根据当前计数器值计算显示区域
assign next_display_enable = (h_count < h_active) && (v_count < v_active);

always @(posedge vga_clk or posedge reset) begin
    if (reset) begin
        // 计数器复位
        h_count <= 0;
        v_count <= 0;
        
        // 输出复位
        row_address <= 0;
        col_address <= 0;
        read_pixel_n <= 1;          // 读取使能无效
        red_out <= 0;
        green_out <= 0;
        blue_out <= 0;
        hor_sync <= 1;               // 同步信号复位状态
        ver_sync <= 1;
        display_enable <= 0;
    end else begin
        // 更新水平计数器
        if (h_count < h_whole - 1) begin
            h_count <= h_count + 1;
        end else begin
            h_count <= 0;
            // 更新垂直计数器
            if (v_count < v_whole - 1) begin
                v_count <= v_count + 1;
            end else begin
                v_count <= 0;
            end
        end
        
        // 锁存显示使能信号
        display_enable <= next_display_enable;
        
        // 同步信号生成
        hor_sync <= ~((h_count >= h_active + h_front) && 
                    (h_count < h_active + h_front + h_pulse));
                    
        ver_sync <= ~((v_count >= v_active + v_front) && 
                    (v_count < v_active + v_front + v_pulse));
        
        // 显存地址和读取使能
        read_pixel_n <= ~next_display_enable;
        row_address <= (v_count < v_active) ? v_count[10:0] : 0;
        col_address <= (h_count < h_active) ? h_count[10:0] : 0;
        
        // RGB数据输出
        if (display_enable) begin
            red_out   <= pixel_data[3:0];   // 低4位为红色
            green_out <= pixel_data[7:4];   // 中间4位为绿色
            blue_out  <= pixel_data[11:8];  // 高4位为蓝色
        end else begin
            // 非显示区域输出黑色
            red_out   <= 0;
            green_out <= 0;
            blue_out  <= 0;
        end
    end
end

endmodule