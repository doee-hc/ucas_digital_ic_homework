// Component Name   : stop_watch
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : stop_watch/design/stop_watch/rtl/stop_watch.v
// Author  : Huhc
// Date    : 2023-12-08 19:32:23
// Abstract: 

module stop_watch #(
    parameter SIM_EN = 0  // 开启该选项用于将减少仿真时间
)(
    input                   clk	        ,//系统时钟，10 MHz
    input                   rst_n	    ,//异步复位，低电平有效
    input                   clear	    ,//清零按钮，上升沿有效
    input                   start_stop	,//开始/暂停按钮，上升沿有效
    output  reg     [3:0]   hr_h	    ,//时高位输出，取值0~9
    output  reg     [3:0]   hr_l	    ,//时低位输出，取值0~9
    output  reg     [3:0]   min_h	    ,//分高位输出，取值0~9
    output  reg     [3:0]   min_l	    ,//分低位输出，取值0~9
    output  reg     [3:0]   sec_h	    ,//秒高位输出，取值0~9
    output  reg     [3:0]   sec_l	     //秒低位输出，取值0~9
);

    reg     clear_r;
    wire    clear_en;
    reg     start_stop_r;
    wire    start_stop_en;
    reg     cnt_en;

    // clock bcd
    wire [23:0]  div_cnt;
    wire [3 :0]  s_cnt_l;
    wire [2 :0]  s_cnt_h;
    wire [3 :0]  m_cnt_l;
    wire [2 :0]  m_cnt_h;
    wire [3 :0]  h_cnt_l;
    wire [1 :0]  h_cnt_h;

    wire s_carry_l  ;
    wire s_carry_h  ;
    wire m_carry_l  ;
    wire m_carry_h  ;
    wire h_carry_l  ;
    wire h_carry_h  ;
    wire d_carry    ;

    wire div_cnt_clear;
    wire s_clear_l    ;
    wire s_clear_h    ;
    wire m_clear_l    ;
    wire m_clear_h    ;
    wire h_clear_l    ;
    wire h_clear_h    ;


    // clear_en
    assign clear_en = clear & ~clear_r;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            clear_r     <= '0;
        end
        else begin
            clear_r     <= clear;
        end
    end

    // start_stop_en
    assign start_stop_en = start_stop & ~start_stop_r;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            start_stop_r     <= '0;
            cnt_en           <= '0;
        end
        else begin
            start_stop_r     <= start_stop;
            if(start_stop_en) begin
                cnt_en <= ~cnt_en;
            end
        end
    end


    // 进位信号
    generate
        if (SIM_EN) begin
            //  减少仿真时间
            assign s_carry_l = (div_cnt == 100);
        end
        else begin
            assign s_carry_l = (div_cnt == 10_000_000);
        end
    endgenerate
    assign s_carry_h = s_carry_l & (s_cnt_l == 4'd9);
    assign m_carry_l = s_carry_h & (s_cnt_h == 3'd5);
    assign m_carry_h = m_carry_l & (m_cnt_l == 4'd9);
    assign h_carry_l = m_carry_h & (m_cnt_h == 4'd5);
    assign h_carry_h = h_carry_l & (h_cnt_l == 4'd9);
    assign d_carry   = h_carry_l & (h_cnt_l == 4'd3) && (h_cnt_h == 4'd2);

    //TODO: 尝试把clear信号放在异步复位端口，看看面积是否有变化
    assign div_cnt_clear    = clear_en | s_carry_l;
    assign s_clear_l        = clear_en | s_carry_h;
    assign s_clear_h        = clear_en | m_carry_l;
    assign m_clear_l        = clear_en | m_carry_h;
    assign m_clear_h        = clear_en | h_carry_l;
    assign h_clear_l        = clear_en | h_carry_h;
    assign h_clear_h        = clear_en | d_carry;

    counter_wrapper #(.CNT_WIDTH(24)) u_div_cnt (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (div_cnt_clear),
        .carry  (cnt_en),
        .cnt    (div_cnt)
    );
    counter_wrapper #(.CNT_WIDTH(4)) u_s_cnt_l (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (s_clear_l),
        .carry  (s_carry_l),
        .cnt    (s_cnt_l)
    );
    counter_wrapper #(.CNT_WIDTH(3)) u_s_cnt_h (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (s_clear_h),
        .carry  (s_carry_h),
        .cnt    (s_cnt_h)
    );
    counter_wrapper #(.CNT_WIDTH(4)) u_m_cnt_l (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (m_clear_l),
        .carry  (m_carry_l),
        .cnt    (m_cnt_l)
    );
    counter_wrapper #(.CNT_WIDTH(3)) u_m_cnt_h (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (m_clear_h),
        .carry  (m_carry_h),
        .cnt    (m_cnt_h)
    );
    counter_wrapper #(.CNT_WIDTH(4)) u_h_cnt_l (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (h_clear_l),
        .carry  (h_carry_l),
        .cnt    (h_cnt_l)
    );
    counter_wrapper #(.CNT_WIDTH(2)) u_h_cnt_h (
        .clk    (clk),
        .rst_n  (rst_n),
        .clear  (h_clear_h),
        .carry  (h_carry_h),
        .cnt    (h_cnt_h)
    );

    assign hr_h  = h_cnt_h;
    assign hr_l  = h_cnt_l;
    assign min_h = m_cnt_h;
    assign min_l = m_cnt_l;
    assign sec_h = s_cnt_h;
    assign sec_l = s_cnt_l;

endmodule

