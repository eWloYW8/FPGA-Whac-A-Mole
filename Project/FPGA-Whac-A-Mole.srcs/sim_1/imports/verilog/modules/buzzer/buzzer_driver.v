module buzzer_driver(
    input clk,        // 时钟信号
    input [5:0] note, // 6位音调，支持更多低音
    output reg beep   // 蜂鸣器输出信号
);

    reg [31:0] cnt;
    reg [31:0] period;

    // 低音~高音频率表（clk=100MHz），C2~F#6
    always @(*) begin
        case(note)
            8'd0:  period = 32'd0;        // 静音
            8'd1:  period = 32'd95556;    // C2
            8'd2:  period = 32'd90194;    // C#2/Db2
            8'd3:  period = 32'd85131;    // D2
            8'd4:  period = 32'd80385;    // D#2/Eb2
            8'd5:  period = 32'd75922;    // E2
            8'd6:  period = 32'd71714;    // F2
            8'd7:  period = 32'd67742;    // F#2/Gb2
            8'd8:  period = 32'd63992;    // G2
            8'd9:  period = 32'd60456;    // G#2/Ab2
            8'd10: period = 32'd57122;    // A2
            8'd11: period = 32'd53984;    // A#2/Bb2
            8'd12: period = 32'd51036;    // B2
            8'd13: period = 32'd48267;    // C3
            8'd14: period = 32'd45668;    // C#3/Db3
            8'd15: period = 32'd43232;    // D3
            8'd16: period = 32'd40945;    // D#3/Eb3
            8'd17: period = 32'd38796;    // E3
            8'd18: period = 32'd36777;    // F3
            8'd19: period = 32'd34880;    // F#3/Gb3
            8'd20: period = 32'd33096;    // G3
            8'd21: period = 32'd31420;    // G#3/Ab3
            8'd22: period = 32'd29844;    // A3
            8'd23: period = 32'd28362;    // A#3/Bb3
            8'd24: period = 32'd26968;    // B3
            8'd25: period = 32'd23889;    // C4
            8'd26: period = 32'd22544;    // C#4/Db4
            8'd27: period = 32'd21284;    // D4
            8'd28: period = 32'd20096;    // D#4/Eb4
            8'd29: period = 32'd18960;    // E4
            8'd30: period = 32'd17896;    // F4
            8'd31: period = 32'd16896;    // F#4/Gb4
            8'd32: period = 32'd15944;    // G4
            8'd33: period = 32'd15048;    // G#4/Ab4
            8'd34: period = 32'd14204;    // A4
            8'd35: period = 32'd13408;    // A#4/Bb4
            8'd36: period = 32'd12654;    // B4
            8'd37: period = 32'd11944;    // C5
            8'd38: period = 32'd11272;    // C#5/Db5
            8'd39: period = 32'd10642;    // D5
            8'd40: period = 32'd10048;    // D#5/Eb5
            8'd41: period = 32'd9480;     // E5
            8'd42: period = 32'd8948;     // F5
            8'd43: period = 32'd8450;     // F#5/Gb5
            8'd44: period = 32'd7972;     // G5
            8'd45: period = 32'd7524;     // G#5/Ab5
            8'd46: period = 32'd7102;     // A5
            8'd47: period = 32'd6704;     // A#5/Bb5
            8'd48: period = 32'd6327;     // B5
            8'd49: period = 32'd5972;     // C6
            8'd50: period = 32'd5636;     // C#6/Db6
            8'd51: period = 32'd5318;     // D6
            8'd52: period = 32'd5018;     // D#6/Eb6
            8'd53: period = 32'd4736;     // E6
            8'd54: period = 32'd4474;     // F6
            8'd55: period = 32'd4225;     // F#6/Gb6
            8'd56: period = 32'd3986;     // G6
            8'd57: period = 32'd3762;     // G#6/Ab6
            8'd58: period = 32'd3551;     // A6
            8'd59: period = 32'd3352;     // A#6/Bb6
            8'd60: period = 32'd3164;     // B6
            8'd61: period = 32'd2986;     // C7
            8'd62: period = 32'd2820;     // C#7/Db7
            8'd63: period = 32'd0;        // 超高音静音
            default: period = 32'd0;
        endcase
    end

    always @(posedge clk) begin
        if(period == 0) begin
            cnt <= 0;
            beep <= 0;
        end else if(cnt >= period) begin
            cnt <= 0;
            beep <= ~beep;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule