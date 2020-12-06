        include(`macros.m4')

output:         .string "%d\n"
output_f:       .string "%f\n"
allstr:         .string "sp %d, fp %d\n"
output_init:    .string "tile index %d, tile value %f\n"


        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc
        save_base = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Define minimum row and column, avoid magic numbers
        MIN_ROW = 10
        MIN_COL = 10
        MAX_ROW = 200
        MAX_COL = 200
        MIN_TIL = 1
        MAX_TIL = 1500

        // Define negatives and specials percentage, avoid magic numbers
        NEG_PERCENT = 40
        SPE_PERCENT = 20

        // Define special tile types
        EXIT = 20
        DOUBLE_RANGE = 21

        // Define GAMING status
        PREPARE = 0
        GAMING = 1
        WIN = 2
        DIE = 3
        QUIT = 4

        /**
        * Define GAMING tile
        *
        * The GAMING tile contains the tile value and its covered status.
        */
        tile = 0
        tile_value = 0
        tile_covered = 8
        tile_size_alloc = -16 & -16
        tile_size = -tile_size_alloc

        /**
        * Define gaming play
        *
        * The gaming play contains the playing status of the current player.
        * This is different from gaming board.
        * It is also used to sort top scores, as the read data would all put into
        * this Play objects.
        */
        play = save_base
        play_player = 0
        play_lives = 8
        play_score = 16
        play_total_score = 24
        play_bombs = 32
        play_range = 40
        play_status = 48
        play_start_timestamp = 56
        play_end_timestamp = 64
        play_duration = 72
        play_uncovered_tiles = 80
        play_final_score = 88
        play_size_alloc = -(play_final_score + 8) & -16
        play_size = -play_size_alloc
        
        /**
        * Define GAMING board
        *
        * The game board contains all the tiles and relative informations.
        */
        board = play + play_size
        board_row = 0
        board_column = 8
        board_tiles = 16
        board_negatives = 24
        board_specials = 32
        board_size_alloc = -(40) & -16
        board_size = -board_size_alloc
        board_array = board_size


        // Expose main function to OS and set balign
        .global main
        .balign 4

        
/**
 * Main function
 */
main:   // main()
        xfunc()

        define(board_array_size_alloc, x19)
        
        // Rand seed
        xrandSeed()

        xprint(allstr, sp, fp)

        // Alloc for struct Play & struct Board
        xalloc(play_size_alloc)
        xalloc(board_size_alloc)

        xprint(allstr, sp, fp)

        xwriteStruct(5, board, board_row)
        xwriteStruct(5, board, board_column)


        // Alloc for array in struct Board
        xmul(board_array_size_alloc, MAX_ROW, MAX_COL, tile_size_alloc)
        xaddEqual(board_array_size_alloc, alloc)
        and     board_array_size_alloc, board_array_size_alloc, -16
        xalloc(board_array_size_alloc)

        xprint(allstr, sp, fp)


        xprint(output, board_array_size_alloc)


        sub     x0,     fp,     board
        sub     x1,     fp,     play
        bl      initializeGame



        // Dealloc for struct Play & struct Board and its array
        xdealloc(play_size_alloc)
        xdealloc(board_size_alloc)
        xdealloc(board_array_size_alloc)

        undefine(`board_array_size_alloc')

        xret()


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

        define(_board, x19)
        define(_play, x20)
        define(row, x21)
        define(column, x22)
        define(tiles, x23)
        define(t, x24)

        
        // Store pointer of struct Table & struct Play
        mov     _board, x0
        mov     _play, x1

        xprint(output, _board)
        xprint(output, _play)

        // Read row and column
        xreadStruct(row, _board, board_row, true)
        xreadStruct(column, _board, board_row, true)

        // Ensure the board is within the acceptable size
        xmax(row, row, MIN_ROW)
        xmax(column, column, MIN_COL)
        xmin(row, row, MAX_ROW)
        xmin(column, column, MAX_COL)

        // Calculate tiles
        mul     tiles, row, column

        // Initialize statistics, giving default values
        xwriteStruct(tiles, _board, board_tiles, true)
        xwriteStruct(0, _board, board_negatives, true)
        xwriteStruct(0, _board, board_specials, true)
        xwriteStruct(3, _play, play_lives, true)
        xwriteStruct(0, _play, play_score, true)
        xwriteStruct(0, _play, play_total_score, true)
        xwriteStruct(5, _play, play_bombs, true)
        xwriteStruct(1, _play, play_range, true)
        xwriteStruct(0, _play, play_uncovered_tiles, true)
        xwriteStruct(PREPARE, _play, play_status, true)

        // Populate board with random positive values
        define(random_number, d18)
        define(array_offset, x25)
        mov     t, 0
        initialize_populate_row:
                // Loop condition
                cmp     t, tiles
                b.ge    initialize_populate_row_end
                
                // Generate random number
                mov     x0, MIN_TIL
                mov     x1, MAX_TIL
                bl      randomNum

                // Convert random number and divide by 100
                mov     x1, 100
                scvtf   d0, x0
                scvtf   d1, x1
                fdiv    random_number, d0, d1

                xprint(output_f, random_number)

                // Calculate array offset for current struct Tile (This calculation is an exception, it runs backwards)
                xmul(array_offset, t, tile_size)
                xaddEqual(array_offset, board_array)
                xmul(array_offset, array_offset, -1)
                xaddEqual(array_offset, _board)

                // Write to struct Tile
                xwriteStruct(random_number, array_offset, tile_value, true)
                xwriteStruct(1, array_offset, tile_covered, true)
                
                xreadStruct(random_number, array_offset, tile_value, true)

                // Increment and loop again
                xaddAdd(t)
                b       initialize_populate_row
        initialize_populate_row_end:
        undefine(`random_number')
        undefine(`array_offset')
        


        // Flip to negative numbers
        define(array_offset, x24)
        define(negatives, x25)
        define(max_negatives, x26)
        define(t_index, x27)
        define(t_value, d18)
        
        // Calculate max amount of negatives
        xmul(max_negatives, tiles, NEG_PERCENT)
        mov     x18, 100
        udiv    max_negatives, max_negatives, x18

        initialize_flip_neg:
                // Loop condition
                xreadStruct(negatives, _board, board_negatives, true)
                cmp     negatives, max_negatives
                b.ge    initialize_flip_neg_end

                mov     x0, 0
                sub     x1, tiles, 1
                bl      randomNum
                mov     t_index, x0

                // Calculate array offset for current struct Tile (This calculation is an exception, it runs backwards)
                xmul(array_offset, t_index, tile_size)
                xaddEqual(array_offset, board_array)
                xmul(array_offset, array_offset, -1)
                xaddEqual(array_offset, _board)

                // Flip number to negative
                xreadStruct(t_value, array_offset, tile_value, true)

                mov     x17, 0
                scvtf   d17, x17

                fcmp    t_value, d17
                b.lt    initialize_flip_neg

                mov     x17, -1
                scvtf   d17, x17
                fmul    t_value, t_value, d17
                xwriteStruct(t_value, array_offset, tile_value, true)

                xprint(output_init, t_index, t_value)


                // Increase negatives amount in struct Board
                xaddAdd(negatives)
                xwriteStruct(negatives, _board, board_negatives, true)

                // Loop again
                b       initialize_flip_neg
        initialize_flip_neg_end:
        undefine(`array_offset')
        undefine(`negatives')
        undefine(`max_negatives')
        undefine(`t_index')
        undefine(`t_value')



        // Flip to specials
        define(array_offset, x24)
        define(specials, x25)
        define(max_specials, x26)
        define(t_index, x27)
        define(t_value, d18)

        // Calculate max amount of specials
        xmul(max_specials, tiles, SPE_PERCENT)
        mov     x18, 100
        udiv    max_specials, max_specials, x18

        initialize_flip_spe:
                // Loop condition
                xreadStruct(specials, _board, board_specials, true)
                cmp     specials, max_specials
                b.ge    initialize_flip_spe_end

                mov     x0, 0
                sub     x1, tiles, 1
                bl      randomNum
                mov     t_index, x0
                
                // Calculate array offset for current struct Tile (This calculation is an exception, it runs backwards)
                xmul(array_offset, t_index, tile_size)
                xaddEqual(array_offset, board_array)
                xmul(array_offset, array_offset, -1)
                xaddEqual(array_offset, _board)

                // Read tile value
                xreadStruct(t_value, array_offset, tile_value, true)

                // Check if tile is already negative
                mov     x17, 0
                scvtf   d17, x17
                fcmp    t_value, d17
                b.lt    initialize_flip_spe

                // Check if tile is already special
                mov     x17, 20
                scvtf   d17, x17
                fcmp    t_value, d17
                b.ge    initialize_flip_spe

                // Pick a special
                mov     x0, DOUBLE_RANGE
                mov     x1, DOUBLE_RANGE
                bl      randomNum
                mov     x18, x0
                scvtf   t_value, x18

                // Flip the tile into special
                xwriteStruct(t_value, array_offset, tile_value, true)
                
                xprint(output_init, t_index, t_value)


                // Increase negatives amount in struct Board
                xaddAdd(specials)
                xwriteStruct(specials, _board, board_specials, true)

                xprint(output, specials)

                // Loop again
                b       initialize_flip_spe

        initialize_flip_spe_end:
        undefine(`array_offset')
        undefine(`specials')
        undefine(`max_specials')
        undefine(`t_index')
        undefine(`t_value')



        // Generate Exit
        define(array_offset, x24)
        define(t_index, x27)
        define(t_value, d18)
                initialize_flip_exit:
                // Pick a tile
                mov     x0, 0
                sub     x1, tiles, 1
                bl      randomNum
                mov     t_index, x0

                // Calculate array offset for current struct Tile (This calculation is an exception, it runs backwards)
                xmul(array_offset, t_index, tile_size)
                xaddEqual(array_offset, board_array)
                xmul(array_offset, array_offset, -1)
                xaddEqual(array_offset, _board)

                // Write value
                mov     x18, EXIT
                scvtf   t_value, x18
                xwriteStruct(t_value, array_offset, tile_value, true)

                xprint(output_init, t_index, t_value)
                
                initialize_flip_exit_end:
        undefine(`array_offset')
        undefine(`t_index')
        undefine(`t_value')
        

        undefine(`_board')
        undefine(`_play')
        undefine(`row')
        undefine(`column')
        undefine(`tiles')
        undefine(`t')


        xret()
