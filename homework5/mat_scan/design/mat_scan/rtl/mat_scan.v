// Component Name   : mat_scan
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mat_scan/rtl/mat_scan.v
// Author  : Huhc
// Date    : 2024-01-02 23:44:54
// Abstract: 
module mat_scan(
    input           clk,
    input           rst_n,
    input           vld_in,
    input   [9:0]   din,
    output  reg         vld_out,
    output  reg [9:0]   dout
);

    
    wire [4:0]  zigzag_seq[0:62] = {
        5'd1 -1,5'd2 -1,5'd9 -1,5'd17-1,5'd10-1,5'd3 -1,5'd4 -1,5'd11-1,
        5'd18-1,5'd25-1,5'd3 -1,5'd26-1,5'd19-1,5'd12-1,5'd5 -1,5'd6 -1,
        5'd13-1,5'd20-1,5'd27-1,5'd4 -1,5'd12-1,5'd5 -1,5'd11-1,5'd1 -1,
        5'd21-1,5'd14-1,5'd7 -1,5'd8 -1,5'd15-1,5'd22-1,5'd2 -1,5'd18-1,
        5'd6 -1,5'd5 -1,5'd15-1,5'd22-1,5'd11-1,5'd13-1,5'd25-1,5'd9 -1,
        5'd23-1,5'd16-1,5'd24-1,5'd17-1,5'd3 -1,5'd20-1,5'd1 -1,5'd2 -1,
        5'd18-1,5'd21-1,5'd27-1,5'd26-1,5'd10-1,5'd19-1,5'd4 -1,5'd14-1,
        5'd6 -1,5'd5 -1,5'd7 -1,5'd12-1,5'd8 -1,5'd15-1,5'd22-1 };

    reg [6:0] state_cur;
    reg [6:0] state_nxt;

    reg             we;
    reg             re;
    reg             re_r;
    reg     [4:0]   wr_addr;
    wire    [4:0]   rd_addr;
    reg     [9:0]   wr_data;
    reg     [9:0]   wr_data_r;
    reg     [9:0]   rd_data;

    assign rd_addr = wr_addr;

    TPRAM u_ram_8_27(
        .clk        (clk        ),
        .wea        (we         ),
        .reb        (re         ),
        .addra      (wr_addr    ),
        .addrb      (rd_addr    ),
        .data_i_a   (wr_data    ),
        .data_o_b   (rd_data    )
    );

    always @(*) begin
        if(state_cur == 91) begin
            state_nxt = 0;
        end else if(vld_in | state_cur > 63) begin
            state_nxt = state_cur + 1;
        end else begin
            state_nxt = state_cur;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state_cur = 0;
        end
        else begin
            state_cur <= state_nxt;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            we <= 1'b0;
            re <= 1'b0;
        end
        else begin
            we <= 1'b0;
            re <= 1'b0;
            if(state_nxt != 0) begin
                if(state_cur < 27) begin
                    wr_addr <= state_cur;
                    we      <= 1'b1;
                    wr_data <= din;
                end else if(state_cur < 48) begin
                    wr_addr <= zigzag_seq[state_cur-27];
                    we      <= 1'b1;
                    wr_data <= din;
                    re      <= 1'b1;
                end else if(state_cur != 48) begin
                    wr_addr <= zigzag_seq[state_cur-28];
                    we      <= 1'b1;
                    wr_data <= din;
                    re      <= 1'b1;
                end else begin
                    wr_data <= din;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            re_r <= 1'b0;
        end
        else begin
            re_r <= re;
            wr_data_r <= wr_data;
        end
    end

    always @(*) begin
        if(state_cur == 50) begin
            dout = wr_data_r;
            vld_out = 1'b1;
        end else begin
            dout = rd_data;
            vld_out = re_r;
        end
    end

endmodule

