`timescale 1ns / 1ns

module stop_watch_tb;
    reg             clk	       ;
    reg             rst_n	   ;
    reg             clear	   ;
    reg             start_stop ;
    wire     [3:0]   hr_h	   ;
    wire     [3:0]   hr_l	   ;
    wire     [3:0]   min_h	   ;
    wire     [3:0]   min_l	   ;
    wire     [3:0]   sec_h	   ;
    wire     [3:0]   sec_l	   ;

    stop_watch #(
        .SIM_EN(1)
    )u_stop_watch(
        .*
    );

 
    //always clk  <= #1 ~clk;   // bad code cause mem overflow!!!
    always #1 clk  =  ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        clear = 0;
        start_stop = 0;

        #2
        rst_n = 1;

        // start 
        #2 
        start_stop = 1;
        #5 
        start_stop = 0;
        
        wait(hr_h == 0 && hr_l == 6);

        // stop
        #5 
        start_stop = 1;
        #5 
        start_stop = 0;

        # 100000

        // start 
        #5 
        start_stop = 1;
        #5 
        start_stop = 0;

        wait(hr_h == 2 && hr_l == 3);
        #5 
        clear = 1;
        #5 
        clear = 0;

        # 100000
        $finish;
    end

    initial begin
        $monitor("hour = %d%d",hr_h,hr_l);
    end

endmodule



    


    
