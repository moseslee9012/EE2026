`timescale 1ns / 1ps

module WenJunAudioOut(
    input enabled,          // Whether the module is enabled
    input clk,              // 100MHz clock
    input btnC,             // Button to activate the beep
    input sw,               // Switch to alternate volume/frequency
    output [11:0] audio_out // Audio output data
    );
    
    wire clock190;
    wire [31:0] out;

    my_dff dff1(clk, sw, btnC, out);
    Clock clk190(clk, out, clock190);

    assign audio_out = enabled ? {clock190, sw ? {11{1'b1}} : 11'b0} : 0;
endmodule
