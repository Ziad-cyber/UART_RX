module data_sampling (
input  wire Clk,
input  wire Rst,
input  wire RX_IN_D,
input  wire data_samp_en,
input  wire [2:0] edge_cnt,
output reg  sampled_bit
);

reg [1:0] sampled;

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            begin
                sampled <= 2'b0;
                sampled_bit <= 1'b0;
            end
        else if (data_samp_en) 
            begin
                case (edge_cnt) 
                    3'd3    :   begin
                                    sampled[0]  <= RX_IN_D;
                                    sampled[1]  <= sampled[1];
                                    sampled_bit <= 1'b0;
                                end
                    3'd4    :   begin
                                    sampled[0]  <= sampled[0];
                                    sampled[1]  <= RX_IN_D;
                                    sampled_bit <= 1'b0;
                                end
                    3'd5    :   begin
                                    sampled[0]  <= sampled[0];
                                    sampled[1]  <= sampled[1];
                                    sampled_bit <= (RX_IN_D & sampled[0]) | (sampled[1] & sampled[0]) | (RX_IN_D & sampled[1]);
                                end
                    default : begin
                                    sampled[0]  <= 1'b0;
                                    sampled[1]  <= 1'b0;
                                    sampled_bit <= 1'b0;
                                end 
                endcase
            end
            else
                begin
                    sampled <= 2'b0;
                    sampled_bit <= 1'b0;                    
                end
    end

endmodule