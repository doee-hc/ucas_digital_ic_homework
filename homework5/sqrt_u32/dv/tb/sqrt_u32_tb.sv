`timescale 1ns / 1ns

module sqrt_u32_tb;
    reg [31:0] a; // a != 0xFF...F
    
    wire [31:0] am1;
    wire [32:0] ap1;
    wire signed [33:0] ix;
    wire signed [33:0] iy;
    wire [31:0] ox;
    wire [31:0] oy;
    reg [31:0] a_sft;
    reg [31:0] x_sft;
    reg [31:0] y_sft;

    assign ix = a_sft+32'b0010_0000_0000_0000_0000_0000_0000_0000;
    assign iy = a_sft-32'b0010_0000_0000_0000_0000_0000_0000_0000;
//0001_1011_0100_0100_1110_1011_1010_1011_1101_00011010010100001111
    //wire [80:0] ox_k = ox * 32'b0001_1011_0100_0100_1110_1011_1010_1011;
    //wire [80:0] ox_k = ox * 32'b0001_1011_0100_0100_1110_0101_1111_1111;
    wire [80:0] ox_k = ox * 32'b0001_1011_0100_0101_0000_0000_1111_1111;
                            
    reg [3:0] state;


    always @(*) begin
        casex (a)
            32'b0000_0000_0000_0000_0000_0000_0000_00xx: begin state =  0;a_sft = a << 30; x_sft = ox_k >> 59;  end  // * 2^ 1
            32'b0000_0000_0000_0000_0000_0000_0000_xxxx: begin state =  1;a_sft = a << 28; x_sft = ox_k >> 58;  end  // * 2^-1
            32'b0000_0000_0000_0000_0000_0000_00xx_xxxx: begin state =  2;a_sft = a << 26; x_sft = ox_k >> 57;  end  // * 2^-3
            32'b0000_0000_0000_0000_0000_0000_xxxx_xxxx: begin state =  3;a_sft = a << 24; x_sft = ox_k >> 56;  end  // * 2^-5
            32'b0000_0000_0000_0000_0000_00xx_xxxx_xxxx: begin state =  4;a_sft = a << 22; x_sft = ox_k >> 55;  end  // * 2^-7
            32'b0000_0000_0000_0000_0000_xxxx_xxxx_xxxx: begin state =  5;a_sft = a << 20; x_sft = ox_k >> 54;  end  // * 2^-9
            32'b0000_0000_0000_0000_00xx_xxxx_xxxx_xxxx: begin state =  6;a_sft = a << 18; x_sft = ox_k >> 53;  end  // * 2^-11
            32'b0000_0000_0000_0000_xxxx_xxxx_xxxx_xxxx: begin state =  7;a_sft = a << 16; x_sft = ox_k >> 52;  end  // * 2^-13
            32'b0000_0000_0000_00xx_xxxx_xxxx_xxxx_xxxx: begin state =  8;a_sft = a << 14; x_sft = ox_k >> 51;  end  // * 2^-15
            32'b0000_0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx: begin state =  9;a_sft = a << 12; x_sft = ox_k >> 50;  end  // * 2^-17
            32'b0000_0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 10;a_sft = a << 10; x_sft = ox_k >> 49;  end  // * 2^-19
            32'b0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 11;a_sft = a <<  8; x_sft = ox_k >> 48;  end  // * 2^-21
            32'b0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 12;a_sft = a <<  6; x_sft = ox_k >> 47;  end  // * 2^-23
            32'b0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 13;a_sft = a <<  4; x_sft = ox_k >> 46;  end  // * 2^-25
            32'b00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 14;a_sft = a <<  2; x_sft = ox_k >> 45;  end  // * 2^-27
            //32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
            default:                                     begin state = 15;a_sft = a;       x_sft = ox_k >> 44 ; y_sft = oy ; end  // * 2^-29
        endcase
    end


    cordic u_cordic (
        .ix(ix),
        .iy(iy),
        .ox(ox),
        .oy(oy)
    );

    real a_r ;
    real a_r_sqrt;
    reg [31:0] a_sqrt_ref;

    real res;
    real res_ref;
    real ratio;
    reg [3:0]  cnt;
    wire diff;

    assign diff_p = x_sft == (a_sqrt_ref+1);
    assign diff_n = x_sft == (a_sqrt_ref-1);
    assign diff = x_sft != (a_sqrt_ref);

    
    initial begin
        ratio = 1;
        a=0;
        cnt = 0;

        
        forever begin
            a =  $random;
            //cnt = (cnt+1) ;
            //cnt = (cnt == 0) ? 1 : cnt;
            //a = cnt << 28;
            a_r = a;
            a_r_sqrt = $sqrt(a_r);
            a_sqrt_ref = a_r_sqrt;      // This convert may cause a carry.

            // Discard this carry
            if(a_sqrt_ref > a_r_sqrt) begin
                a_sqrt_ref = a_sqrt_ref - 1;
            end

            #5
            res = x_sft;
            res_ref = a_sqrt_ref;

            // error ratio
            ratio = res / res_ref;
        end
    end

    initial begin
        #10000
        $finish;
    end


    //initial begin
    //end

endmodule



    


    
