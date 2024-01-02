// Component Name   : sort_32_u8
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/sort_32_u8/rtl/sort_32_u8.v
// Author  : Huhc
// Date    : 2024-01-02 14:09:38
// Abstract: 
module sort_32_u8(
    input   clk,
    input   rst_n,
    input   vld_in,
    input   [7:0]   din_0 ,
    input   [7:0]   din_1 ,
    input   [7:0]   din_2 ,
    input   [7:0]   din_3 ,
    input   [7:0]   din_4 ,
    input   [7:0]   din_5 ,
    input   [7:0]   din_6 ,
    input   [7:0]   din_7 ,
    input   [7:0]   din_8 ,
    input   [7:0]   din_9 ,
    input   [7:0]   din_10,
    input   [7:0]   din_11,
    input   [7:0]   din_12,
    input   [7:0]   din_13,
    input   [7:0]   din_14,
    input   [7:0]   din_15,
    input   [7:0]   din_16,
    input   [7:0]   din_17,
    input   [7:0]   din_18,
    input   [7:0]   din_19,
    input   [7:0]   din_20,
    input   [7:0]   din_21,
    input   [7:0]   din_22,
    input   [7:0]   din_23,
    input   [7:0]   din_24,
    input   [7:0]   din_25,
    input   [7:0]   din_26,
    input   [7:0]   din_27,
    input   [7:0]   din_28,
    input   [7:0]   din_29,
    input   [7:0]   din_30,
    input   [7:0]   din_31,

    output  vld_out,
    output  reg [7:0]   dout_0 ,
    output  reg [7:0]   dout_1 ,
    output  reg [7:0]   dout_2 ,
    output  reg [7:0]   dout_3 ,
    output  reg [7:0]   dout_4 ,
    output  reg [7:0]   dout_5 ,
    output  reg [7:0]   dout_6 ,
    output  reg [7:0]   dout_7 ,
    output  reg [7:0]   dout_8 ,
    output  reg [7:0]   dout_9 ,
    output  reg [7:0]   dout_10,
    output  reg [7:0]   dout_11,
    output  reg [7:0]   dout_12,
    output  reg [7:0]   dout_13,
    output  reg [7:0]   dout_14,
    output  reg [7:0]   dout_15,
    output  reg [7:0]   dout_16,
    output  reg [7:0]   dout_17,
    output  reg [7:0]   dout_18,
    output  reg [7:0]   dout_19,
    output  reg [7:0]   dout_20,
    output  reg [7:0]   dout_21,
    output  reg [7:0]   dout_22,
    output  reg [7:0]   dout_23,
    output  reg [7:0]   dout_24,
    output  reg [7:0]   dout_25,
    output  reg [7:0]   dout_26,
    output  reg [7:0]   dout_27,
    output  reg [7:0]   dout_28,
    output  reg [7:0]   dout_29,
    output  reg [7:0]   dout_30,
    output  reg [7:0]   dout_31
);
    reg  [7:0]  a   [16:0];
    reg  [7:0]  b   [16:0];
    reg  [7:0]  a_r [16:0];
    reg  [7:0]  b_r [16:0];
    reg  [7:0]  big [16:0];
    reg  [7:0]  lit [16:0];
    reg         en;
    reg         o_en;
    reg  [3:0]  state;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= 4'd15;
            o_en <= 1'b0;
            en <= 1'b0;
        end
        else begin
            o_en <= 1'b0;
            if(vld_in) begin
                state <= 0;
                en <= 1'b1;
            end
            else if(en) begin
                state <= state + 1'b1;
                if (state == 13) begin
                    en <= 1'b0;
                    o_en <= 1'b1;
                end  
            end
        end
    end

    // comparator
    genvar i;
    generate
        for(i=0;i<16;i=i+1) begin: gen_comparator
            always @(*) begin
                if(a_r[i] > b_r[i]) begin
                    big[i] = a_r[i];
                    lit[i] = b_r[i];
                end
                else begin
                    big[i] = b_r[i];
                    lit[i] = a_r[i];
                end
            end
            always @(posedge clk) begin
                if(vld_in | en) begin
                    a_r[i] <= a[i];
                    b_r[i] <= b[i];
                end
            end
        end

    endgenerate

    assign vld_out = o_en;

    assign dout_0  = lit[0];  
    assign dout_1  = big[0];  
    assign dout_2  = lit[1];   
    assign dout_3  = big[1];   
    assign dout_4  = lit[2];   
    assign dout_5  = big[2];   
    assign dout_6  = lit[3];   
    assign dout_7  = big[3];   
    assign dout_8  = lit[4];   
    assign dout_9  = big[4];   
    assign dout_10 = lit[5];   
    assign dout_11 = big[5];   
    assign dout_12 = lit[6];   
    assign dout_13 = big[6];   
    assign dout_14 = lit[7];   
    assign dout_15 = big[7];   
    assign dout_16 = lit[8];
    assign dout_17 = big[8];
    assign dout_18 = lit[9];
    assign dout_19 = big[9];
    assign dout_20 = lit[10];
    assign dout_21 = big[10];
    assign dout_22 = lit[11];
    assign dout_23 = big[11];
    assign dout_24 = lit[12];
    assign dout_25 = big[12];
    assign dout_26 = lit[13];
    assign dout_27 = big[13];
    assign dout_28 = lit[14];
    assign dout_29 = big[14];
    assign dout_30 = lit[15];
    assign dout_31 = big[15];

    // data flow
    always @(*) begin
        case(state)
            default:  begin 
                a[0 ] = din_0 ;   b[0 ] = din_16;
                a[1 ] = din_1 ;   b[1 ] = din_17;
                a[2 ] = din_2 ;   b[2 ] = din_18;
                a[3 ] = din_3 ;   b[3 ] = din_19;
                a[4 ] = din_4 ;   b[4 ] = din_20;
                a[5 ] = din_5 ;   b[5 ] = din_21;
                a[6 ] = din_6 ;   b[6 ] = din_22;
                a[7 ] = din_7 ;   b[7 ] = din_23;
                a[8 ] = din_8 ;   b[8 ] = din_24;
                a[9 ] = din_9 ;   b[9 ] = din_25;
                a[10] = din_10;   b[10] = din_26;
                a[11] = din_11;   b[11] = din_27;
                a[12] = din_12;   b[12] = din_28;
                a[13] = din_13;   b[13] = din_29;
                a[14] = din_14;   b[14] = din_30;
                a[15] = din_15;   b[15] = din_31;
            end

            4'd15: begin 
                a[0 ] = din_0 ;   b[0 ] = din_16;
                a[1 ] = din_1 ;   b[1 ] = din_17;
                a[2 ] = din_2 ;   b[2 ] = din_18;
                a[3 ] = din_3 ;   b[3 ] = din_19;
                a[4 ] = din_4 ;   b[4 ] = din_20;
                a[5 ] = din_5 ;   b[5 ] = din_21;
                a[6 ] = din_6 ;   b[6 ] = din_22;
                a[7 ] = din_7 ;   b[7 ] = din_23;
                a[8 ] = din_8 ;   b[8 ] = din_24;
                a[9 ] = din_9 ;   b[9 ] = din_25;
                a[10] = din_10;   b[10] = din_26;
                a[11] = din_11;   b[11] = din_27;
                a[12] = din_12;   b[12] = din_28;
                a[13] = din_13;   b[13] = din_29;
                a[14] = din_14;   b[14] = din_30;
                a[15] = din_15;   b[15] = din_31;
            end
            4'd0: begin
                a[0 ] = lit[ 0];   b[0 ] = big[ 1];
                a[1 ] = big[ 0];   b[1 ] = lit[ 1];
                a[2 ] = lit[ 2];   b[2 ] = big[ 3];
                a[3 ] = big[ 2];   b[3 ] = lit[ 3];
                a[4 ] = lit[ 4];   b[4 ] = big[ 5];
                a[5 ] = big[ 4];   b[5 ] = lit[ 5];
                a[6 ] = lit[ 6];   b[6 ] = big[ 7];
                a[7 ] = big[ 6];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = big[ 9];
                a[9 ] = big[ 8];   b[9 ] = lit[ 9];
                a[10] = lit[10];   b[10] = big[11];
                a[11] = big[10];   b[11] = lit[11];
                a[12] = lit[12];   b[12] = big[13];
                a[13] = big[12];   b[13] = lit[13];
                a[14] = lit[14];   b[14] = big[15];
                a[15] = big[14];   b[15] = lit[15];
            end
            4'd1: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 1];
                a[1 ] = big[ 0];   b[1 ] = big[ 1];
                a[2 ] = big[ 2];   b[2 ] = big[ 3];
                a[3 ] = lit[ 2];   b[3 ] = lit[ 3];
                a[4 ] = lit[ 4];   b[4 ] = lit[ 5];
                a[5 ] = big[ 4];   b[5 ] = big[ 5];
                a[6 ] = big[ 6];   b[6 ] = big[ 7];
                a[7 ] = lit[ 6];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[ 9];
                a[9 ] = big[ 8];   b[9 ] = big[ 9];
                a[10] = big[10];   b[10] = big[11];
                a[11] = lit[10];   b[11] = lit[11];
                a[12] = lit[12];   b[12] = lit[13];
                a[13] = big[12];   b[13] = big[13];
                a[14] = big[14];   b[14] = big[15];
                a[15] = lit[14];   b[15] = lit[15];
            end
            4'd2: begin
                a[0 ] = lit[ 0];   b[0 ] = big[ 2];
                a[1 ] = big[ 0];   b[1 ] = lit[ 2];
                a[2 ] = lit[ 1];   b[2 ] = big[ 3];
                a[3 ] = big[ 1];   b[3 ] = lit[ 3];
                a[4 ] = lit[ 4];   b[4 ] = big[ 6];
                a[5 ] = big[ 4];   b[5 ] = lit[ 6];
                a[6 ] = lit[ 5];   b[6 ] = big[ 7];
                a[7 ] = big[ 5];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = big[10];
                a[9 ] = big[ 8];   b[9 ] = lit[10];
                a[10] = lit[ 9];   b[10] = big[11];
                a[11] = big[ 9];   b[11] = lit[11];
                a[12] = lit[12];   b[12] = big[14];
                a[13] = big[12];   b[13] = lit[14];
                a[14] = lit[13];   b[14] = big[15];
                a[15] = big[13];   b[15] = lit[15];
            end
            4'd3: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 2];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 3];
                a[2 ] = big[ 0];   b[2 ] = big[ 2];
                a[3 ] = big[ 1];   b[3 ] = big[ 3];
                a[4 ] = big[ 4];   b[4 ] = big[ 6];
                a[5 ] = big[ 5];   b[5 ] = big[ 7];
                a[6 ] = lit[ 4];   b[6 ] = lit[ 6];
                a[7 ] = lit[ 5];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[10];
                a[9 ] = lit[ 9];   b[9 ] = lit[11];
                a[10] = big[ 8];   b[10] = big[10];
                a[11] = big[ 9];   b[11] = big[11];
                a[12] = big[12];   b[12] = big[14];
                a[13] = big[13];   b[13] = big[15];
                a[14] = lit[12];   b[14] = lit[14];
                a[15] = lit[13];   b[15] = lit[15];
            end
            4'd4: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 1];
                a[1 ] = big[ 0];   b[1 ] = big[ 1];
                a[2 ] = lit[ 2];   b[2 ] = lit[ 3];
                a[3 ] = big[ 2];   b[3 ] = big[ 3];
                a[4 ] = big[ 4];   b[4 ] = big[ 5];
                a[5 ] = lit[ 4];   b[5 ] = lit[ 5];
                a[6 ] = big[ 6];   b[6 ] = big[ 7];
                a[7 ] = lit[ 6];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[ 9];
                a[9 ] = big[ 8];   b[9 ] = big[ 9];
                a[10] = lit[10];   b[10] = lit[11];
                a[11] = big[10];   b[11] = big[11];
                a[12] = big[12];   b[12] = big[13];
                a[13] = lit[12];   b[13] = lit[13];
                a[14] = big[14];   b[14] = big[15];
                a[15] = lit[14];   b[15] = lit[15];
            end
            4'd5: begin
                a[0 ] = lit[ 0];   b[0 ] = big[ 4];
                a[1 ] = big[ 0];   b[1 ] = lit[ 4];
                a[2 ] = lit[ 1];   b[2 ] = big[ 5];
                a[3 ] = big[ 1];   b[3 ] = lit[ 5];
                a[4 ] = lit[ 2];   b[4 ] = big[ 6];
                a[5 ] = big[ 2];   b[5 ] = lit[ 6];
                a[6 ] = lit[ 3];   b[6 ] = big[ 7];
                a[7 ] = big[ 3];   b[7 ] = lit[ 7];
                a[8 ] = lit[ 8];   b[8 ] = big[12];
                a[9 ] = big[ 8];   b[9 ] = lit[12];
                a[10] = lit[ 9];   b[10] = big[13];
                a[11] = big[ 9];   b[11] = lit[13];
                a[12] = lit[10];   b[12] = big[14];
                a[13] = big[10];   b[13] = lit[14];
                a[14] = lit[11];   b[14] = big[15];
                a[15] = big[11];   b[15] = lit[15];
            end
            4'd6: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 4];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 5];
                a[2 ] = lit[ 2];   b[2 ] = lit[ 6];
                a[3 ] = lit[ 3];   b[3 ] = lit[ 7];
                a[4 ] = big[ 0];   b[4 ] = big[ 4];
                a[5 ] = big[ 1];   b[5 ] = big[ 5];
                a[6 ] = big[ 2];   b[6 ] = big[ 6];
                a[7 ] = big[ 3];   b[7 ] = big[ 7];
                a[8 ] = big[ 8];   b[8 ] = big[12];
                a[9 ] = big[ 9];   b[9 ] = big[13];
                a[10] = big[10];   b[10] = big[14];
                a[11] = big[11];   b[11] = big[15];
                a[12] = lit[ 8];   b[12] = lit[12];
                a[13] = lit[ 9];   b[13] = lit[13];
                a[14] = lit[10];   b[14] = lit[14];
                a[15] = lit[11];   b[15] = lit[15];
            end
            4'd7: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 2];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 3];
                a[2 ] = big[ 0];   b[2 ] = big[ 2];
                a[3 ] = big[ 1];   b[3 ] = big[ 3];
                a[4 ] = lit[ 4];   b[4 ] = lit[ 6];
                a[5 ] = lit[ 5];   b[5 ] = lit[ 7];
                a[6 ] = big[ 4];   b[6 ] = big[ 6];
                a[7 ] = big[ 5];   b[7 ] = big[ 7];
                a[8 ] = big[ 8];   b[8 ] = big[10];
                a[9 ] = big[ 9];   b[9 ] = big[11];
                a[10] = lit[ 8];   b[10] = lit[10];
                a[11] = lit[ 9];   b[11] = lit[11];
                a[12] = big[12];   b[12] = big[14];
                a[13] = big[13];   b[13] = big[15];
                a[14] = lit[12];   b[14] = lit[14];
                a[15] = lit[13];   b[15] = lit[15];   
            end
            4'd8: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 1];
                a[1 ] = big[ 0];   b[1 ] = big[ 1];
                a[2 ] = lit[ 2];   b[2 ] = lit[ 3];
                a[3 ] = big[ 2];   b[3 ] = big[ 3];
                a[4 ] = lit[ 4];   b[4 ] = lit[ 5];
                a[5 ] = big[ 4];   b[5 ] = big[ 5];
                a[6 ] = lit[ 6];   b[6 ] = lit[ 7];
                a[7 ] = big[ 6];   b[7 ] = big[ 7];
                a[8 ] = big[ 8];   b[8 ] = big[ 9];
                a[9 ] = lit[ 8];   b[9 ] = lit[ 9];
                a[10] = big[10];   b[10] = big[11];
                a[11] = lit[10];   b[11] = lit[11];
                a[12] = big[12];   b[12] = big[13];
                a[13] = lit[12];   b[13] = lit[13];
                a[14] = big[14];   b[14] = big[15];
                a[15] = lit[14];   b[15] = lit[15];            
            end
            4'd9: begin
                a[0 ] = lit[ 0];   b[0 ] = big[ 8];
                a[1 ] = big[ 0];   b[1 ] = lit[ 8];
                a[2 ] = lit[ 1];   b[2 ] = big[ 9];
                a[3 ] = big[ 1];   b[3 ] = lit[ 9];
                a[4 ] = lit[ 2];   b[4 ] = big[10];
                a[5 ] = big[ 2];   b[5 ] = lit[10];
                a[6 ] = lit[ 3];   b[6 ] = big[11];
                a[7 ] = big[ 3];   b[7 ] = lit[11];
                a[8 ] = lit[ 4];   b[8 ] = big[12];
                a[9 ] = big[ 4];   b[9 ] = lit[12];
                a[10] = lit[ 5];   b[10] = big[13];
                a[11] = big[ 5];   b[11] = lit[13];
                a[12] = lit[ 6];   b[12] = big[14];
                a[13] = big[ 6];   b[13] = lit[14];
                a[14] = lit[ 7];   b[14] = big[15];
                a[15] = big[ 7];   b[15] = lit[15];                    
            end
            4'd10: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 8];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 9];
                a[2 ] = lit[ 2];   b[2 ] = lit[10];
                a[3 ] = lit[ 3];   b[3 ] = lit[11];
                a[4 ] = lit[ 4];   b[4 ] = lit[12];
                a[5 ] = lit[ 5];   b[5 ] = lit[13];
                a[6 ] = lit[ 6];   b[6 ] = lit[14];
                a[7 ] = lit[ 7];   b[7 ] = lit[15];
                a[8 ] = big[ 0];   b[8 ] = big[ 8];
                a[9 ] = big[ 1];   b[9 ] = big[ 9];
                a[10] = big[ 2];   b[10] = big[10];
                a[11] = big[ 3];   b[11] = big[11];
                a[12] = big[ 4];   b[12] = big[12];
                a[13] = big[ 5];   b[13] = big[13];
                a[14] = big[ 6];   b[14] = big[14];
                a[15] = big[ 7];   b[15] = big[15];                
            end
            4'd11: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 4];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 5];
                a[2 ] = lit[ 2];   b[2 ] = lit[ 6];
                a[3 ] = lit[ 3];   b[3 ] = lit[ 7];
                a[4 ] = big[ 0];   b[4 ] = big[ 4];
                a[5 ] = big[ 1];   b[5 ] = big[ 5];
                a[6 ] = big[ 2];   b[6 ] = big[ 6];
                a[7 ] = big[ 3];   b[7 ] = big[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[12];
                a[9 ] = lit[ 9];   b[9 ] = lit[13];
                a[10] = lit[10];   b[10] = lit[14];
                a[11] = lit[11];   b[11] = lit[15];
                a[12] = big[ 8];   b[12] = big[12];
                a[13] = big[ 9];   b[13] = big[13];
                a[14] = big[10];   b[14] = big[14];
                a[15] = big[11];   b[15] = big[15];                
            end
            4'd12: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 2];
                a[1 ] = lit[ 1];   b[1 ] = lit[ 3];
                a[2 ] = big[ 0];   b[2 ] = big[ 2];
                a[3 ] = big[ 1];   b[3 ] = big[ 3];
                a[4 ] = lit[ 4];   b[4 ] = lit[ 6];
                a[5 ] = lit[ 5];   b[5 ] = lit[ 7];
                a[6 ] = big[ 4];   b[6 ] = big[ 6];
                a[7 ] = big[ 5];   b[7 ] = big[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[10];
                a[9 ] = lit[ 9];   b[9 ] = lit[11];
                a[10] = big[ 8];   b[10] = big[10];
                a[11] = big[ 9];   b[11] = big[11];
                a[12] = lit[12];   b[12] = lit[14];
                a[13] = lit[13];   b[13] = lit[15];
                a[14] = big[12];   b[14] = big[14];
                a[15] = big[13];   b[15] = big[15];                   
            end
            4'd13: begin
                a[0 ] = lit[ 0];   b[0 ] = lit[ 1];
                a[1 ] = big[ 0];   b[1 ] = big[ 1];
                a[2 ] = lit[ 2];   b[2 ] = lit[ 3];
                a[3 ] = big[ 2];   b[3 ] = big[ 3];
                a[4 ] = lit[ 4];   b[4 ] = lit[ 5];
                a[5 ] = big[ 4];   b[5 ] = big[ 5];
                a[6 ] = lit[ 6];   b[6 ] = lit[ 7];
                a[7 ] = big[ 6];   b[7 ] = big[ 7];
                a[8 ] = lit[ 8];   b[8 ] = lit[ 9];
                a[9 ] = big[ 8];   b[9 ] = big[ 9];
                a[10] = lit[10];   b[10] = lit[11];
                a[11] = big[10];   b[11] = big[11];
                a[12] = lit[12];   b[12] = lit[13];
                a[13] = big[12];   b[13] = big[13];
                a[14] = lit[14];   b[14] = lit[15];
                a[15] = big[14];   b[15] = big[15];                 
            end
        endcase
    end






endmodule

