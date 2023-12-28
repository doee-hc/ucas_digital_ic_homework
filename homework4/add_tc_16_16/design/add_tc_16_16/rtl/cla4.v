// Component Name   : cla4
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : homework4/design/rtl/cla4.v
// Author  : Huhc
// Date    : 2023-12-04 17:04:15
// Abstract: 4 bit carry-lookahead adder

module cla4 #(
    parameter COEN = 1
)(
    input   [3  :0]     a,   
    input   [3  :0]     b,   
    input               ci,   
    output  [3  :0]     s,   
    output              po,   
    output              go,   
    output              co   

);
    wire     [3  :0]     p;
    wire     [3  :0]     g;
    wire     [3  :0]     c;

    genvar i;
    generate
        for(i = 0; i < 4; i=i+1) begin: gen_cla4
            assign p[i] = a[i] | b[i];
            assign g[i] = a[i] & b[i];
            assign s[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    assign c[0] = ci;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign po = p[3] & p[2] & p[1] & p[0];
    assign go = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    generate
        if(COEN == 1) begin
            // TODO: '5 input and gate' is not acceptable by backend process
            assign co = go | (po & c[0]);
        end
        else begin
            assign co = 0;
        end
    endgenerate
endmodule

