// Component Name   : cordic
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/sqrt_u32/rtl/cordic.v
// Author  : Huhc
// Date    : 2023-12-28 20:54:22
// Abstract: 
module cordic #(
    parameter MODE = "vector",
    parameter ITERATION = 32 
)(
    input [33:0]    ix,
    input [33:0]    iy,
    input [31:0]    iz,

    output [31:0]   ox,
    output [31:0]   oy,
    output [31:0]   oz
);
    //wire [15:0] atan_table[ITERATION-1:0];

    //assign atan_table[0] = 16384;       // (45/180)     * 65536
    //assign atan_table[1] = 9685;        // (26.6/180)   * 65536
    //assign atan_table[2] = 5097;        // (14/180)     * 65536
    //assign atan_table[3] = 2585;        // (7.1/180)    * 65536
    //assign atan_table[4] = 1311;        // (3.6/180)    * 65536
    //assign atan_table[5] = 655;         // (1.8/180)    * 65536
    //assign atan_table[6] = 328;         // (0.9/180)    * 65536
    //assign atan_table[7] = 146;         // (0.4/180)    * 65536
    //assign atan_table[8] = 73;          // (0.2/180)    * 65536
    //assign atan_table[9] = 36;          // (0.1/180)    * 65536

    wire signed [33:0] x       [ITERATION:0];
    wire signed [33:0] y       [ITERATION:0];
    wire               sign    [ITERATION-1:0];
    
    assign x[0] = ix;
    assign y[0] = iy;

    genvar i;
    generate
        for (i=0;i<ITERATION;i=i+1) begin: gen_cordic
            // hyperbolic rorations
            //if(i==4) begin
            //    assign x[i+1] = sign[i-1] ? (x[i] + (y[i]>>>(i+1))) : (x[i] - (y[i]>>>(i+1)));
            //    assign y[i+1] = sign[i-1] ? (y[i] + (x[i]>>>(i+1))) : (y[i] - (x[i]>>>(i+1)));
            //    assign sign[i] = y[i][33];
            //end else 
            begin
                assign x[i+1] = sign[i] ? (x[i] + (y[i]>>>(i+1))) : (x[i] - (y[i]>>>(i+1)));
                assign y[i+1] = sign[i] ? (y[i] + (x[i]>>>(i+1))) : (y[i] - (x[i]>>>(i+1)));
                assign sign[i] = y[i][33]; 
            end
        end
    endgenerate
    
    assign ox = x[ITERATION];
    assign oy = y[ITERATION];

endmodule

