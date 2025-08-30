module TopSPI(
        input clk,
        input reset,
        input transPulse,
        input [3:0] selIn,
        
        input [7:0] mDataIn,
        input [7:0] s1DataIn,
        
        output [7:0] mDataOut,
        output [7:0] s1DataOut
    );
    
    logic MISO;
    logic clkOut;
    logic MOSI;
    logic [3:0] sel;
    
    MasterSPI master    (
                        .clkIn(clk),
                        .reset(reset),
                        .dataIn(mDataIn),
                        .selIn(selIn),
                        .transPulse(transPulse),
                        .data(mDataOut),
                        .MISO(MISO),
                        .clkOut(clkOut),
                        .MOSI(MOSI),
                        .selOut(sel)
                        );
                        
    SlaveSPI slave1     (
                        .clkIn(clkOut),
                        .reset(reset),
                        .dataIn(s1DataIn),
                        .selIn(sel[0]),
                        .data(s1DataOut),
                        .MISO(MISO),
                        .MOSI(MOSI)
                        );
    
endmodule
