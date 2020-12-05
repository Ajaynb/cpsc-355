        include(`macros.m4')

output: .string "%d\n"

        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Mins and Maxs
        min_row = 10
        min_col = 10
        max_row = 160
        max_col = 150
        min_til = 1
        max_til = 1500

        // Tile distributions
        neg_percent = 40
        spe_percent = 20

        // Tiles
        exit = 20
        double_range = 21

        // Game status
        prepare = 0
        gaming = 1
        win = 2
        die = 3
        quit = 4

        // Struct for Tile
        tile = 0
        tile_value = 0
        tile_covered = 8
        tile_size = (16) & 16
        tile_size_alloc = -tile_size
        
        // Struct for Board
        board = -alloc + 0
        board_row = 0
        board_column = 8
        board_tiles = 16
        board_negatives = 24
        board_specials = 32
        board_array = 40
        board_size = (40 + max_row * max_col * tile_size) & 16
        board_size_alloc = -board_size




        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // main()
        xfunc()

        
        // Rand seed
        xrandSeed()

        mov     x0,     min_til
        mov     x1,     max_til
        bl      randomNum

        xprint(output, x0)


        xret()


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

                xprint(output, modular)

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


        undefine(m, x19)
        undefine(n, x20)
        undefine(upper, x27)
        undefine(lower, x28)
        undefine(range, x21)
        undefine(modular, x22)
        undefine(remainder, x23)

        randomNum_end:
        xret()

