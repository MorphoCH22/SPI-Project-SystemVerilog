module TopSPI(
        input clk,
        input reset,
        input transPulse,
        input [3:0] selIn,
        
        input [7:0] mDataIn,
        input [3:0][7:0] sDataIn,
        
        output [7:0] mDataOut,
        output [3:0][7:0] sDataOut
    );
    
    logic [3:0] MISO;
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
                        .dataIn(sDataIn[0]),
                        .selIn(sel[0]),
                        .data(sDataOut[0]),
                        .MISO(MISO[0]),
                        .MOSI(MOSI)
                        );
                        
    SlaveSPI slave2     (
                        .clkIn(clkOut),
                        .reset(reset),
                        .dataIn(sDataIn[1]),
                        .selIn(sel[1]),
                        .data(sDataOut[1]),
                        .MISO(MISO[1]),
                        .MOSI(MOSI)
                        );
                        
    SlaveSPI slave3     (
                        .clkIn(clkOut),
                        .reset(reset),
                        .dataIn(sDataIn[2]),
                        .selIn(sel[2]),
                        .data(sDataOut[2]),
                        .MISO(MISO[2]),
                        .MOSI(MOSI)
                        );
                        
    SlaveSPI slave4     (
                        .clkIn(clkOut),
                        .reset(reset),
                        .dataIn(sDataIn[3]),
                        .selIn(sel[3]),
                        .data(sDataOut[3]),
                        .MISO(MISO[3]),
                        .MOSI(MOSI)
                        );
    
endmodule
