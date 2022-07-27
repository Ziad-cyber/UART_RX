module StrtCheck (
input  wire Clk,
input  wire Rst,
input  wire sampled_bit,
input  wire strt_chk_en,
output reg  strt_glitch
);

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            strt_glitch <= 1'b0;
        else if (strt_chk_en)
            begin
                if (sampled_bit == 1'b0)
                    strt_glitch <= 1'b1;
                else 
                    strt_glitch <= 1'b0;
            end
        else 
            strt_glitch <= 1'b0;
    end

endmodule