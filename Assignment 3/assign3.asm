
define(x_multiplier, x19)
define(x_multiplicand, x20)

main:                                                               // main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!                          // space stack pointer
        mov     x29,    sp                                          // frame-pointer = stack-pointer;

        // Set random seed
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0)); set random seed to current timestamp

multiply:
        


        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS
