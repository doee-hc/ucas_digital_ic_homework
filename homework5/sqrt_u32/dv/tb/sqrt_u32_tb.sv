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
    wire [80:0] ox_k = ox * 32'b0001_1011_0100_0100_1110_1011_1010_1011;
                            
    reg [3:0] state;


    always @(*) begin
        casex (a)
            32'b0000_0000_0000_0000_0000_0000_0000_xxxx: begin state = 0;a_sft = a << 28; x_sft = ox_k >> 58; y_sft = oy >>>28-4; end  // * 2^-1
            32'b0000_0000_0000_0000_0000_0000_xxxx_xxxx: begin state = 1;a_sft = a << 24; x_sft = ox_k >> 56; y_sft = oy >>>24-4; end  // * 2^-5
            32'b0000_0000_0000_0000_0000_xxxx_xxxx_xxxx: begin state = 2;a_sft = a << 20; x_sft = ox_k >> 54; y_sft = oy >>>20-4; end  // * 2^-9
            32'b0000_0000_0000_0000_xxxx_xxxx_xxxx_xxxx: begin state = 3;a_sft = a << 16; x_sft = ox_k >> 52; y_sft = oy >>>16-4; end  // * 2^-13
            32'b0000_0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 4;a_sft = a << 12; x_sft = ox_k >> 50; y_sft = oy >>>12-4; end  // * 2^-17
            32'b0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 5;a_sft = a <<  8; x_sft = ox_k >> 48; y_sft = oy >>> 8-4; end  // * 2^-21
            32'b0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin state = 6;a_sft = a <<  4; x_sft = ox_k >> 46; y_sft = oy >>> 4-4; end  // * 2^-25
            //32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
            default:                                     begin a_sft = a;       x_sft = ox_k >> 44 ; y_sft = oy ; end  // * 2^-29
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

    
    initial begin
        a = 0;
        forever begin
            #5
            a =  $random;
            a_r = a;
            a_r_sqrt = $sqrt(a_r);
            a_sqrt_ref = a_r_sqrt;      // This convert may cause a carry.

            // Discard this carry
            if(a_sqrt_ref > a_r_sqrt) begin
                a_sqrt_ref = a_sqrt_ref - 1;
            end

            #1
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



    


    
