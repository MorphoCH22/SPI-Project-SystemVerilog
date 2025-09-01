interface SPI_IF (  input clk, reset, transPulse,
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
    
    modport master  (input clk, reset, transPulse, selIn, mDataIn, MISO,
                    output MOSI, clkOut, sel, mDataOut);
    modport slave   (input clkOut, MOSI, sel, reset, sDataIn, 
                    output sDataOut, MISO );
    
    clocking ck1 @ (posedge clk);
        output #1ns transPulse, selIn, mDataIn, sDataIn;
        input #1ns mDataOut, sDataOut;
    endclocking
endinterface

module TopSPI(
        SPI_IF.master mas,
        SPI_IF.slave slv
    );
    
    MasterSPI master    (
                        .clkIn(mas.clk),
                        .reset(mas.reset),
                        .dataIn(mas.mDataIn),
                        .selIn(mas.selIn),
                        .transPulse(mas.transPulse),
                        .data(mas.mDataOut),
                        .MISO(mas.MISO),
                        .clkOut(mas.clkOut),
                        .MOSI(mas.MOSI),
                        .selOut(mas.sel)
                        );
                        
    SlaveSPI slave1     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .dataIn(slv.sDataIn[0]),
                        .selIn(slv.sel[0]),
                        .data(slv.sDataOut[0]),
                        .MISO(slv.MISO[0]),
                        .MOSI(slv.MOSI)
                        );
                        
    SlaveSPI slave2     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .dataIn(slv.sDataIn[1]),
                        .selIn(slv.sel[1]),
                        .data(slv.sDataOut[1]),
                        .MISO(slv.MISO[1]),
                        .MOSI(slv.MOSI)
                        );
    
    SlaveSPI slave3     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .dataIn(slv.sDataIn[2]),
                        .selIn(slv.sel[2]),
                        .data(slv.sDataOut[2]),
                        .MISO(slv.MISO[2]),
                        .MOSI(slv.MOSI)
                        );
    
    SlaveSPI slave4     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .dataIn(slv.sDataIn[3]),
                        .selIn(slv.sel[3]),
                        .data(slv.sDataOut[3]),
                        .MISO(slv.MISO[3]),
                        .MOSI(slv.MOSI)
                        );
    
endmodule
