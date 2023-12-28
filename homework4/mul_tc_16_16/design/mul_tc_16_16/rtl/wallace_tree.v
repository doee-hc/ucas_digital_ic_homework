// Component Name   : wallace_tree
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mul_tc_16_16/rtl/wallace_tree.v
// Author  : Huhc
// Date    : 2023-12-10 00:50:22
// Abstract: 
module wallace_tree(
    input  [5:0]    cin,
    input  [7:0]    din,
    output [5:0]    cout,
    output          c,
    output          s
);

    wire [5:0] s_temp;

    // level 0
    full_adder u_addr_0 (.a(din[0]), .b(din[1]), .c(1'b0  ), .s(s_temp[0]), .co(cout[0]));
    full_adder u_addr_1 (.a(din[2]), .b(din[3]), .c(din[4]), .s(s_temp[1]), .co(cout[1]));
    full_adder u_addr_2 (.a(din[5]), .b(din[6]), .c(din[7]), .s(s_temp[2]), .co(cout[2]));

    // level 1 
    full_adder u_addr_3 (.a(s_temp[0]), .b(s_temp[1]), .c(s_temp[2]), .s(s_temp[3]), .co(cout[3]));
    full_adder u_addr_4 (.a(cin[0]), .b(cin[1]), .c(cin[2]), .s(s_temp[4]), .co(cout[4]));

    // level 2 
    full_adder u_addr_5 (.a(s_temp[3]), .b(s_temp[4]), .c(cin[3]), .s(s_temp[5]), .co(cout[5]));

    // level 3 
    full_adder u_addr_6 (.a(s_temp[5]), .b(cin[4]), .c(cin[5]), .s(s), .co(c));

endmodule

