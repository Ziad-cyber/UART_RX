module FSM (
input  wire Clk,
input  wire Rst, 
input  wire Rx_In,
input  wire [2:0] edge_cnt,
input  wire [3:0] bit_cnt,
input  wire stp_err,
input  wire strt_glitch,
input  wire par_err,
input  wire Par_En,
output reg  dat_samp_en,
output reg  enable,
output reg  Bit_Rst,
output reg  deser_en,
output reg  Data_Valid,
output reg  stp_chk_en,
output reg  strt_chk_en,
output reg  par_chk_en
);

localparam IDLE       = 3'b000;
localparam Start      = 3'b001;
localparam Data       = 3'b010;
localparam Parity     = 3'b011;
localparam Stop       = 3'b100;
localparam Valid_Data = 3'b101;

reg [2:0] state , next_state;

always @ (posedge Clk or negedge Rst)
    begin
        if (!Rst)
            state <= IDLE;
        else 
            state <= next_state;
    end 

always @ (*)
    begin
        case (state)    
            IDLE  :     begin
                            if (Rx_In == 0)
                                next_state = Start;
                            else 
                                next_state = IDLE;
                        end
            Start  :    begin
                            if (strt_glitch == 1'b0 && edge_cnt==3'd7)
                                next_state = Data;
                            else if (strt_glitch == 1'b1 && edge_cnt==3'd7)
                                next_state = IDLE;
                            else 
                                next_state = Start;
                        end
            Data   :    begin
                            if (bit_cnt == 4'd9 && Par_En ==0)
                                next_state = Stop;
                            else if (bit_cnt == 4'd9 && Par_En ==1)
                                next_state = Parity;
                            else 
                                next_state = Data;
                        end
            Parity :    begin
                            if (par_err == 1'b0 && edge_cnt==3'd7)
                                next_state = Stop;
                            else if (par_err == 1'b1 && edge_cnt==3'd7)
                                next_state = IDLE;
                            else 
                                next_state = Parity;
                        end
            Stop   :    begin
                            if (stp_err == 1'b0 && edge_cnt==3'd7)
                                next_state = Valid_Data;
                            else if (stp_err == 1'b1 && edge_cnt==3'd7)
                                next_state = IDLE;
                            else 
                                next_state = Stop;
                        end
            Valid_Data:begin
                            if (Rx_In == 1'b0)
                                next_state = Start ;
                            else 
                                next_state = IDLE;
                       end
            default:begin
                            next_state = IDLE;
                    end
        endcase
    end

always @ (*)
    begin
        dat_samp_en = 1'b0;
        enable      = 1'b0;
        Bit_Rst     = 1'b0;
        deser_en    = 1'b0;
        Data_Valid  = 1'b0;
        stp_chk_en  = 1'b0;
        strt_chk_en = 1'b0;
        par_chk_en  = 1'b0;
        case (state)
            IDLE :      begin
                            if (Rx_In == 0)
                                begin
                                    dat_samp_en = 1'b1;
                                    enable      = 1'b1;  
                                    Bit_Rst     = 1'b1;
                                end
                            else
                                begin
                                    dat_samp_en = 1'b0;
                                    enable      = 1'b0;  
                                    Bit_Rst     = 1'b1;
                                end
                        end
            Start  :    begin
                            dat_samp_en = 1'b1;
                            enable      = 1'b1;
                            Bit_Rst     = 1'b0;
                            if (edge_cnt == 3'd5 )
                                strt_chk_en = 1'b1 ;
                            else 
                                strt_chk_en = 1'b0 ;
                        end
            Data   :    begin
                            dat_samp_en = 1'b1;
                            enable      = 1'b1;
                            if (edge_cnt == 3'd6 )
                                deser_en = 1'b1 ;
                            else 
                                deser_en = 1'b0 ;
                        end
            Parity :    begin
                            dat_samp_en = 1'b1;
                            enable      = 1'b1;
                            if (edge_cnt == 3'd5 )
                                par_chk_en  = 1'b1 ;
                            else 
                                par_chk_en  = 1'b0 ;
                        end
            Stop   :    begin
                            dat_samp_en = 1'b1;
                            enable      = 1'b1;
                            if (edge_cnt == 3'd5 )
                                stp_chk_en  = 1'b1 ;
                            else 
                                stp_chk_en  = 1'b0 ;
                        end
            Valid_Data: begin
                            dat_samp_en = 1'b0;
                            Data_Valid  = 1'b1;
                            if (Rx_In == 1'b0)
                                begin
                                    enable      = 1'b1;
                                    Bit_Rst     = 1'b1;
                                end
                            else
                                begin
                                    enable      = 1'b0;
                                    Bit_Rst     = 1'b1;
                                end
                        end
            default   : begin
                            dat_samp_en = 1'b0;
                            enable      = 1'b0;
                            deser_en    = 1'b0;
                            Data_Valid  = 1'b0;
                            stp_chk_en  = 1'b0;
                            strt_chk_en = 1'b0;
                            par_chk_en  = 1'b0;
                        end
        endcase  
    end

endmodule