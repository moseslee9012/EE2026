`timescale 1ns / 1ps

module MosesOledDisplay(
    input clk,               // 100MHz clock
    input [7:0] x,           // The x position of the current pixel being coloured
    input [7:0] y,           // The y position of the current pixel being coloured
    input [15:0] sw,
    output reg [15:0] colour // Colour of this pixel, based on whether the switch is toggled
);

    always @ (posedge clk) begin
        if (~sw[0] & ((x > 57 & x < 61 & y < 61) | (y > 57 & y < 61 & x < 61)))
        begin
            colour <= 16'h07E0;
        end else if (sw[1] & ((x < 41 & x > 36 & y < 27 & y > 10) | (x < 41 & x > 36 & y < 47 & y > 30)))
        begin
            colour <= 16'hFFFF;
        end else if (sw[4] & ((x < 37 & x > 20 & y < 31 & y > 26) | (x < 21 & x > 16 & y < 27 & y > 10) | (x < 41 & x > 36 & y < 27 & y > 10) | (x < 41 & x > 36 & y < 47 & y > 30)))
        begin
            colour <= 16'hFFFF;
        end else if (sw[8] & ((x < 41 & x > 16 & y < 11 & y > 6) | (x < 41 & x > 16 & y < 31 & y > 26) | (x < 41 & x > 16 & y < 51 & y > 46) | (x < 21 & x > 16 & y < 51 & y > 6) | (x < 41 & x > 36 & y < 51 & y > 6)))
        begin
            colour <= 16'hFFFF;
        end else
        begin
            colour <= 0;
        end
    end
    endmodule
