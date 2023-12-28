// Component Name   : counter_wrapper
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : homework4/stop_watch/design/stop_watch/rtl/counter_wrapper.v
// Author  : Huhc
// Date    : 2023-12-08 21:28:08
// Abstract: 

module counter_wrapper #(
    parameter CNT_WIDTH = 3
)(
    input                       clk,
    input                       rst_n,
    input                       clear,
    input                       carry,
    output reg [CNT_WIDTH-1:0]  cnt
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (clear) begin
            cnt <= 0;
        end else if (carry) begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule

