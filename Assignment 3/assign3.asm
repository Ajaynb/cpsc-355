
define(x_er, x19)       // Multiplier
define(x_cand, x20)     // Multiplicand
define(x_prod, x21)     // Product
define(x_time, x28)    // Loop times

output: .string "%d * %d = %d\n"
testop:   .string "er %d, cand %d, prod %d\n"


        // Expose main function to OS
        .global main
        .balign 4

main:                                                               // main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!                          // space stack pointer
        mov     x29,    sp                                          // frame-pointer = stack-pointer;

        // Set random seed
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0)); set random seed to current timestamp

        mov     x_er,   5
        mov     x_cand, 5
        mov     x_prod, 0

multiply:
        mov     x_time, 0                       // loop times

test:   cmp     x_time, 64                      // Iterate 64 times
        b.ge    end


        // Least bit of cand
        asr     x10,    x_cand, x_time          // right shift multiplier by x times
        tst     x10,    0x1             // compare if the last digit is 1
        b.ne    proadd                          // If last bit is 1, flag is not set
        b       pronon

proadd: lsl     x9,     x_er,   x_time          // left shift multiplicand x times
        add     x_prod, x_prod, x9              // add the result to product
pronon:


        ldr     x0,     =testop
        mov     x1,     x_er
        mov     x2,     x_cand
        mov     x3,     x_prod
        bl      printf

        // increment on times and go back to loop test
        add     x_time, x_time, 1
        b       test


end:

        ldr     x0,     =output
        mov     x1,     x_er
        mov     x2,     x_cand
        mov     x3,     x_prod
        bl      printf

        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS
