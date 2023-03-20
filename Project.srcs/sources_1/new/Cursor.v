`timescale 1ns / 1ps

module Cursor(
    input [7:0] pixel_x,  // The x position of the current pixel being coloured
    input [7:0] pixel_y,  // The y position of the current pixel being coloured
    input [11:0] mouse_x, // The x position of the mouse
    input [11:0] mouse_y, // The y position of the mouse
    input [1:0] radius,   // Radius of the cursor, which is a square. The result is a square with length (2 * radius + 1)
    output enabled        // Whether this pixel should be coloured, depending on whether it is within the cursor radius
    );
    
    // Conversion to signed is needed because when pixel_x is unsigned 0 and radius > 0, (pixel_x - radius) underflows
    assign enabled = $signed(pixel_x - radius) <= $signed(mouse_x)
                     & mouse_x <= pixel_x + radius
                     & $signed(pixel_y - radius) <= $signed(mouse_y)
                     & mouse_y <= pixel_y + radius;
endmodule
