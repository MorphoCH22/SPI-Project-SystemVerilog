interface SPI_IF (  input clk, reset, transPulse, 
                    input [3:0] selIn,
                    input [7:0] mDataIn,
                    input [2:0][7:0] sDataIn,
                    output [7:0] mDataOut,
                    output [2:0][7:0] sDataOut
                 );
                 
    logic [2:0] MISO;
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

module TestbenchSPI;

bit clk;
bit reset;
bit transPulse;
bit [3:0] selIn;

bit [7:0] mDataIn;
bit [2:0][7:0] sDataIn;
        
bit [7:0] mDataOut;
bit [2:0][7:0] sDataOut;


always #10 clk = ~clk;

SPI_IF _interfaceSPI    (   
                            clk, reset, transPulse, selIn,
                            mDataIn, sDataIn, mDataOut, sDataOut
                        );

TopSPI cut  (
            .mas(_interfaceSPI.master),
            .slv(_interfaceSPI.slave)
            );

initial begin
    clk <= 0;
    reset <= 0;
    repeat (5) @(posedge(clk))
    reset <= 1;
    // First choose slave1
    selIn <= 4'b1110;
    repeat (5) begin
        mDataIn <= $urandom_range(255, 0);
        sDataIn[0] <= $urandom_range(255, 0);
        transPulse <= 1'b1;
        repeat (11) @(posedge(clk))
        transPulse <= 1'b0;
    end
    
    // Next choose slave2
    selIn <= 4'b1101;
    repeat (5) begin
        mDataIn <= $urandom_range(255, 0);
        sDataIn[1] <= $urandom_range(255, 0);
        transPulse <= 1'b1;
        repeat (11) @(posedge(clk))
        transPulse <= 1'b0;
    end
    
    // Next choose slave3
    selIn <= 4'b1011;
    repeat (5) begin
        mDataIn <= $urandom_range(255, 0);
        sDataIn[2] <= $urandom_range(255, 0);
        transPulse <= 1'b1;
        repeat (11) @(posedge(clk))
        transPulse <= 1'b0;
    end
    
    $finish;
end

endmodule
