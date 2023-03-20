`timescale 1ns / 1ps

module ZhongHengAudioIn(
    input clk,                   // 20kHz clock
    input [11:0] audio_in,       // Audio input data
    output reg [3:0] volume = 0, // Loudness of audio input, from 0 to 9
    output reg [8:0] led_out = 0 // {volume{1'b1}}, for the LED
    );
    
    reg [11:0] count = 0, peak = 2, peak_out = 0;
    
    always @ (posedge clk) begin
        count <= (count == 4000) ? 0 : count + 1 ; 
        peak_out <= (count == 0) ? peak : peak_out;
        peak <= (count == 1) ? 0 : peak;

        if (audio_in > peak) begin
            peak <= audio_in;
        end
        
        if (peak_out <= 2048) begin
            volume <= 0;
            led_out <= 0;
        end else if (peak_out <= 2104) begin
            volume <= 1;
            led_out <= 1;
        end else if (peak_out <= 2260) begin
            volume <= 2;
            led_out <= {2{1'b1}};
        end else if (peak_out <= 2416) begin
            volume <= 3;
            led_out <= {3{1'b1}};
        end else if (peak_out <= 2672) begin
            volume <= 4;
            led_out <= {4{1'b1}};
        end else if (peak_out <= 2828) begin
            volume <= 5;
            led_out <= {5{1'b1}};
        end else if (peak_out <= 3084) begin
            volume <= 6;
            led_out <= {6{1'b1}};
        end else if (peak_out <= 3240) begin
            volume <= 7;
            led_out <= {7{1'b1}};
        end else begin
            volume <= 8;
            led_out <= {8{1'b1}};
        end
    end
endmodule
