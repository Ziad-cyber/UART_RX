module UART_RX (
input  wire CLK,
input  wire RST,
input  wire RX_IN,
input  wire PAR_EN, 
input  wire PAR_TYP,
output reg  data_valid,
output reg  [7:0] P_DATA
);

//wire Declaration
wire [2:0] edge_cnt_U;
wire [3:0] bit_cnt_U;
wire stp_err_U;
wire strt_glitch_U;
wire par_err_U;
wire dat_samp_en_U;
wire enable_U;
wire Bit_Rst_U;
wire deser_en_U;
wire stp_chk_en_U;
wire strt_chk_en_U;
wire par_chk_en_U;
wire sampled_bit_U;
wire [7:0] P_data_U;
wire data_valid_U;
//instantiation modules
FSM U0 (
.Clk (CLK),
.Rst (RST), 
.Rx_In(RX_IN),
.edge_cnt(edge_cnt_U),
.bit_cnt(bit_cnt_U),
.stp_err(stp_err_U),
.strt_glitch(strt_glitch_U),
.par_err(par_err_U),
.Par_En(PAR_EN),
.dat_samp_en(dat_samp_en_U),
.enable(enable_U),
.Bit_Rst(Bit_Rst_U),
.deser_en(deser_en_U),
.Data_Valid(data_valid_U),
.stp_chk_en(stp_chk_en_U),
.strt_chk_en(strt_chk_en_U),
.par_chk_en(par_chk_en_U)
);

edge_bit_counter U1 (
.Clk(CLK),
.Rst(RST),  
.enable_E(enable_U),
.Bit_Rst_E(Bit_Rst_U),
.bit_cnt(bit_cnt_U),
.edge_cnt(edge_cnt_U)
);

data_sampling U2 (
.Clk (CLK),
.Rst(RST),
.RX_IN_D(RX_IN),
.data_samp_en(dat_samp_en_U),
.edge_cnt(edge_cnt_U),
.sampled_bit(sampled_bit_U)
);

deserializer U3 (
.Clk (CLK),
.Rst(RST),
.sampled_bit(sampled_bit_U),
.deser_en(deser_en_U),
.P_data(P_data_U)
);

StopCheck U4 (
.Clk(CLK),
.Rst(RST),
.sampled_bit(sampled_bit_U),
.stp_chk_en(stp_chk_en_U),
.stp_err(stp_err_U)
);

StrtCheck U5 (
.Clk(CLK),
.Rst(RST),
.sampled_bit(sampled_bit_U),
.strt_chk_en(strt_chk_en_U),
.strt_glitch(strt_glitch_U)
);

ParityCheck U6 (
.Clk(CLK),
.Rst(RST),
.sampled_bit(sampled_bit_U),
.Data(P_data_U),
.par_chk_en(par_chk_en_U),
.Par_Typ(PAR_TYP),
.par_err(par_err_U)
);

always @ (*)
    begin
        P_DATA = P_data_U;
        data_valid = data_valid_U;
    end

endmodule