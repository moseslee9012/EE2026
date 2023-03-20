`timescale 1ns / 1ps

module sim(
    );
    
    reg sysclk = 0;
    reg [4:0] btn = 0;
    reg [15:0] sw = 0;
    wire [3:0] an;
    wire [7:0] seg;
    wire [15:0] led;
    wire [3:0] JA;
    wire [7:0] JC;
    wire ps2_clk;
    wire ps2_data;
    
    MainController test(sysclk, btn, sw, an, seg, led, JA, JC, ps2_clk, ps2_data);
    
    always begin
        #5 sysclk = ~sysclk;
    end
    
    initial begin
        #500 sw[11] = 1;
    end
endmodule
