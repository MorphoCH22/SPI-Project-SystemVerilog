interface SPI_EXT(  input clk, reset, transPulse, pushMas, pushSlv,
                    input [3:0] selInSlv,
                    input [1:0] selInReg,
                    input [7:0] dataIn,
                    output [7:0] mDataOut,
                    output [7:0] sDataOut
                 );
                 
    logic [3:0] slvToPush;
    
    logic [7:0] mDataIn;
    logic [3:0][7:0] sDataIn;
    logic [3:0][7:0] sData;
    
    SPI_IF spi (clk, reset, transPulse, selInSlv, mDataIn, sDataIn, mDataOut, sData);
    
    
    modport decoder (input selInReg, output slvToPush);
    modport mux     (input selInReg, sData, output sDataOut); 
    
    modport masterReg   (input clk, reset, pushMas, dataIn, output mDataIn);
    modport slaveReg   (input clk, reset, pushSlv, slvToPush, dataIn, output sDataIn);

    clocking ck2 @ (posedge clk);
        output #1ns transPulse, selInSlv, selInReg, dataIn, pushMas, pushSlv;
        input #1ns mDataOut, sDataOut;
    endclocking

endinterface

module TopSPI2(
        SPI_EXT SPItopIF, 
        SPI_EXT.decoder decod,
        SPI_EXT.mux mux,
        SPI_EXT.masterReg masterReg,
        SPI_EXT.slaveReg slaveReg
    );
    
    TopSPI spi (SPItopIF.spi.master, SPItopIF.spi.slave);
    
    decoder2to4 decoder     (
                            .selectIn(decod.selInReg),
                            .selectOut(decod.slvToPush)
                            );
    
    mux4to1 mul (
                .sel(mux.selInReg),
                .dataIn(mux.sData),
                .dataOut(mux.sDataOut)
                );
    
    register8bit masReg  (
                            .clk(masterReg.clk),
                            .reset(masterReg.reset),
                            .push(masterReg.pushMas),
                            .sel(masterReg.pushMas),
                            .D(masterReg.dataIn),
                            .Q(masterReg.mDataIn)
                            );
                            
    register8bit slave1Reg  (
                            .clk(slaveReg.clk),
                            .reset(slaveReg.reset),
                            .push(slaveReg.pushSlv),
                            .sel(slaveReg.slvToPush[0]),
                            .D(slaveReg.dataIn),
                            .Q(slaveReg.sDataIn[0])
                            );
                            
    register8bit slave2Reg  (
                            .clk(slaveReg.clk),
                            .reset(slaveReg.reset),
                            .push(slaveReg.pushSlv),
                            .sel(slaveReg.slvToPush[1]),
                            .D(slaveReg.dataIn),
                            .Q(slaveReg.sDataIn[1])
                            );
                            
    register8bit slave3Reg  (
                            .clk(slaveReg.clk),
                            .reset(slaveReg.reset),
                            .push(slaveReg.pushSlv),
                            .sel(slaveReg.slvToPush[2]),
                            .D(slaveReg.dataIn),
                            .Q(slaveReg.sDataIn[2])
                            );
                            
    register8bit slave4Reg  (
                            .clk(slaveReg.clk),
                            .reset(slaveReg.reset),
                            .push(slaveReg.pushSlv),
                            .sel(slaveReg.slvToPush[3]),
                            .D(slaveReg.dataIn),
                            .Q(slaveReg.sDataIn[3])
                            );
    
endmodule
