`timescale 1ns / 1ps

module JunZeCursorDisplay(
    input enabled,        // Whether the module is enabled
    input [7:0] pixel_x,  // The x position of the current pixel being coloured
    input [7:0] pixel_y,  // The y position of the current pixel being coloured
    input [11:0] mouse_x, // The x position of the mouse
    input [11:0] mouse_y, // The y position of the mouse
    input middle,         // Whether middle click is pressed
    output [15:0] colour  // Colour of this pixel, based on the cursor location and state
    );
    
    wire cursor_enabled;
    reg cursor_state = 0;
    
    Cursor cursor(.pixel_x(pixel_x), .pixel_y(pixel_y), .mouse_x(mouse_x), .mouse_y(mouse_y), .radius(cursor_state ? 2'h1 : 2'h0), .enabled(cursor_enabled));
    
    always @ (posedge middle) begin
        if (enabled)
            cursor_state <= ~cursor_state;
    end
    
    assign colour = cursor_enabled ? (cursor_state ? 16'h07E0 : 16'hF800) : 0;
endmodule
