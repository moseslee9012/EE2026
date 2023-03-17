`timescale 1ns / 1ps



module test_my_dff();
    reg CLOCK, btnC;
    wire[31:0] out;
    
    my_dff df(CLOCK, btnC, out);
    
    initial begin
        CLOCK = 0;
    end
    
    always begin
        CLOCK = ~CLOCK; #5;
    end
endmodule
