
define(x_er, x19)       // Multiplier
define(x_cand, x20)     // Multiplicand
define(x_prod, x21)     // Product
define(x_time, x28)     // Loop times

output: .string "%d * %d = %d\n"
        // Expose main function to OS
        .global main
        .balign 4

main:                                           // main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!      // space stack pointer
        mov     x29,    sp                      // frame-pointer = stack-pointer;

        // Set random seed
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));      set random seed to current timestamp

        mov     x_er,   16                      // multiplier = 16;     set multiplier to 16

loop:   
        sub     x_er,   x_er,   1               // multiplier --;       decrese multiplier by 1
        mov     x_cand, 0                       // multiplicand = 0;    set multiplicand to default 0
        mov     x_prod, 0                       // product = 0;         set product to 0

        mov     x_time, 0

        cmp     x_er,   -15                     // if (multiplier < -15)
        b.lt    end                             // then end the loop

random: bl      rand                            // rand();
        and  	x9,     x0,     0xF             // rand() % 16;         range 0 - 15
        mov     x_cand, x9                      // multiplicand = rand; set random number to multiplicand

        


multiply_start:                                 // Multiplication loop
        mov     x_time, 0                       // time = 0;            loop times set to default 0

multiply_test:
        cmp     x_time, 64                      // if (time > 64)       iterate 64 times
        b.ge    multiply_end                    // then end the multiplication loop


        // Least bit of cand
        asr     x10,    x_cand, x_time          // x10 = multiplicand >> time;  right shift multiplier by x times
        tst     x10,    0x1                     // if (x10 & 1)                 compare if the last digit is 1
        b.ne    proadd                          // then should add the product
        b       pronon                          // otherwise not add

proadd: lsl     x9,     x_er,   x_time          // x9 = multiplier << time;     left shift multiplicand x times
        add     x_prod, x_prod, x9              // product += x9;               add the result to product
pronon:
        add     x_time, x_time, 1               // time ++;     Increse time by 1
        b       multiply_test                   // go back to multiplication loop test
       

multiply_end:


        
        ldr     x0,     =output
        mov     x1,     x_er
        mov     x2,     x_cand
        mov     x3,     x_prod
        bl      printf


        // Go back to loop
        b       loop


end:


        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS
