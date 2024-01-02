`timescale 1ns / 10ps

module sort_32_u8_tb;
    reg vld_in;
    wire vld_out;
    reg clk;
    reg rst_n;
    reg [7:0] din[31:0];
    wire [7:0] dout[31:0];

    // Clock generation
    always #5 clk = ~clk;


    sort_32_u8 u_sort_32_u8(
        .clk(clk), 
        .rst_n(rst_n), 
        .vld_in(vld_in), 
        .din_0(din[0]), .din_1(din[1]), .din_2(din[2]), .din_3(din[3]),
        .din_4(din[4]), .din_5(din[5]), .din_6(din[6]), .din_7(din[7]),
        .din_8(din[8]), .din_9(din[9]), .din_10(din[10]), .din_11(din[11]),
        .din_12(din[12]), .din_13(din[13]), .din_14(din[14]), .din_15(din[15]),
        .din_16(din[16]), .din_17(din[17]), .din_18(din[18]), .din_19(din[19]),
        .din_20(din[20]), .din_21(din[21]), .din_22(din[22]), .din_23(din[23]),
        .din_24(din[24]), .din_25(din[25]), .din_26(din[26]), .din_27(din[27]),
        .din_28(din[28]), .din_29(din[29]), .din_30(din[30]), .din_31(din[31]),
        .vld_out(vld_out),
        .dout_0(dout[0]), .dout_1(dout[1]), .dout_2(dout[2]), .dout_3(dout[3]),
        .dout_4(dout[4]), .dout_5(dout[5]), .dout_6(dout[6]), .dout_7(dout[7]),
        .dout_8(dout[8]), .dout_9(dout[9]), .dout_10(dout[10]), .dout_11(dout[11]),
        .dout_12(dout[12]), .dout_13(dout[13]), .dout_14(dout[14]), .dout_15(dout[15]),
        .dout_16(dout[16]), .dout_17(dout[17]), .dout_18(dout[18]), .dout_19(dout[19]),
        .dout_20(dout[20]), .dout_21(dout[21]), .dout_22(dout[22]), .dout_23(dout[23]),
        .dout_24(dout[24]), .dout_25(dout[25]), .dout_26(dout[26]), .dout_27(dout[27]),
        .dout_28(dout[28]), .dout_29(dout[29]), .dout_30(dout[30]), .dout_31(dout[31])
    );

   // Initial block for testbench logic
    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        vld_in = 0;
        foreach(din[i]) din[i] = 0;

        // Apply Reset
        #100;
        rst_n = 1;

        // Generate random input data
        repeat (10) begin
            vld_in = 1;
            foreach(din[i]) din[i] = $random % 256; // Limiting to 8-bit values
            #11; 
            vld_in = 0;
            wait(vld_out);
            #1;
            $display("=====================");
            $display("I/O0 : %3d\t%3d" , din[0 ], dout[0 ]);
            $display("I/O1 : %3d\t%3d" , din[1 ], dout[1 ]);
            $display("I/O2 : %3d\t%3d" , din[2 ], dout[2 ]);
            $display("I/O3 : %3d\t%3d" , din[3 ], dout[3 ]);
            $display("I/O4 : %3d\t%3d" , din[4 ], dout[4 ]);
            $display("I/O5 : %3d\t%3d" , din[5 ], dout[5 ]);
            $display("I/O6 : %3d\t%3d" , din[6 ], dout[6 ]);
            $display("I/O7 : %3d\t%3d" , din[7 ], dout[7 ]);
            $display("I/O8 : %3d\t%3d" , din[8 ], dout[8 ]);
            $display("I/O9 : %3d\t%3d" , din[9 ], dout[9 ]);
            $display("I/O10: %3d\t%3d" , din[10], dout[10]);
            $display("I/O11: %3d\t%3d" , din[11], dout[11]);
            $display("I/O12: %3d\t%3d" , din[12], dout[12]);
            $display("I/O13: %3d\t%3d" , din[13], dout[13]);
            $display("I/O14: %3d\t%3d" , din[14], dout[14]);
            $display("I/O15: %3d\t%3d" , din[15], dout[15]);
            $display("I/O16: %3d\t%3d" , din[16], dout[16]);
            $display("I/O17: %3d\t%3d" , din[17], dout[17]);
            $display("I/O18: %3d\t%3d" , din[18], dout[18]);
            $display("I/O19: %3d\t%3d" , din[19], dout[19]);
            $display("I/O20: %3d\t%3d" , din[20], dout[20]);
            $display("I/O21: %3d\t%3d" , din[21], dout[21]);
            $display("I/O22: %3d\t%3d" , din[22], dout[22]);
            $display("I/O23: %3d\t%3d" , din[23], dout[23]);
            $display("I/O24: %3d\t%3d" , din[24], dout[24]);
            $display("I/O25: %3d\t%3d" , din[25], dout[25]);
            $display("I/O26: %3d\t%3d" , din[26], dout[26]);
            $display("I/O27: %3d\t%3d" , din[27], dout[27]);
            $display("I/O28: %3d\t%3d" , din[28], dout[28]);
            $display("I/O29: %3d\t%3d" , din[29], dout[29]);
            $display("I/O30: %3d\t%3d" , din[30], dout[30]);
            $display("I/O31: %3d\t%3d" , din[31], dout[31]);
        end

        // End of test
        #100;
        $finish;
    end


endmodule



    


    
