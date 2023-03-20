`timescale 1ns / 1ps

module GroupTask(
    input enabled,               // Whether the module is enabled
    input clk,                   // 100MHz clock
    input sw0,
    input sw15,
    input [7:0] pixel_x,         // The x position of the current pixel being coloured
    input [7:0] pixel_y,         // The y position of the current pixel being coloured
    input [11:0] mouse_x,        // The x position of the mouse
    input [11:0] mouse_y,        // The y position of the mouse
    input left,                  // Whether left click is pressed
    output reg [3:0] val = 0,    // Digits to display on the seven segment display
    output reg [15:0] colour = 0 // Colour of this pixel, based on whether the switch is toggled
    );
    
    wire cursor_enabled;
    reg left_prev = 0, sw15_prev = 0;
    reg [1:0] coloured = 0;
    reg [6:0] rectangle_enabled = 0;
    
    Cursor cursor(.pixel_x(pixel_x), .pixel_y(pixel_y), .mouse_x(mouse_x), .mouse_y(mouse_y), .radius(2'h1), .enabled(cursor_enabled));
    
    always @ (posedge clk) begin
        if (left & ~left_prev & enabled) begin
            if (mouse_x >= 21 & mouse_x <= 37) begin
                if (mouse_y >= 5 & mouse_y <= 9)
                    rectangle_enabled[0] <= ~rectangle_enabled[0];
                else if (mouse_y >= 27 & mouse_y <= 31)
                    rectangle_enabled[6] <= ~rectangle_enabled[6];
                else if (mouse_y >= 49 & mouse_y <= 53)
                    rectangle_enabled[3] <= ~rectangle_enabled[3];
            end else if (mouse_x >= 16 & mouse_x <= 20) begin
                if (mouse_y >= 10 & mouse_y <= 26)
                    rectangle_enabled[5] <= ~rectangle_enabled[5];
                else if (mouse_y >= 32 & mouse_y <= 48)
                    rectangle_enabled[4] <= ~rectangle_enabled[4];
            end else if (mouse_x >= 38 & mouse_x <= 42) begin
                if (mouse_y >= 10 & mouse_y <= 26)
                    rectangle_enabled[1] <= ~rectangle_enabled[1];
                else if (mouse_y >= 32 & mouse_y <= 48)
                    rectangle_enabled[2] <= ~rectangle_enabled[2];
            end
        end
        
        if (pixel_x >= 21 & pixel_x <= 37) begin
            if (pixel_y >= 5 & pixel_y <= 9)
                coloured[0] <= rectangle_enabled[0] | pixel_x == 21 | pixel_x == 37 | pixel_y == 5 | pixel_y == 9;
            else if (pixel_y >= 27 & pixel_y <= 31)
                coloured[0] <= rectangle_enabled[6] | pixel_x == 21 | pixel_x == 37 | pixel_y == 27 | pixel_y == 31;
            else if (pixel_y >= 49 & pixel_y <= 53)
                coloured[0] <= rectangle_enabled[3] | pixel_x == 21 | pixel_x == 37 | pixel_y == 49 | pixel_y == 53;
            else
                coloured[0] <= 0;
        end else if (pixel_x >= 16 & pixel_x <= 20) begin
            if (pixel_y >= 10 & pixel_y <= 26)
                coloured[0] <= rectangle_enabled[5] | pixel_x == 16 | pixel_x == 20 | pixel_y == 10 | pixel_y == 26;
            else if (pixel_y >= 32 & pixel_y <= 48)
                coloured[0] <= rectangle_enabled[4] | pixel_x == 16 | pixel_x == 20 | pixel_y == 32 | pixel_y == 48;
            else
                coloured[0] <= 0;
        end else if (pixel_x >= 38 & pixel_x <= 42) begin
            if (pixel_y >= 10 & pixel_y <= 26)
                coloured[0] <= rectangle_enabled[1] | pixel_x == 38 | pixel_x == 42 | pixel_y == 10 | pixel_y == 26;
            else if (pixel_y >= 32 & pixel_y <= 48)
                coloured[0] <= rectangle_enabled[2] | pixel_x == 38 | pixel_x == 42 | pixel_y == 32 | pixel_y == 48;
            else
                coloured[0] <= 0;
        end else begin
            coloured[0] <= 0;
        end
        
        if (sw15 & ~sw15_prev & enabled) begin
            case (rectangle_enabled)
                7'b0111111: val <= 1;  // 0
                7'b0000110: val <= 2;  // 1
                7'b1011011: val <= 3;  // 2
                7'b1001111: val <= 4;  // 3
                7'b1100110: val <= 5;  // 4
                7'b1101101: val <= 6;  // 5
                7'b1111101: val <= 7;  // 6
                7'b0000111: val <= 8;  // 7
                7'b1111111: val <= 9;  // 8
                7'b1101111: val <= 10; // 9
                default: val <= 0;
            endcase
        end else if (sw15_prev & ~sw15) begin
            val <= 0;
            rectangle_enabled <= 0;
        end
        
        coloured[1] <= ~sw0 & ((pixel_x > 57 & pixel_x < 61 & pixel_y < 61) | (pixel_y > 57 & pixel_y < 61 & pixel_x < 61));
        colour <= cursor_enabled ? 16'hF800 : (coloured[0] ? 16'hFFFF : (coloured[1] ? 16'h07E0 : 0));
        left_prev <= left;
        sw15_prev <= sw15;
    end
endmodule
