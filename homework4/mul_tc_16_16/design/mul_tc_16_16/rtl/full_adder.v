// Component Name   : full_adder
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mul_tc_16_16/rtl/full_adder.v
// Author  : Huhc
// Date    : 2023-12-10 00:58:25
// Abstract: 
module full_adder(
    input   a,
    input   b,
    input   c,
    output  s,
    output  co
);
    assign s = a ^ b ^ c;
    assign co = a&b | b&c | a&c;

endmodule

