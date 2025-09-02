interface SPI_IF (  input clk, reset, transPulse,
                    input [3:0] selIn,
                    input [3:0] dataIn,
                    output [3:0] dataOut
                 );
                 
    logic [3:0][3:0] muxData;
                 
    logic [2:0] MISO;
    logic clkOut;
    logic MOSI;
    logic [3:0] sel;
    
    modport mux (input muxData, selIn, output dataOut);
    
    modport master  (input clk, reset, transPulse, selIn, dataIn, MISO,
                    output MOSI, clkOut, sel, muxData);
    modport slave   (input clkOut, MOSI, sel, reset, 
                    output muxData, MISO );
    
    clocking ck1 @ (posedge clk);
        output #1ns reset, transPulse, selIn, dataIn;
        input #1ns dataOut;
    endclocking
endinterface

module TopSPI(
        SPI_IF.master mas,
        SPI_IF.slave slv,
        
        SPI_IF.mux multiplexer
    );
    
    MasterSPI master    (
                        .clkIn(mas.clk),
                        .reset(mas.reset),
                        .dataIn(mas.dataIn),
                        .selIn(mas.selIn),
                        .transPulse(mas.transPulse),
                        .data(mas.muxData[3]),
                        .MISO(mas.MISO),
                        .clkOut(mas.clkOut),
                        .MOSI(mas.MOSI),
                        .selOut(mas.sel)
                        );
                        
    SlaveSPI slave1     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .selIn(slv.sel[0]),
                        .data(slv.muxData[0]),
                        .MISO(slv.MISO[0]),
                        .MOSI(slv.MOSI)
                        );
                        
    SlaveSPI slave2     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .selIn(slv.sel[1]),
                        .data(slv.muxData[1]),
                        .MISO(slv.MISO[1]),
                        .MOSI(slv.MOSI)
                        );
                        
    SlaveSPI slave3     (
                        .clkIn(slv.clkOut),
                        .reset(slv.reset),
                        .selIn(slv.sel[2]),
                        .data(slv.muxData[2]),
                        .MISO(slv.MISO[2]),
                        .MOSI(slv.MOSI)
                        );
                    
    mux4to1 mux (
                .dataIn(multiplexer.muxData),
                .sel(multiplexer.selIn),
                .dataOut(multiplexer.dataOut)
                );
    
endmodule
