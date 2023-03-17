`timescale 1ns / 1ps

module test_top_student();

    reg CLOCK;
    wire[3:0] JDC;
        
    Top_Student ts(CLOCK, JDC);
    
    initial begin
        CLOCK = 0;
    end

    always begin
        #5 CLOCK = ~CLOCK;
    end
    
endmodule
