//    This is testbench for UART Module
`timescale 1 ns/1 ps
//TB has neither inputs nor outputs
module UART_RX_TB ();

reg     CLK_TB;
reg     RST_TB;
reg     RX_IN_TB;
reg     PAR_EN_TB;
reg     PAR_TYP_TB;
wire    data_valid_TB;
wire    [7:0] P_DATA_TB;

/////////////// Clk Generator ///////////////
localparam Period = 125;
always #(Period/2) CLK_TB = ~CLK_TB;     // Clk Frequency 8 MHz

/////////////// Initial BLock ///////////////
initial 
    begin
        // Save Waveform
        $dumpfile("Timer.vcd") ;
        $dumpvars; 
        Initialization ();
        Reset ();
        #62.5
        #250
        Trial (1'b0); //start
        #1000
        Trial (1'b1); //data
        #1000
        Trial (1'b0);
        #1000
        Trial (1'b1);
        #1000
        Trial (1'b0);
        #1000
        Trial (1'b1);
        #1000
        Trial (1'b0);
        #1000
        Trial (1'b1);
        #1000
        Trial (1'b0);
        #1000
        Trial (1'b0); //even parity
        #1000
        Trial (1'b1); //stop
        #2000
        $stop;
    end

/////////////// Reset BLock ///////////////
task Reset;
    begin
        RST_TB=1'b1;
        #20
        RST_TB=1'b0;
        #42.5
        RST_TB=1'b1;
    end
endtask

/////////////// Initialization BLock ///////////////
task Initialization;
    begin
        CLK_TB=1'b1;
        RX_IN_TB=1'b1;
        PAR_EN_TB=1'b1;
        PAR_TYP_TB=1'b0;  //even parity
    end
endtask

/////////////// Trial BLock ///////////////
task Trial (input value);
    begin
        RX_IN_TB = value;
    end
endtask

/////////////// Module instantiation ///////////////
UART_RX U1 (
.CLK(CLK_TB ),
.RST(RST_TB),
.RX_IN(RX_IN_TB),
.PAR_EN(PAR_EN_TB), 
.PAR_TYP(PAR_TYP_TB),
.data_valid(data_valid_TB),
.P_DATA(P_DATA_TB)
);

endmodule