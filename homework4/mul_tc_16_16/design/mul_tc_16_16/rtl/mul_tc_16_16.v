// Component Name   : mul_tc_16_16
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mul_tc_16_16/rtl/mul_tc_16_16.v
// Author  : Huhc
// Date    : 2023-12-10 00:01:49
// Abstract: Booth2+Wallace
//              Booth2 has 7 16bit-additions
//              Wallce has 4 level(12 gates delay): 8->6->4->3->2 
module mul_tc_16_16(
    input   [15:0]  a,
    input   [15:0]  b,
    output  [31:0]  product
);

    wire [5:0]  wt_cin   [31:0];
    wire [7:0]  wt_din   [31:0];
    wire [5:0]  wt_cout  [31:0];
    wire        wt_c     [31:0];
    wire        wt_s     [31:0];

    wire [16:0]     booth_xo[7:0];
    wire [31:0]     booth_xo_extend[7:0];
    wire            booth_co[7:0];
    wire [16:0]     b_shift;

    wire [31:0]     cla32_a;
    wire [31:0]     cla32_b;
    wire [31:0]     cla32_s;
    wire            cla32_ci;

    wire [31:0]     booth_xo_tmp[7:0];


    assign b_shift = {b,1'b0};

    genvar i,j;
    generate 
        for(i=0;i<8;i=i+1) begin: gen_booth
            booth2 u_booth2(
                .y  ({b_shift[i*2+2],b_shift[i*2+1],b_shift[i*2]}),
                .x  ({a[15],a}),
                .xo (booth_xo[i]),
                .co (booth_co[i])
            );

            assign booth_xo_tmp[i][31:17+i*2] = {(15-i*2){booth_xo[i][16]}};
            assign booth_xo_tmp[i][16+i*2:0] = booth_xo[i] << (i*2);
            assign booth_xo_extend[i] = booth_co[i] ? ~(booth_xo_tmp[i]) : booth_xo_tmp[i];


            for(j=0;j<32;j=j+1) begin: gen_tie_wt_din
                assign wt_din[j][i] = booth_xo_extend[i][j];
            end
        end

        // Tie wallace tree cin
        for(i=0;i<6;i=i+1) begin: gen_tie_wt_cin_0
            assign wt_cin[0][i]    = booth_co[i];
        end
        for(i=0;i<31;i=i+1) begin: gen_tie_wt_cin_1
            assign wt_cin[i+1] = wt_cout[i];
        end

        for(i=0;i<32;i=i+1) begin: gen_wt
            wallace_tree u_wallace_tree( 
                .cin(wt_cin[i]), 
                .din(wt_din[i]), 
                .cout(wt_cout[i]), 
                .c(wt_c[i]), 
                .s(wt_s[i])
            );
        end
        for(i=0;i<31;i=i+1) begin: gen_tie_cla32_a
            assign cla32_a[i+1] = wt_c[i];
        end
        for(i=0;i<32;i=i+1) begin: gen_tie_cla32_b
            assign cla32_b[i] = wt_s[i];
        end
        assign cla32_ci     = booth_co[6];
        assign cla32_a[0]   = booth_co[7];
    endgenerate


    cla32 u_cla32(
        .a  (cla32_a),
        .b  (cla32_b),
        .ci (cla32_ci),
        .s  (cla32_s)
    );

    assign product = cla32_s;

endmodule

