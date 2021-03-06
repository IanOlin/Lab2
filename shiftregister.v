//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output reg serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;
    initial shiftregistermem  = 8'd0;
    initial parallelDataOut  = 8'd0;
    initial serialDataOut  = 0;
    always @(posedge clk) begin

        parallelDataOut <= shiftregistermem;
        serialDataOut <= shiftregistermem[width-1];

        if ( parallelLoad == 1 ) begin
            shiftregistermem <= parallelDataIn;
        end else begin
            if (peripheralClkEdge == 1) begin
                shiftregistermem <= shiftregistermem << 1;
                shiftregistermem[0] <= serialDataIn;
            end
        end

    end

    /*
    always @(posedge peripheralClkEdge) begin
    end
    */
endmodule
