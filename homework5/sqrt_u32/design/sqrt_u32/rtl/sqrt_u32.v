// Component Name   : sqrt_u32
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/sqrt_u32/rtl/sqrt_u32.v
// Author  : Huhc
// Date    : 2023-12-28 20:41:45
// Abstract: 
module sqrt_u32(
    input           clk,
    input           rst_n,
    input           vld_in,
    input   [31:0]  x,
    output  [31:0]  vld_out,
    output  [15:0]  y
);
    wire    [32:0]  ix;
    wire    [32:0]  iy;
    wire    [31:0]  ox;
    wire    [31:0]  oy;
    wire    [63:0]  ox_k;
    reg     [31:0]  x_sft;
    reg     [15:0]  sqrt_res;

    assign ix = x_sft+32'h2000_0000;
    assign iy = x_sft-32'h2000_0000;

    // good condition : 8 iteration
    assign ox_k = ox * 32'b0001_1011_0100_0100_1100_0111_1111_1111;
    //assign ox_k = ox * 32'b0001_1011_0100_0100_1110_0000_0000_0000;
    //assign ox_k = ox * 32'b0001_1011_0100_0100_1111_0000_0000_0000;
    // good condition : 7 iteration
    //assign ox_k = ox * 32'b0001_1011_0100_0100_1011_1000_0000_0000;

    cordic #(.ITERATION(8))
    u_cordic (
        .ix(ix),
        .iy(iy),
        .ox(ox),
        .oy(oy)
    );

    always @(*) begin
        casex (x)
            32'b0000_0000_0000_0000_0000_0000_0000_00xx: begin x_sft = x << 30; sqrt_res = ox_k >> 59;  end  // * 2^ 1
            32'b0000_0000_0000_0000_0000_0000_0000_xxxx: begin x_sft = x << 28; sqrt_res = ox_k >> 58;  end  // * 2^-1
            32'b0000_0000_0000_0000_0000_0000_00xx_xxxx: begin x_sft = x << 26; sqrt_res = ox_k >> 57;  end  // * 2^-3
            32'b0000_0000_0000_0000_0000_0000_xxxx_xxxx: begin x_sft = x << 24; sqrt_res = ox_k >> 56;  end  // * 2^-5
            32'b0000_0000_0000_0000_0000_00xx_xxxx_xxxx: begin x_sft = x << 22; sqrt_res = ox_k >> 55;  end  // * 2^-7
            32'b0000_0000_0000_0000_0000_xxxx_xxxx_xxxx: begin x_sft = x << 20; sqrt_res = ox_k >> 54;  end  // * 2^-9
            32'b0000_0000_0000_0000_00xx_xxxx_xxxx_xxxx: begin x_sft = x << 18; sqrt_res = ox_k >> 53;  end  // * 2^-11
            32'b0000_0000_0000_0000_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 16; sqrt_res = ox_k >> 52;  end  // * 2^-13
            32'b0000_0000_0000_00xx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 14; sqrt_res = ox_k >> 51;  end  // * 2^-15
            32'b0000_0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 12; sqrt_res = ox_k >> 50;  end  // * 2^-17
            32'b0000_0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 10; sqrt_res = ox_k >> 49;  end  // * 2^-19
            32'b0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  8; sqrt_res = ox_k >> 48;  end  // * 2^-21
            32'b0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  6; sqrt_res = ox_k >> 47;  end  // * 2^-23
            32'b0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  4; sqrt_res = ox_k >> 46;  end  // * 2^-25
            32'b00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  2; sqrt_res = ox_k >> 45;  end  // * 2^-27
            default:                                     begin x_sft = x;       sqrt_res = ox_k >> 44 ; end  // * 2^-29
        endcase
    end

    assign y = sqrt_res;
endmodule

