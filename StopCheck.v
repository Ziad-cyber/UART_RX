module StopCheck (
input  wire Clk,
input  wire Rst,
input  wire sampled_bit,
input  wire stp_chk_en,
output reg stp_err
);

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            stp_err <= 1'b0;
        else if (stp_chk_en)
            begin
                if (sampled_bit == 1'b0)
                    stp_err <= 1'b1;
                else 
                    stp_err <= 1'b0;
            end
        else 
            stp_err <= 1'b0;
    end

endmodule