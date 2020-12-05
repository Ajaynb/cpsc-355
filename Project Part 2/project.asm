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

        // m and n

        mov     x0,     min_til
        mov     x1,     max_til
        bl      randomNum

        xprint(output, x0)

        // m and n


        xret()


randomNum:      // randomNum(m, n)
        xfunc()

        // Renaming
        define(m, x19)
        define(n, x20)
        define(upper, x27)
        define(lower, x28)
        define(range, x21)
        define(quotient, x22)
        define(product, x23)
        define(remainder, x24)

        mov     m,      x0                              // int m;
        mov     n,      x1                              // int n;

        cmp     m,      n                               // if (m == n)
        b.eq    randomNum_end                           // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        xmax(upper, m, n)                               // int upper = max(m, n)
        xmin(lower, m, n)                               // int lower = min(m, n)

        // Calculate range
        sub     range,  upper,  lower                   // int range = upper - lower
        xaddAdd(range)                                  // range += 1;

        // Generate random number
        bl      rand

        // Limit range
        udiv    quotient,       x0,     range           // int quotient = rand / range;
        mul     product,        x22,    range           // int product = quotient * range
        sub     remainder,      x0,     product         // int remainder = rand - product

        mov     x0,     remainder                       // return the remainder as the generated random number
       

        undefine(m, x19)
        undefine(n, x20)
        undefine(upper, x27)
        undefine(lower, x28)
        undefine(range, x21)
        undefine(quotient, x22)
        undefine(product, x23)
        undefine(remainder, x24)

        randomNum_end:
        xret()

