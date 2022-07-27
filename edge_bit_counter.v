module edge_bit_counter (
input  wire Clk,
input  wire Rst,  
input  wire enable_E,
input  wire Bit_Rst_E,
output reg  [3:0]  bit_cnt,
output reg  [2:0]  edge_cnt
);
 
reg  [3:0]  bit_counter;
reg  [2:0]  edge_counter;

always @ (posedge Clk or negedge Rst )
    begin
        if (!Rst)
            begin
               edge_counter <= 3'd0; 
               bit_counter  <= 4'd0;
            end
        else if (enable_E == 1'b0 && Bit_Rst_E == 1'b1 )
            bit_counter <= 1'b0;
        else if (enable_E == 1'b1 && Bit_Rst_E == 1'b0)
            begin
                if (edge_counter == 3'd6)
                    begin
                        bit_counter <= bit_counter + 1'b1; 
                        edge_counter <= edge_counter + 1'b1;         
                    end
                else if (edge_counter == 3'd7)
                    edge_counter <= 3'd0;
                else
                    edge_counter <= edge_counter + 1'b1;
            end 
        else if (enable_E == 1'b1 && Bit_Rst_E == 1'b1)
            begin
                bit_counter <= 1'b0;
                edge_counter <= edge_counter + 1'b1;
            end
    end

always @ (*)
    begin
        bit_cnt  =bit_counter;
        edge_cnt =edge_counter;
    end

endmodule 
