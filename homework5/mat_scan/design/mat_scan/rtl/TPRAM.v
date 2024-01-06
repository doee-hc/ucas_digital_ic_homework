// Component Name   : sram
// Component Version: 
// Release Type     : 
//  ------------------------------------------------------------------------

// 
// Release version :  
// File Version    :  
// Revision: 
//
//
// File    : design/mat_scan/rtl/TPRAM.v
// Author  : Huhc
// Date    : 2024-01-06 14:55:19
// Abstract: 
module TPRAM (
    input clk,

    input wea,                  //enable write signal of channel a
    input reb,                  //enable read signal of channel b

    input [4:0] addra,          //address of channel a
    input [4:0] addrb,          //address of channle b

    input [9:0] data_i_a,      //data input of channel a
    output reg [9:0] data_o_b //data output of channel b
);
reg [9:0] RAM [26:0];         //DATAWIDTH = 16, DEPTH = 256 = 2^8

always @(posedge clk) begin     //write channel
    if(wea) begin
        RAM[addra] <= data_i_a;
    end
end

always @(posedge clk) begin    //read channel
    if(reb) begin
        data_o_b <= RAM[addrb];
    end
end
endmodule
