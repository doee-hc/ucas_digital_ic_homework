`timescale 1ns / 1ns

module mul_tc_16_16_tb;
    // Inputs
    reg signed [15:0] a;
    reg signed [15:0] b;

    // Outputs
    wire signed [31:0] product;


    mul_tc_16_16 u_mul_tc_16_16(
        .*
    );


    wire signed [31:0] mul_ref; 

    assign mul_ref = a * b;

    wire diff = (product ^ mul_ref) ? 1 : 0;

    initial begin
        a   = -32768;
        b   = -32768;
        #5
        a   = 1;
        b   = 1;
        #5
        a   = 1;
        b   = 2;
        #5
        a   = 2;
        b   = 2;

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
        $monitor("a = %d, b = %d, mul = %d, mul_ref = %d",a,b,product,mul_ref);

    end

endmodule



    


    
