
       // Multiplier
     // Multiplicand
     // Product
     // Loop times

output: .string "%d * %d	=	%d\n"
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

        mov     x19,   16                      // multiplier = 16;     set multiplier to 16

loop:   
        sub     x19,   x19,   1               // multiplier --;       decrese multiplier by 1
        mov     x20, 0                       // multiplicand = 0;    set multiplicand to default 0
        mov     x21, 0                       // product = 0;         set product to 0

        mov     x28, 0

        cmp     x19,   -15                     // if (multiplier < -15)
        b.lt    end                             // then end the loop

random: bl      rand                            // rand();
        and  	x9,     x0,     0xF             // rand() % 16;         range 0 - 15
        mov     x20, x9                      // multiplicand = rand; set random number to multiplicand

        


multiply_start:                                 // Multiplication loop
        mov     x28, 0                       // time = 0;            loop times set to default 0

multiply_test:
        cmp     x28, 64                      // if (time > 64)       iterate 64 times
        b.ge    multiply_end                    // then end the multiplication loop


        // Least bit of cand
        asr     x10,    x20, x28          // x10 = multiplicand >> time;  right shift multiplier by x times
        tst     x10,    0x1                     // if (x10 & 1)                 compare if the last digit is 1
        b.ne    proadd                          // then should add the product
        b       pronon                          // otherwise not add

proadd: lsl     x9,     x19,   x28          // x9 = multiplier << time;     left shift multiplicand x times
        add     x21, x21, x9              // product += x9;               add the result to product
pronon:
        add     x28, x28, 1               // time ++;     Increse time by 1
        b       multiply_test                   // go back to multiplication loop test
       

multiply_end:


        
        ldr     x0,     =output
        mov     x1,     x19
        mov     x2,     x20
        mov     x3,     x21
        bl      printf


        // Go back to loop
        b       loop


end:


        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS
