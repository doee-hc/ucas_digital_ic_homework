// Component Name   : add_tc_16_16
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : homework4/design/rtl/add_tc_16_16.v
// Author  : Huhc
// Date    : 2023-12-04 21:30:56
// Abstract:    16 bit carry-lookahead adder.
//              carry method can be configured to two type by using perameter 'TYPE'.
//              TYPE="grp_parallel" means using parallel carry between each group which has better timing but more costly.
//              TYPE=other means using serial carry between each group.

module add_tc_16_16 #(
    parameter TYPE  = "grp_parallel"
)(
    //Inputs
    input   [15  : 0]   a,
    input   [15  : 0]   b,

    //Outputs
    output  [16  : 0]   sum
);
    wire [15: 0]  s;
    wire [4 : 0]  c;
    wire [3 : 0]  p;
    wire [3 : 0]  g;

    wire    po;
    wire    go;

    genvar i;
    generate
        // Inter-groups carry is parallel type
        if(TYPE == "grp_parallel") begin
            for(i = 0; i < 4; i=i+1) begin: gen_cla_grp_parallel
                cla4 #(.COEN(0))
                u_cla4(
                    .a      (a  [((i+1)*4-1):i*4]),
                    .b      (b  [((i+1)*4-1):i*4]),
                    .s      (s  [((i+1)*4-1):i*4]),
                    .ci     (c  [i]),
                    .po     (p  [i]),
                    .go     (g  [i])
                );
            end
            assign c[1] = g[0] | (p[0] & c[0]);
            assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
            assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
            assign po = p[3] & p[2] & p[1] & p[0];
            assign go = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);            
            // TODO: '5 input and gate' is not acceptable by backend process
            assign c[4] = go | (po & c[0]);
        end
        else begin
            // Inter-groups carry is serial type
            for(i = 0; i < 4; i=i+1) begin: gen_cla_grp_serial
                cla4 #(.COEN(1))
                u_cla4(
                    .a      (a  [((i+1)*4-1):i*4]),
                    .b      (b  [((i+1)*4-1):i*4]),
                    .s      (s  [((i+1)*4-1):i*4]),
                    .ci     (c  [i]),
                    .co     (c  [i+1])
                );
            end
        end
    endgenerate

    assign c[0] = 1'b0;
    
    wire sign;
    assign sign = a[15] ^ b[15] ^ c[4];
    assign sum = {sign,s};

endmodule


