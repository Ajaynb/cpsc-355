
// Define variable names with macro for readability
define(x_er, x19)                               // Multiplier, multipliER
define(x_cand, x20)                             // Multiplicand, multipliCAND
define(x_prod, x21)                             // Product, PRODuct
define(x_time, x28)                             // Loop times

output: .string "%d * %d = %d\n"                // The output string

        // Expose main function to OS and set balign
        .global main
        .balign 4



main:   // Main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!      // space stack pointer
        mov     x29,    sp                      // frame-pointer = stack-pointer;

        // Set random seed
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));      set random seed to current timestamp

        mov     x_er,   16                      // multiplier = 16;     set multiplier to 16



loop:   // The loop of multiplier from -15 to 15
        // Initialize values to default
        mov     x_cand, 0                       // multiplicand = 0;    set multiplicand to default 0
        mov     x_prod, 0                       // product = 0;         set product to 0
        
        // Decrease multiplier to the next value
        sub     x_er,   x_er,   1               // multiplier --;       decrese multiplier by 1

        // Loop condition
        cmp     x_er,   -15                     // if (multiplier < -15)
        b.lt    end                             // then end the whole loop, 15 to -15 finished

        // Generate a random number between 0 and 15
        bl      rand                            // rand();
        and  	x9,     x0,     0xF             // rand() % 16;         range 0 - 15
        mov     x_cand, x9                      // multiplicand = rand; set random number to multiplicand



        
mult:   // Multiplication
        mov     x_time, 0                       // time = 0;            loop times set to default 0

multst: // Loop condition, loop 64 times for 64 bits
        cmp     x_time, 64                      // if (time > 64);      if over 64 times
        b.ge    mulend                          // then end the multiplication loop


        // Least bit of cand
        asr     x10,    x_cand, x_time          // x10 = multiplicand >> time;  get xth least significant digit
        tst     x10,    0x1                     // if (x10 & 1)         if the least digit is 1
        b.ne    proadd                          // then should add the product
        b       pronon                          // otherwise not add

proadd: lsl     x9,     x_er,   x_time          // x9 = multiplier << time;     insert 0 to the right
        add     x_prod, x_prod, x9              // product += x9;       add the result to product
pronon:
        add     x_time, x_time, 1               // time ++;
        b       multst                          // go back to multiplication loop test

mulend: // Multiplication End



        // Output multiplier, multiplicand and their product
        ldr     x0,     =output                 // 1st parameter: the formatted string
        mov     x1,     x_er                    // 2nd parameter: the multiplier
        mov     x2,     x_cand                  // 3rd parameter: the multiplicand
        mov     x3,     x_prod                  // 4th parameter: the product
        bl      printf                          // printf(output, multiplier, multiplicand, product);


        // Continue loop
        b       loop                            // back to loop top



end:    // Program end
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
