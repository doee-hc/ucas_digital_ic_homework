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
    input       [31:0]  x,
    output          vld_out,
    output  reg [15:0]  y
);
    wire    [31:0]  x_fifo;
    wire    [32:0]  ix;
    wire    [32:0]  iy;
    wire    [31:0]  ox;
    wire    [31:0]  oy;
    wire    [63:0]  ox_k;
    reg     [31:0]  x_sft;
    reg     [15:0]  sqrt_res;


    wire            data_vld;
    reg             data_vld_r;
    reg             data_vld_r1;
    reg             cordic_ien;
    wire            cordic_oen;
    wire            cordic_oen_pre;

    reg             cordic_oen_r;

    fifo #(
        .DATA_WIDTH(32),
        .DEPTH(16)
    )u_fifo_32_16(
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .wr_en      (vld_in     ),
        .wr_data    (x          ),
        .rd_en      (cordic_ien ),
        .rd_data    (x_fifo     ),
        .empty      (fifo_empty )
    );

    assign data_vld = ~fifo_empty & cordic_ien;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_vld_r  <= 1'b0;
            data_vld_r1 <= 1'b0;
        end
        else begin
            data_vld_r  <= data_vld;
            data_vld_r1 <= data_vld_r;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cordic_ien <= 1'b1;
        end
        else begin
            if(cordic_oen_pre) begin
                cordic_ien <= 1'b1;
            end
            else if(data_vld) begin
                cordic_ien <= 1'b0;
            end
        end
    end

    always @(*) begin
        casex (x_fifo)
            32'b0000_0000_0000_0000_0000_0000_0000_00xx: begin  x_sft = x_fifo << 30;   sqrt_res <= ox_k >> 59;  end  // * 2^ 1
            32'b0000_0000_0000_0000_0000_0000_0000_xxxx: begin  x_sft = x_fifo << 28;   sqrt_res <= ox_k >> 58;  end  // * 2^-1
            32'b0000_0000_0000_0000_0000_0000_00xx_xxxx: begin  x_sft = x_fifo << 26;   sqrt_res <= ox_k >> 57;  end  // * 2^-3
            32'b0000_0000_0000_0000_0000_0000_xxxx_xxxx: begin  x_sft = x_fifo << 24;   sqrt_res <= ox_k >> 56;  end  // * 2^-5
            32'b0000_0000_0000_0000_0000_00xx_xxxx_xxxx: begin  x_sft = x_fifo << 22;   sqrt_res <= ox_k >> 55;  end  // * 2^-7
            32'b0000_0000_0000_0000_0000_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 20;   sqrt_res <= ox_k >> 54;  end  // * 2^-9
            32'b0000_0000_0000_0000_00xx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 18;   sqrt_res <= ox_k >> 53;  end  // * 2^-11
            32'b0000_0000_0000_0000_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 16;   sqrt_res <= ox_k >> 52;  end  // * 2^-13
            32'b0000_0000_0000_00xx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 14;   sqrt_res <= ox_k >> 51;  end  // * 2^-15
            32'b0000_0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 12;   sqrt_res <= ox_k >> 50;  end  // * 2^-17
            32'b0000_0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo << 10;   sqrt_res <= ox_k >> 49;  end  // * 2^-19
            32'b0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo <<  8;   sqrt_res <= ox_k >> 48;  end  // * 2^-21
            32'b0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo <<  6;   sqrt_res <= ox_k >> 47;  end  // * 2^-23
            32'b0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo <<  4;   sqrt_res <= ox_k >> 46;  end  // * 2^-25
            32'b00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin  x_sft = x_fifo <<  2;   sqrt_res <= ox_k >> 45;  end  // * 2^-27
            default:                                     begin  x_sft = x_fifo;         sqrt_res <= ox_k >> 44; end  // * 2^-29
        endcase
    end

    //always @(posedge clk) begin
    //    if(data_vld_r) begin
    //        ix <= x_sft+32'h2000_0000;
    //        iy <= x_sft-32'h2000_0000;
    //    end
    //end

    assign ix = x_sft+32'h2000_0000;
    assign iy = x_sft-32'h2000_0000;

    cordic #(.ITERATION(8))
    u_cordic (
        .clk        (clk           ),
        .rst_n      (rst_n         ),
        .i_en       (data_vld_r1   ),
        .ix         (ix            ),
        .iy         (iy            ),
        .o_en       (cordic_oen    ),
        .o_en_pre   (cordic_oen_pre),
        .ox         (ox            ),
        .oy         (oy            )
    );

    // good condition : 8 iteration
    assign ox_k = ox * 32'b0001_1011_0100_0100_1100_0111_1111_1111;
    // good condition : 7 iteration
    //assign ox_k = ox * 32'b0001_1011_0100_0100_1011_1000_0000_0000;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cordic_oen_r <= 1'b0;
        end
        else begin
            cordic_oen_r <= cordic_oen;
            if(cordic_oen) begin
                y <= sqrt_res;
            end
        end
    end

    assign vld_out = cordic_oen_r;


endmodule

