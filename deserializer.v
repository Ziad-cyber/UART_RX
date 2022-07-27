module deserializer (
input  wire Clk,
input  wire Rst,
input  wire sampled_bit,
input  wire deser_en,
output reg  [7:0] P_data
);

reg [7:0] Shift_Register;
integer i;

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            begin
                Shift_Register <= 8'd0;
            end
        else if (deser_en)
            begin
                Shift_Register [7] <= sampled_bit;
                for (i =7 ; i>0 ; i=i-1 )
                   Shift_Register [i-1] <= Shift_Register [i] ;
            end
        else 
            begin
                Shift_Register <= Shift_Register;
            end
    end

always @ (*)
    begin
        P_data = Shift_Register;
    end

endmodule