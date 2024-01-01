// Component Name   : fifo
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/sqrt_u32/rtl/fifo.v
// Author  : Huhc
// Date    : 2024-01-01 11:11:31
// Abstract: 

module fifo #(
    parameter DATA_WIDTH = 32,  // 默认字宽32位
    parameter DEPTH = 16        // 默认深度为16
) (
    input clk,
    input rst_n,
    input wr_en,               // 写使能
    input rd_en,               // 读使能
    input [DATA_WIDTH-1:0] wr_data,  // 写入数据
    output reg [DATA_WIDTH-1:0] rd_data, // 读出数据
    output reg full,           // FIFO满标志
    output reg empty           // FIFO空标志
);

// 地址宽度计算，用于确定指针大小
localparam ADDR_WIDTH = $clog2(DEPTH);

// 内部变量
reg [DATA_WIDTH-1:0] memory [0:DEPTH-1]; // FIFO存储
reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;     // 写和读指针
integer i;

wire [ADDR_WIDTH-1:0] wr_ptr_pone = (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
wire [ADDR_WIDTH-1:0] rd_ptr_pone = (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;

// FIFO状态更新
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // 复位逻辑
        wr_ptr <= 0;
        rd_ptr <= 0;
        empty <= 1;
        full <= 0;
        for (i = 0; i < DEPTH; i = i + 1) begin
            memory[i] <= 0;
        end
    end else begin
        // 同时读写操作
        if (wr_en && !full && rd_en && !empty) begin
            memory[wr_ptr] <= wr_data;
            rd_data <= memory[rd_ptr];
            wr_ptr <= wr_ptr_pone;
            rd_ptr <= rd_ptr_pone;
        end
        // 只写操作
        else if (wr_en && !full) begin
            memory[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr_pone;
            if (rd_ptr == wr_ptr_pone) full <= 1;
            empty <= 0;
        end
        // 只读操作
        else if (rd_en && !empty) begin
            rd_data <= memory[rd_ptr];
            rd_ptr <= rd_ptr_pone;
            if (wr_ptr == rd_ptr_pone) empty <= 1;
            full <= 0;
        end

    end
end

endmodule

