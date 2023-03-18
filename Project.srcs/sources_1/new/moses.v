`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clock,
    input sw4, sw8,
    output my_cs, my_sdin, my_sclk, my_d_cn, my_resn, my_vccen, my_pmoden
    );
    
    
    wire clk_6p25m;
    clock_6p25MHz unit_6p25 (clock, 7, clk_6p25m); 
    
    wire clk_25MHz;
    clock_6p25MHz unit_25M (clock, 2, clk_25MHz);
    
    reg reset = 0;
    wire my_frame_begin, my_sending_pixels, my_sample_pixel;
    wire[31:0] my_pixel_index;
    
    reg[15:0] oled_data;
    
    reg[9:0] x_coord;
    reg[6:0] y_coord;
    

    
    always @ (posedge clk_25MHz)
    begin
        x_coord = (my_pixel_index % 96);
        y_coord = (my_pixel_index / 96);
        
        if (x_coord > 57 && x_coord < 61 && y_coord < 59) //vertical boundary
        begin
            oled_data = 16'h07E0;
        end
                
        else if (x_coord < 59 && y_coord > 57 && y_coord < 61) //horizontal boundary
        begin
            oled_data = 16'h07E0;
        end
               
        else if (sw8 && (       //number 8
        (x_coord < 41 && x_coord > 16 && y_coord < 11 && y_coord > 6)
        || (x_coord < 41 && x_coord > 16 && y_coord < 31 && y_coord > 26)
        || (x_coord < 41 && x_coord > 16 && y_coord < 51 && y_coord > 46)
        || (x_coord < 21 && x_coord > 16 && y_coord < 51 && y_coord > 6)
        || (x_coord < 41 && x_coord > 36 && y_coord < 51 && y_coord > 6))
        ) 
        begin
            oled_data = 16'hFFFF;
        end
        
        else if (sw4 && (       //number 4
        (x_coord < 37 && x_coord > 20 && y_coord < 31 && y_coord > 26)
        || (x_coord < 21 && x_coord > 16 && y_coord < 27 && y_coord > 10)
        || (x_coord < 41 && x_coord > 36 && y_coord < 27 && y_coord > 10)
        || (x_coord < 21 && x_coord > 16 && y_coord < 47 && y_coord > 30))
        )
        begin
           oled_data = 16'hFFFF;
        end
               
        else
        begin
            oled_data = 0;
        end
    end
    
    Oled_Display unit_oled_one (
        .clk(clk_6p25m), .reset(0),
        .frame_begin(my_frame_begin), .sending_pixels(my_sending_pixels), .sample_pixel(my_sample_pixel), .pixel_index(my_pixel_index),
        .pixel_data(oled_data),
        .cs(my_cs), .sdin(my_sdin), .sclk(my_sclk), .d_cn(my_d_cn), .resn(my_resn), .vccen(my_vccen), .pmoden(my_pmoden)
        );


    
    
endmodule
