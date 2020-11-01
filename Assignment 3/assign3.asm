
// Define variable names with macro for readability
define(x_er, x19)                               // Multiplier, multipliER
define(x_cand, x20)                             // Multiplicand, multipliCAND
define(x_prod, x21)                             // Product, PRODuct
define(x_time, x28)                             // Loop times

outstr: .string "%d * %d = %d\n"                // The output string

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

        mov     x_er,   16                      // multiplier = 16;     set multiplier to 16, 
                                                // so every time the loop decrese it by 1 until it reaches -15 and end



loop:   // The loop of multiplier from -15 to 15
        // Initialize values to default
        mov     x_cand, 0                       // multiplicand = 0;    set multiplicand to default 0
        mov     x_prod, 0                       // product = 0;         set product to 0
        
        // Decrease multiplier to the next value
        sub     x_er,   x_er,   1               // multiplier --;       decrese multiplier by 1

        // Loop condition
        cmp     x_er,   -15                     // if (multiplier < -15)
        b.lt    end                             // then loop is end, 15 to -15 finished, end the program

        // Generate a random number between 0 and 15
        bl      rand                            // rand();
        and  	x9,     x0,     0xF             // int rand = rand() & 15;  range from 0 - 15
        mov     x_cand, x9                      // multiplicand = rand; set random number to multiplicand



mult:   // Multiplication Algorithm
        mov     x_time, 0                       // time = 0;            loop times set to default 0

multst: // Loop condition, loop 64 times for 64 bits
        cmp     x_time, 64                      // if (time >= 64);      if loop reaches 64 times
        b.ge    mulend                          // then end the multiplication loop

        // Least bit of cand
        asr     x10,    x_cand, x_time          // int leastBit = multiplicand >> time; get xth least significant digit
        
        // If: the least significant digit is not 0
        tst     x10,    0x1                     // if (!leastBit & 1)  if the least bit is not 0
        b.ne    proadd                          // then should add the product
        b       pronon                          // otherwise not add

                                                // The above is EQUIVALENT to (least significant bit * multiplicand) in the assignment specification, 
                                                // because the least sign bit is either 1 or 0, if it's 1 then it's adding multiplier itself,
                                                // if it's 0 then it's adding nothing. so the if condition just helps skipping adding 0 to the product

proadd: // Then: add multiplier to product
        lsl     x9,     x_er,   x_time          // int shifted = multiplier << time;    shifting the multiplier to left by x times
        add     x_prod, x_prod, x9              // product += shifted;  add the result to product
pronon: // Else: nothing

        // Adding loop times and continue loop
        add     x_time, x_time, 1               // time ++;
        b       multst                          // go back to multiplication loop test

mulend: // Multiplication Algorithm End



output: // outstr multiplier, multiplicand and their product
        ldr     x0,     =outstr                 // 1st parameter: the formatted string
        mov     x1,     x_er                    // 2nd parameter: the multiplier
        mov     x2,     x_cand                  // 3rd parameter: the multiplicand
        mov     x3,     x_prod                  // 4th parameter: the product
        bl      printf                          // printf(outstr, multiplier, multiplicand, product);


        // Continue loop
        b       loop                            // back to loop top



end:    // Program end
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
