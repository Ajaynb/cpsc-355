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

        mov     x0,     min_til
        mov     x1,     max_til
        bl      randomNum

        xprint(output, x0)


        xret()


randomNum:      // randomNum(m, n)
        xfunc()

        mov     x19,    x0                              // int m;
        mov     x20,    x1                              // int n;

        cmp     x19,    x20                             // if (m == n)
        b.eq    randomNum_end                           // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        xmax(x27, x19, x20)                             // int upper = max(m, n)
        xmin(x28, x19, x20)                             // int lower = min(m, n)

        // Calculate range
        sub     x21,    x27,    x28                     // int range = upper - lower
        xaddAdd(x21)                                    // range += 1;

        // Generate random number
        bl      rand

        // Limit range
        udiv    x22,    x0,     x21                     // int quotient = rand / range;
        mul     x23,    x22,    x21                     // int product = quotient * range
        sub     x24,    x0,     x23                     // int remainder = rand - product

        mov     x0,     x24                             // return the remainder as the generated random number
       
        randomNum_end:
        xret()

