// Component Name   : booth2
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mul_tc_16_16/rtl/booth2.v
// Author  : Huhc
// Date    : 2023-12-10 01:36:37
// Abstract: 
module booth2(
    input   [2 :0]  y,
    input   [16:0]  x,

    output  reg [16:0]  xo,
    output  reg         co
);

    always @(*) begin
        case(y) 
            3'b000,3'b111: begin
                xo = 0;
                co = 0;
            end
            3'b001,3'b010: begin
                xo = x;
                co = 0;
            end
            3'b011: begin
                xo = (x<<1);
                co = 0;
            end
            3'b100: begin
                xo = (x<<1);
                co = 1;
            end
            3'b101,3'b110: begin
                xo = (x);
                co = 1;
            end
        endcase
    end
endmodule

