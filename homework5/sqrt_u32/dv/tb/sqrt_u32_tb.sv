`timescale 1ns / 10ps

module sqrt_u32_tb;
    reg unsigned [31:0] a; 
    reg vld_in;
    wire vld_out;
    reg clk;
    reg rst_n;
    
    reg [31:0] sqrt_res;


    real a_r ;
    real a_r_sqrt;

    reg [31:0] a_sqrt_ref[19:0];


    always #2.5 clk = ~clk;

    sqrt_u32 u_sqrt_u32(
        .x(a),
        .y(sqrt_res),
        .*
    );

    int i;
    int j;
    initial begin
        a=0;
        rst_n = 0;
        clk = 0;
        vld_in = 0;
        #5
        rst_n = 1;
        #5;

        for(i=0;i<16;i++) begin
            vld_in = 1;
            a =  $random;
            a_r = a;
            a_r_sqrt = $sqrt(a_r);
            a_sqrt_ref[i] = a_r_sqrt;      // This convert may cause a carry.
            if(a_sqrt_ref[i] > a_r_sqrt) begin
                a_sqrt_ref[i] = a_sqrt_ref[i] - 1; // Discard this carry
            end
            #5
            vld_in = 0;
        end
        #160;
        for(i=16;i<20;i++) begin
            vld_in = 1;
            a =  $random;
            a_r = a;
            a_r_sqrt = $sqrt(a_r);
            a_sqrt_ref[i] = a_r_sqrt;      // This convert may cause a carry.
            if(a_sqrt_ref[i] > a_r_sqrt) begin
                a_sqrt_ref[i] = a_sqrt_ref[i] - 1; // Discard this carry
            end
            #5
            vld_in = 0;
        end
    end

    initial begin
        for(j=0;j<20;j++) begin
            wait(vld_out);
            #1;
            $display("res=%d,ref=%d",sqrt_res,a_sqrt_ref[j]);
            #6;
        end
        $finish;
    end


endmodule



    


    
