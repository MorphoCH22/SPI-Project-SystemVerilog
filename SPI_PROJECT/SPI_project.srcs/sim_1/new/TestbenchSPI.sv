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

module TestbenchSPI;

bit clk;
bit reset;
bit transPulse;
bit [3:0] selIn;

bit [3:0] dataIn;
bit [3:0] dataOut;


always #10 clk = ~clk;

SPI_IF _interfaceSPI    (   
                            clk, reset, transPulse, selIn,
                            dataIn, dataOut
                        );

TopSPI cut  (
            .mas(_interfaceSPI.master),
            .slv(_interfaceSPI.slave),
            .multiplexer(_interfaceSPI.mux)
            );

initial begin
    clk <= 0;
    reset <= 0;
    repeat (5) @(posedge(clk));
    reset <= 1;
    // First choose slave1
    repeat (5) begin
        selIn <= 4'b1110;
        dataIn <= $urandom_range(15, 0);
        transPulse <= 1'b1;
        repeat (1) @(posedge(clk));
        transPulse <= 1'b0;
        repeat (8) @(posedge(clk));
        // Display master for a few cycles
        selIn <= 4'b0111;
        repeat (8) @(posedge(clk));
    end
    
    // Next choose slave2
    repeat (5) begin
        selIn <= 4'b1101;
        dataIn <= $urandom_range(15, 0);
        transPulse <= 1'b1;
        repeat (1) @(posedge(clk));
        transPulse <= 1'b0;
        repeat (8) @(posedge(clk));
        // Display master for a few cycles
        selIn <= 4'b0111;
        repeat (8) @(posedge(clk));
    end
    
    // Next choose slave3
    repeat (5) begin
        selIn <= 4'b1011;
        dataIn <= $urandom_range(15, 0);
        transPulse <= 1'b1;
        repeat (1) @(posedge(clk));
        transPulse <= 1'b0;
        repeat (8) @(posedge(clk));
        // Display master for a few cycles
        selIn <= 4'b0111;
        repeat (8) @(posedge(clk));
    end
    
    $finish;
end

endmodule
