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

module Top_Student (input CLOCK, btnC, sw, output [3:0] JA);
    wj_audio_out wj(CLOCK, btnC, sw, JA);

endmodule