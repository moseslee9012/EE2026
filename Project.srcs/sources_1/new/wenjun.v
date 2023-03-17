`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2023 10:56:18
// Design Name: 
// Module Name: wj_audio_out
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wj_audio_out(input CLOCK, btnC, sw, output [3:0] JA);
    
    wire clock50m, clock20k, filtered, clock190;
    wire[31:0] out;

    my_dff(CLOCK, sw, btnC, out);
    clock clk190(CLOCK, out, clock190);
    clock clk50M(CLOCK, 1, clock50m);
    clock clk20k(CLOCK, 2_499, clock20k);
    reg[10:0] volume = sw ? {11{1'b1}} : 0;

    Audio_Output audio_out(
        .CLK(clock50m),
        .DATA1({clock190, volume}),
        .START(clock20k),
        .RST(0),
        .D1(JA[1]),
        .D2(JA[2]),
        .CLK_OUT(JA[3]),
        .nSYNC(JA[0])
    );
endmodule
