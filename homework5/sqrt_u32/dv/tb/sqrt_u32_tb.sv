`timescale 1ns / 1ns

module sqrt_u32_tb;
    reg [31:0] a; // a != 0xFF...F
    
    reg [31:0] sqrt_res;


    real a_r ;
    real a_r_sqrt;

    reg [31:0] a_sqrt_ref;

    real res;
    real res_ref;
    real ratio;
    wire diff;

    assign diff_p = sqrt_res == (a_sqrt_ref+1);
    assign diff_n = sqrt_res == (a_sqrt_ref-1);
    assign diff = sqrt_res != (a_sqrt_ref);

    wire bad_diff = diff ^ (diff_n | diff_p);

    sqrt_u32 u_sqrt_u32(
        .x(a),
        .y(sqrt_res)
    );
    initial begin
        ratio = 1;
        a=0;
        forever begin
            a =  4294967295;
            a_r = a;
            a_r_sqrt = $sqrt(a_r);
            a_sqrt_ref = a_r_sqrt;      // This convert may cause a carry.

            // Discard this carry
            if(a_sqrt_ref > a_r_sqrt) begin
                a_sqrt_ref = a_sqrt_ref - 1;
            end

            #5
            res = sqrt_res;
            res_ref = a_sqrt_ref;

            // error ratio
            ratio = res / res_ref;
            if(bad_diff ) begin
                $display("A bad error is occured!");
                $finish;
            end
            //else if(diff_p) begin
            //    $display("32'h%x,",a);
            //end
                
        end
    end

    initial begin
        #10000
        $finish;
    end


endmodule



    


    
