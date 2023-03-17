`timescale 1ns / 1ps

module my_dff(
    input basys_clock,
    sw,
    btnC, 
    output reg [31:0] filtered = 0
);
    reg isHigh = 0, isBlocked = 0;
    reg[31:0] counter = 0, one_sec_clock = 100_000_000;
    parameter ten_ms = 100_000, one_sec = 100_000_000;

    always @(posedge basys_clock) begin
        if (!isBlocked) begin
            // Blocking Logic
            if ((btnC && !isHigh) || (!btnC && isHigh)) begin
                isBlocked <= 1;
                isHigh <= btnC;
            end
            
            // Clock Logic
            if (btnC && !isHigh) one_sec_clock <= 0;    
            else one_sec_clock <= (one_sec_clock == one_sec) ? one_sec : one_sec_clock + 1;
        end else begin
            counter <= (counter == ten_ms) ? 0 : counter + 1;
            isBlocked <= (counter == 0) ? 0 : 1;
            one_sec_clock <= (one_sec_clock == one_sec) ? one_sec : one_sec_clock + 1;
        end
        filtered <= (one_sec_clock != one_sec) ? (sw ? 357_142 : 178_571) : 0;
    end
endmodule