module image_reader_gologo_rgba #(
    parameter WIDTH = 45,
    parameter HEIGHT = 61
)(
    input  wire clk,
    input  wire [9:0]  x,          // X坐标 0~44
    input  wire [8:0]  y,          // Y坐标 0~60
    output reg  [15:0] pixel_rgba  // 16-bit RGBA输出 R[15:12], G[11:8], B[7:4], A[3:0]
);

    wire [18:0] addr;
    assign addr = y * WIDTH + x;

    wire [15:0] dout;

    blk_mem_gen_gologo_rgba u_bram (
        .clka(clk),
        .wea(1'b0),
        .addra(addr),
        .dina(16'b0),
        .douta(dout)
    );

    always @(posedge clk) begin
        pixel_rgba <= dout;
    end

endmodule
