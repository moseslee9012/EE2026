`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Zhong Heng
//  STUDENT B NAME: Woo Wen Jun
//  STUDENT C NAME: Er Jun Ze
//  STUDENT D NAME: Moses
//
//////////////////////////////////////////////////////////////////////////////////

module MainController(
    input sysclk,          // 100MHz clock
    input [4:0] btn,
    input [15:0] sw,
    output [3:0] an,
    output [7:0] seg,
    output reg [15:0] led,
    input J_MIC3_Pin3, 
    output J_MIC3_Pin1, 
    output J_MIC3_Pin4,       // Audio In port
    output [3:0] JA,       // Audio Out port
    output [7:0] JC,       // OLED Display port
    inout ps2_clk,         // Used for mouse
    inout ps2_data         // Used for mouse
    );
    
    wire clock50M, clock20k;
    wire [3:0] state;
    
    Clock clk50M(.sysclk(sysclk), .compare(1), .out(clock50M));
    Clock clk20k(.sysclk(sysclk), .compare(2_499), .out(clock20k));
    
    assign state = sw[13:10];
    
    // Audio In
    wire [11:0] audio_in_data;
    
    Audio_Input audio_in_module(
        .CLK(sysclk),
        .cs(clock20k),
        .MISO(J_MIC3_Pin3),                
        .clk_samp(J_MIC3_Pin1),            
        .sclk(J_MIC3_Pin4),             
        .sample(audio_in_data)   
    );
    
    // Audio Out
    reg [11:0] audio_out_data = 0;
    
    Audio_Output audio_out_module(
        .CLK(clock50M),
        .DATA1(audio_out_data),
        .DATA2(0),
        .START(clock20k),
        .RST(0),
        .D1(JA[1]),
        .D2(JA[2]),
        .CLK_OUT(JA[3]),
        .nSYNC(JA[0])
    );
    
    // OLED Display
    wire clock6_25M;
    wire [12:0] pixel_index;
    wire [7:0] pixel_x, pixel_y;
    reg [15:0] oled_colour_data = 0;
    
    Clock clk6_25M(.sysclk(sysclk), .compare(7), .out(clock6_25M));
    Oled_Display display_module(
        .clk(clock6_25M),
        .reset(0),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7]),
        .pixel_index(pixel_index),
        .pixel_data(oled_colour_data)
    );
    
    assign pixel_x = pixel_index % 96;
    assign pixel_y = pixel_index / 96;
    
    // Mouse
    wire left, middle, right;
    wire [11:0] mouse_x, mouse_y;
    
    MouseCtl mouse_module(
        .clk(sysclk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .rst(0),
        .setx(0),
        .sety(0),
        .value(0),
        .setmax_x(0),
        .setmax_y(0),
        .left(left),
        .middle(middle),
        .right(right),
        .xpos(mouse_x),
        .ypos(mouse_y)
    );
    
    // Seven Segment Display
    reg [15:0] sed_digits_in = 0;
    reg [31:0] sed_data = 0;
    wire [31:0] sed_digits_out;
    
    SedDigitConverter sed_digits(.val(sed_digits_in), .digits_out(sed_digits_out));
    SedDisplay sed_module(.clk(sysclk), .val(sed_data), .seg(seg), .an(an));
    
    // Button Debouncer
    wire [4:0] btn_curr, btn_prev;
    
    Debouncer debounce_module(.clk(sysclk), .in(btn), .out_curr(btn_curr), .out_prev(btn_prev));
    
    // Our Modules
    wire [3:0] audio_vol_zh;
    wire [8:0] audio_vol_led;
    ZhongHengAudioIn zh(.clk(clock20k), .audio_in(audio_in_data), .volume(audio_vol_zh), .led_out(audio_vol_led));
    
    wire [15:0] oled_zh;
    ZhongHengOLED zholed (.clk(sysclk), .x(pixel_x), .y(pixel_y), .sw(sw), .colour(oled_zh));
    
    wire [11:0] audio_out_wj;
    WenJunAudioOut wj(.enabled(state == 2), .clk(sysclk), .btnC(btn[4]), .sw(sw[0]), .audio_out(audio_out_wj));
    
    wire [15:0] oled_colour_jz;
    JunZeCursorDisplay jz(.enabled(state == 3), .pixel_x(pixel_x), .pixel_y(pixel_y), .mouse_x(mouse_x), .mouse_y(mouse_y), .middle(middle), .colour(oled_colour_jz));
    
    wire [15:0] oled_colour_moses;
    MosesOledDisplay moses(.clk(sysclk), .x(pixel_x), .y(pixel_y), .sw(sw), .colour(oled_colour_moses));
    
    wire [3:0] value_detected_group;
    wire [15:0] oled_colour_group;
    GroupTask group(.enabled(state == 5), .clk(sysclk), .sw0(sw[0]), .sw15(sw[15]), .pixel_x(pixel_x), .pixel_y(pixel_y), .mouse_x(mouse_x), .mouse_y(mouse_y), .left(left), .val(value_detected_group), .colour(oled_colour_group));
    
    // State Controller
    always @ (posedge clock6_25M) begin
        case (state)
            // Zhong Heng individual task
            4'd1: begin
                led <= audio_vol_led;
                audio_out_data <= 0;
                oled_colour_data <= oled_zh;
                sed_digits_in <= audio_vol_zh;
                sed_data <= {{24{1'b1}}, sed_digits_out[7:0]};
            end
            // Wen Jun individual task
            4'd2: begin
                led <= 0;
                audio_out_data <= audio_out_wj;
                oled_colour_data <= 0;
                sed_digits_in <= {4'h0, audio_out_data};
                sed_data <= sed_digits_out;
            end
            // Jun Ze individual task
            4'd3: begin
                led <= {left, middle, right, 13'b0};
                audio_out_data <= 0;
                oled_colour_data <= oled_colour_jz;
                sed_digits_in <= 16'd100 * mouse_x + mouse_y;
                sed_data <= sed_digits_out;
            end
            // Moses individual task
            4'd4: begin
                led <= 0;
                audio_out_data <= 0;
                oled_colour_data <= oled_colour_moses;
                sed_digits_in <= 0;
                sed_data <= {32{1'b1}};
            end
            // Group task
            4'd5: begin
                led <= {value_detected_group ? 7'b1000000 : 7'b0, audio_vol_led};
                audio_out_data <= 0;
                oled_colour_data <= oled_colour_group;
                sed_digits_in <= 16'd100 * value_detected_group + audio_vol_led;
                sed_data <= {value_detected_group ? {1'b0, sed_digits_out[30:16]} : {16{1'b1}}, {8{1'b1}}, sed_digits_out[7:0]};
            end
            default: begin
                led <= sw;
                audio_out_data <= 0;
                oled_colour_data <= 0;
                sed_digits_in <= {11'h0, btn_curr};
                sed_data <= sed_digits_out;
            end
        endcase
    end
endmodule