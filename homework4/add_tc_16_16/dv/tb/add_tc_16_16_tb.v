`timescale 1ns / 1ns

module add_tc_16_16_tb;
    // Inputs
    reg signed [15:0] a;
    reg signed [15:0] b;

    // Outputs
    wire signed [16:0] s[1:0];


    add_tc_16_16 #(
        .TYPE("grp_parallel"))
    u_cla16_0 (
        .a  (a  ),
        .b  (b  ),
        .sum(s[0][16:0])
    );

    add_tc_16_16 #(
        .TYPE("serial"))
    u_cla16_1 (
        .a  (a  ),
        .b  (b  ),
        .sum(s[1][16:0])
    );

    wire signed [16:0] sum_ref; 

    assign sum_ref = a + b;

    wire diff = (s[0] ^ s[1]) || (s[0] ^ sum_ref);

    initial begin
        a   = -32768;
        b   = -32768;
        forever begin
            #5
            a =  32768 - ($random % 65536);
            b =  32768 - ($random % 65536);
            if(diff) begin
                $display("error occured!"); 
            end
        end
    end

    initial begin
        #1000
        $finish;
    end


    initial begin
        $monitor("a = %d, b = %d, sum0 = %d, sum1 = %d, sum_ref = %d",a,b,s[0],s[1],sum_ref);
    end

endmodule



    


    
