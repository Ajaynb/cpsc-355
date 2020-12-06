        include(`macros.m4')

output: .string "%d\n"
allstr:         .string "sp %d, fp %d\n"


        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Define minimum row and column, avoid magic numbers
        min_row = 10
        min_col = 10
        min_til = 1
        max_til = 1500

        // Define negatives and specials percentage, avoid magic numbers
        neg_percent = 40
        spe_percent = 20

        // Define special tile types
        exit = 20
        double_range = 21

        // Define gaming status
        prepare = 0
        gaming = 1
        win = 2
        die = 3
        quit = 4

        /**
        * Define gaming tile
        *
        * The gaming tile contains the tile value and its covered status.
        */
        tile = 0
        tile_value = 0
        tile_covered = 8
        tile_size_alloc = -16 & -16
        tile_size = -tile_size_alloc
        
        /**
        * Define gaming board
        *
        * The game board contains all the tiles and relative informations.
        */
        board = -alloc + 0
        board_row = 0
        board_column = 8
        board_tiles = 16
        board_negatives = 24
        board_specials = 32
        board_array = 40
        board_size_alloc = -(40) & -16
        board_size = -board_size_alloc


        // Expose main function to OS and set balign
        .global main
        .balign 4

        
/**
 * Main function
 */
main:   // main()
        xfunc()
        
        // Rand seed
        xrandSeed()

        xprint(allstr, sp, fp)

        // Alloc for struct Board
        xalloc(board_size_alloc)

        xprint(allstr, sp, fp)


        xwriteStruct(5, board, board_row)
        xwriteStruct(5, board, board_column)

        add     x0, fp, board
        bl      initializeGame


        // Dealloc for struct Board
        xdealloc(board_size_alloc)
        xret()


/**
* Generate random number between the given range, inclusive.
*
* Firstly, get the smallest 2^x number that is larger than the upper bound,
* and then use this number by and operation and get the remainder.
* The remainder is the temporary number, then check if the remainder falls within the bounds.
* If falls winthin, then return. Otherwise, generate another one, until satisfied.
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


        undefine(m, x19)
        undefine(n, x20)
        undefine(upper, x27)
        undefine(lower, x28)
        undefine(range, x21)
        undefine(modular, x22)
        undefine(remainder, x23)

        randomNum_end:
        xret()



/**
 * Initialize the game board and play
 *
 * Firstly, populate all the tiles with positive random numbers.
 * Then, calculate how many negative tiles are needed and
 * flip that number of tiles. By fliping, simply multiply -1.
 * Thirdly, flip tiles to special tiles. Simply assign new value.
 *
 * The board->array, the tile array, is a 1-d array, but used as a 2-d.
 * Simply convert between 1-d array index to x and y by math.
 */

 initializeGame:        // initializeGame(struct Board* board, struct Play* play)
        xfunc()

        define(pointer, x19)
        define(row, x20)
        define(column, x21)
        define(tiles, x22)

        
        // Store pointer of struct Table
        mov     pointer, x0

        // Read row and column
        xreadStruct(row, pointer, board_row, true)
        xreadStruct(column, pointer, board_row, true)

        // Ensure the board is at least the minimum size
        xmax(row, row, min_row)
        xmax(column, column, min_col)

        // Intialize array by allocating memory
        mul     tiles, row, column
        xmul(x18, tiles, tile_size_alloc)
        and     x18, x18, -16

        xprint(output, x18)

        

        undefine(pointer, x19)
        undefine(row, x20)
        undefine(column, x21)
        undefine(tiles, x22)


        xret()
