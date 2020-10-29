
       // Multiplier
     // Multiplicand
     // Product
    // Loop times

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

        mov     x19,   4
        mov     x20, 3
        mov     x21, 0

multiply:
        mov     x28, 0                       // loop times

test:   cmp     x28, 64                      // Iterate 64 times
        b.ge    end


        // Least bit of cand
        asr     x11,    x20, x28          // right shift multiplier by x times
        ands    x10,    x11,    0x1             // compare if the last digit is 1
        b.ne    proadd                          // If last bit is 1
        b       pronon

proadd: lsl     x9,     x19,   x28          // left shift multiplicand x times
        add     x21, x21, x9              // add the result to product
pronon:


        ldr     x0,     =testop
        mov     x1,     x19
        mov     x2,     x20
        mov     x3,     x21
        bl      printf

        // increment on times and go back to loop test
        add     x28, x28, 1
        b       test


end:

        ldr     x0,     =output
        mov     x1,     x19
        mov     x2,     x20
        mov     x3,     x21
        bl      printf

        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS
