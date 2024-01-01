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
    parameter ITERATION = 8 
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input [32:0]    ix,
    input [32:0]    iy,
    input [31:0]    iz,

    output reg      o_en,
    output reg      o_en_pre,       // one cycle ahead o_en
    output [31:0]   ox,
    output [31:0]   oy,
    output [31:0]   oz
);

    localparam ITERATION_WIDTH = $clog2(ITERATION);
    
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

    reg signed [32:0] x     ;       
    reg signed [32:0] y     ;
    wire              sign  ;
    reg         [ITERATION_WIDTH:0] itera;
    reg               en;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            en          <= 1'b0;
            o_en        <= 1'b0;
            o_en_pre    <= 1'b0;
        end
        else begin
            o_en        <= 1'b0;
            o_en_pre    <= 1'b0;
            if(i_en) begin
                en      <= 1'b1;
            end
            else if(en) begin
                if (itera == ITERATION - 1) begin
                    o_en_pre    <= 1'b1;
                end
                if (itera == ITERATION) begin
                    en      <= 1'b0;
                    o_en    <= 1'b1;
                end
            end
        end
    end

    assign sign = y[32];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            itera       <= 0;
        end
        else begin
            if(i_en) begin
                x <= ix - (iy >>> 1);
                y <= iy - (ix >>> 1);
                itera <= 2;
            end
            else if(en) begin
                x <= sign ? (x + (y >>> itera)) : (x - (y >>> itera));
                y <= sign ? (y + (x >>> itera)) : (y - (x >>> itera));
                itera <= itera + 1;
            end
        end
    end
    
    assign ox = x;
    assign oy = y;

endmodule

