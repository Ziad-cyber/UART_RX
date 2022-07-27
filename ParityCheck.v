module ParityCheck (
input  wire Clk,
input  wire Rst,
input  wire sampled_bit,
input  wire [7:0] Data,
input  wire par_chk_en,
input  wire Par_Typ,
output reg  par_err
);

reg even_parity;
reg odd_parity;

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            par_err <= 1'b0;
        else if (par_chk_en)
            begin
                if (Par_Typ)
                    begin
                        if (odd_parity == sampled_bit)
                            par_err <= 1'b0;
                        else 
                            par_err <= 1'b1;
                    end
                else 
                    begin
                        if (even_parity == sampled_bit)
                            par_err <= 1'b0;
                        else
                            par_err <= 1'b1;
                    end
            end
        else 
            par_err <= 1'b0;
    end
always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            begin
                even_parity <= 1'b0;
                odd_parity <= 1'b0;
            end
        else 
            begin
                even_parity <= (^Data);
                odd_parity <= ~(^Data);
            end
    end
endmodule