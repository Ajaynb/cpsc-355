        include(`macros.m4')
        
        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc

        .balign 4
        .global     randomNum

/**
* Generate random number between the given range, inclusive.
*
* Firstly, get the smallest 2^x number that is larger than the upper bound,
* and then use this number by and operation and get the remainder.
* The remainder is the temporary number, then check if the remainder falls within the bounds.
* If falls WINthin, then return. Otherwise, generate another one, until satisfied.
*/
randomNum:      // randomNum(m, n)
        xfunc()

        // Renaming
        define(m, x19)
        define(n, x20)
        define(upper, x27)
        define(lower, x28)
        define(range, x21)
        define(modular, x22)
        define(remainder, x23)

        mov     m, x0                                   // int m;
        mov     n, x1                                   // int n;

        cmp     m, n                                    // if (m == n)
        b.eq    randomNum_end                           // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        xmax(upper, m, n)                               // int upper = max(m, n)
        xmin(lower, m, n)                               // int lower = min(m, n)

        
        // Calculate range
        sub     range, upper, lower                     // int range = upper - lower

        // Get the smallest 2^x larger than range
        mov     modular, 1
        rand_modular_shift:
                cmp     range, modular
                b.lt    rand_modular_shift_end

                lsl     modular, modular, 1

                b       rand_modular_shift
        rand_modular_shift_end:


        // Generate random number, generate until within the bounds
        mov     remainder, -1
        rand_generate_number:
                // Generate random number
                bl      rand

                // Arithmetically limit the range of random number
                mov     x18, x0
                sub     x17, modular, 1
                and     remainder, x18, x17
                xaddEqual(remainder, lower)

                // If smaller than lower, regenerate
                cmp     remainder, lower
                b.lt    rand_generate_number

                // If greater than upper, regenerate
                cmp     remainder, upper
                b.gt    rand_generate_number

        rand_generate_number_end:


        mov     x0, remainder


        undefine(`m')
        undefine(`n')
        undefine(`upper')
        undefine(`lower')
        undefine(`range')
        undefine(`modular')
        undefine(`remainder')

        randomNum_end:
        xret()

