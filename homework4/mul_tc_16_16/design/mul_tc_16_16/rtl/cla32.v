// Component Name   : cla32
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mul_tc_16_16/rtl/cla32.v
// Author  : Huhc
// Date    : 2023-12-10 09:05:03
// Abstract: 
module cla32(
    input   [31  : 0]   a,
    input   [31  : 0]   b,
    input               ci,
    output  [31  : 0]   s
);
    wire [1:0] c;
    wire [1:0] p;
    wire [1:0] g;

    cla16 #(
        .TYPE("grp_parallel"),
        .COEN(0) 
    )u_cla16_0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .s(s[15:0]),
        .ci(c[0]),
        .po(p[0]),
        .go(g[0])
    );

    cla16 #(
        .TYPE("grp_parallel"),
        .COEN(0) 
    )u_cla16_1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .s(s[31:16]),
        .ci(c[1])
        //.po(p[1]),
        //.go(g[1])
    );
    assign c[0] = ci;
    assign c[1] = g[0] | (p[0] & c[0]);
endmodule

