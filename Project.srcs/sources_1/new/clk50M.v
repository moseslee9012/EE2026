`timescale 1ns / 1ps

module clock(input basys_clock, input [31:0] N, output reg my_clock = 0);
    reg[31:0] count = 0;
    
    always @(posedge basys_clock) begin
        count <= (count >= N) ? 0 : count + 1;
        my_clock <= (count == 0) ? ~my_clock : my_clock;
    end
endmodule
