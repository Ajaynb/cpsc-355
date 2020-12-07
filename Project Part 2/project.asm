        include(`macros.m4')

output:         .string "%d\n"
output_f:       .string "%f\n"
output_s:       .string "%c\n"
allstr:         .string "sp %d, fp %d\n"
output_init:    .string "tile index %d, tile value %f\n"

str_linebr:                     .string "\n"
str_table_header:               .string "Board: \n\n"
str_tile_covered:               .string "·  "
str_tile_special_peek:          .string "   %c    "
str_tile_special:               .string "%c  "
str_tile_number_peek:           .string "%+6.2f  "
str_tile_number:                .string "%c  "
str_stats_peek_negatives:       .string "Total negatives: %d/%d (%d%%)\n"
str_stats_peek_specials:        .string "Total specials:  %d/%d (%d%%)\n"
str_play_lives:                 .string "Lives: %d	\n"
str_play_bombs:                 .string "Bombs: %d	\n"
str_play_score:                 .string "Score: %.2f	\n"
str_play_total_score:           .string "Total: %.2f	\n"



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

        // Define number tiles type
        POSITIVE = '+'
        NEGATIVE = '-'

        // Define special tile types
        EXIT = '*'
        DOUBLE_RANGE = '$'

        // Define GAMING status
        PREPARE = 0
        GAMING = 1
        WIN = 2
        DIE = 3
        QUIT = 4

        // Boolean
        TRUE = 1
        FALSE = 0

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

        // Customized macro function to calculate array offset of struct Tile in struct Board
        // xtilePointer(destination, struct Board* board, index)
        define(xtilePointer, `
                xmul($1, $3, tile_size)
                xaddEqual($1, board_array)
                xmulEqual($1, -1)
                xaddEqual($1, $2)
        ')


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

        
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        mov     x2,     TRUE
        bl      displayGame

        
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        mov     x2,     FALSE
        bl      displayGame



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

        // Write new row & column back to struct Board* board
        xwriteStruct(row, _board, board_row, true)
        xwriteStruct(column, _board, board_row, true)

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
        define(_tile, x25)
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

                /*xprint(output_f, random_number)*/

                // Calculate and store the pointer of current struct Tile
                xtilePointer(_tile, _board, t)


                // Write to struct Tile
                xwriteStruct(random_number, _tile, tile_value, true)
                xwriteStruct(TRUE, _tile, tile_covered, true)
                
                xreadStruct(random_number, _tile, tile_value, true)

                // Increment and loop again
                xaddAdd(t)
                b       initialize_populate_row
        initialize_populate_row_end:
        undefine(`random_number')
        undefine(`_tile')
        


        // Flip to negative numbers
        define(_tile, x24)
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

                // Calculate and store the pointer of current struct Tile
                xtilePointer(_tile, _board, t_index)

                // Flip number to negative
                xreadStruct(t_value, _tile, tile_value, true)

                mov     x17, 0
                scvtf   d17, x17

                fcmp    t_value, d17
                b.lt    initialize_flip_neg

                mov     x17, -1
                scvtf   d17, x17
                fmul    t_value, t_value, d17
                xwriteStruct(t_value, _tile, tile_value, true)

                /*xprint(output_init, t_index, t_value)*/


                // Increase negatives amount in struct Board
                xaddAdd(negatives)
                xwriteStruct(negatives, _board, board_negatives, true)

                // Loop again
                b       initialize_flip_neg
        initialize_flip_neg_end:
        undefine(`_tile')
        undefine(`negatives')
        undefine(`max_negatives')
        undefine(`t_index')
        undefine(`t_value')



        // Flip to specials
        define(_tile, x24)
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
                
                // Calculate and store the pointer of current struct Tile
                xtilePointer(_tile, _board, t_index)

                // Read tile value
                xreadStruct(t_value, _tile, tile_value, true)

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
                xwriteStruct(t_value, _tile, tile_value, true)
                
                /*xprint(output_init, t_index, t_value)*/


                // Increase negatives amount in struct Board
                xaddAdd(specials)
                xwriteStruct(specials, _board, board_specials, true)

                /*xprint(output, specials)*/

                // Loop again
                b       initialize_flip_spe

        initialize_flip_spe_end:
        undefine(`_tile')
        undefine(`specials')
        undefine(`max_specials')
        undefine(`t_index')
        undefine(`t_value')



        // Generate Exit
        define(_tile, x24)
        define(t_index, x27)
        define(t_value, d18)
                initialize_flip_exit:
                // Pick a tile
                mov     x0, 0
                sub     x1, tiles, 1
                bl      randomNum
                mov     t_index, x0

                // Calculate and store the pointer of current struct Tile
                xtilePointer(_tile, _board, t_index)


                // Write value
                mov     x18, EXIT
                scvtf   t_value, x18
                xwriteStruct(t_value, _tile, tile_value, true)

                /*xprint(output_init, t_index, t_value)*/

                initialize_flip_exit_end:
        undefine(`_tile')
        undefine(`t_index')
        undefine(`t_value')
        

        undefine(`_board')
        undefine(`_play')
        undefine(`row')
        undefine(`column')
        undefine(`tiles')
        undefine(`t')

        xret()


/**
 * Display game
 *
 * Diaplay the board to the user.
 *
 * If the parameter peek is true, then show real tile values.
 * Otherwise, show tiles accordingly.
 *
 * Show relative statistics as well.
 */
displayGame:            // displayGame(struct Board* board, struct Play* play, bool peek)
        xfunc()

        define(_board, x19)
        define(_play, x20)
        define(peek, x21)
        define(row, x22)
        define(column, x23)

        // Store pointer of struct Table & struct Play & peek
        mov     _board, x0
        mov     _play, x1
        mov     peek, x2
        
        // Read row and column
        xreadStruct(row, _board, board_row, true)
        xreadStruct(column, _board, board_row, true)

        // Print a table header under peek mode
        cmp     peek, TRUE
        b.eq    display_header_peek
        b       display_header_peek_end
        display_header_peek:
                // Print table header
                xprint(str_table_header)
        display_header_peek_end:

        // Loop for displaying
        define(t, x24)
        define(r, x25)
        define(_tile, x26)
        define(t_value, d27)
        mov     t, 0
        mov     r, 0
        display_row:
                // Loop condition
                cmp     t, row
                b.ge    display_row_end
                
                mov     r, 0
                display_col:
                        // Loop condition
                        cmp     r, column
                        b.ge    display_col_end
                        
                        // Calculate and store the pointer of current struct Tile
                        xmul(x18, t, row)
                        xaddEqual(x18, r)
                        xtilePointer(_tile, _board, x18)

                        xreadStruct(x18, _tile, tile_covered, true)

                        // Read tile value
                        xreadStruct(t_value, _tile, tile_value, true)

                        // If tile is uncovered
                        cmp     x18, FALSE
                        b.eq    display_uncovered

                        // Else If is in peek mode
                        cmp     peek, TRUE
                        b.eq    display_uncovered

                        // Else
                        b       display_covered
                        
                        
                        // Uncovered tile
                        display_uncovered:

                                mov     x17, 20
                                scvtf   d17, x17
                                fcmp    t_value, d17
                                b.gt    display_uncovered_specials
                                b       display_uncovered_number

                                // Special tiles
                                display_uncovered_specials:
                                        // If is in peek mode
                                        cmp     peek, TRUE
                                        b.eq    display_uncovered_specials_peek
                                        b       display_uncovered_specials_normal

                                        // Peek mode display
                                        display_uncovered_specials_peek:
                                                // Print tile
                                                fcvtns  x27, d27
                                                xprint(str_tile_special_peek, x27)
                                        display_uncovered_specials_peek_end:
                                        b       display_uncovered_specials_normal_end
                                        
                                        // Normal mode display
                                        display_uncovered_specials_normal:
                                                // Print tile
                                                fcvtns  x27, d27
                                                xprint(str_tile_special, x27)
                                        display_uncovered_specials_normal_end:
                                        
                                display_uncovered_specials_end:
                                b       display_uncovered_number_end

                                // Number tile
                                display_uncovered_number:
                                        // If is in peek mode
                                        cmp     peek, TRUE
                                        b.eq    display_uncovered_number_peek
                                        b       display_uncovered_number_normal
                                        
                                        // Peek mode display
                                        display_uncovered_number_peek:
                                                // Print tile
                                                xprint(str_tile_number_peek, d27)
                                        display_uncovered_number_peek_end:
                                        b       display_uncovered_number_normal_end

                                        // Normal mode display
                                        display_uncovered_number_normal:
                                                // Print tile
                                                mov     x17, 0
                                                scvtf   d17, x17

                                                fcmp    t_value, d17
                                                b.gt    display_uncovered_number_normal_pos
                                                b       display_uncovered_number_normal_neg
                                                
                                                // Positive value
                                                display_uncovered_number_normal_pos:
                                                        // Print positive sign
                                                        xprint(str_tile_number, POSITIVE)
                                                display_uncovered_number_normal_pos_end:
                                                b       display_uncovered_number_normal_neg_end
                                                
                                                // Negative value
                                                display_uncovered_number_normal_neg:
                                                        // Print negative sign
                                                        xprint(str_tile_number, NEGATIVE)
                                                display_uncovered_number_normal_neg_end:

                                        display_uncovered_number_normal_end:

                                display_uncovered_number_end:


                        display_uncovered_end:
                        b       display_covered_end

                        // Covered tile
                        display_covered:
                                // Print tile covered
                                xprint(str_tile_covered)
                        display_covered_end:

                        
                        // Increment and loop again
                        xaddAdd(r)
                        b       display_col
                display_col_end:

                // Print line break
                xprint(str_linebr)

                // Increment and loop again
                xaddAdd(t)
                b       display_row
        display_row_end:
        
        undefine(`row')
        undefine(`column')
        undefine(`t')
        undefine(`r')
        undefine(`_tile')
        undefine(`t_value')


        // Print stats, accordingly
        cmp     peek, TRUE
        b.eq    display_stats_peek
        b       display_stats_normal

        // If peek, then print statistic of the board.
        display_stats_peek:
                define(negatives, x24)
                define(specials, x25)
                define(tiles, x26)
                define(percent, x27)

                // Read values
                xreadStruct(tiles, _board, board_tiles, true)
                xreadStruct(negatives, _board, board_negatives, true)
                xreadStruct(specials, _board, board_specials, true)

                // Calculate negatives percent
                xmul(x18, negatives, 100)
                udiv    percent, x18, tiles
                xprint(str_stats_peek_negatives, negatives, tiles, percent)

                // Calculate specials percent
                xmul(x18, specials, 100)
                udiv    percent, x18, tiles
                xprint(str_stats_peek_specials, specials, tiles, percent)

                undefine(`negatives')
                undefine(`specials')
                undefine(`tiles')
                undefine(`percent')
        display_stats_peek_end:
        b       display_stats_normal_end

        // Otherwise, print the current play statistics.
        display_stats_normal:
                define(lives, x24)
                define(bombs, x25)
                define(score, d26)
                define(total_score, d27)
                
                // Read from struct Play* play
                xreadStruct(lives, _play, play_lives, true)
                xreadStruct(bombs, _play, play_bombs, true)
                xreadStruct(score, _play, play_score, true)
                xreadStruct(total_score, _play, play_total_score, true)

                // Print stats
                xprint(str_play_lives, lives)
                xprint(str_play_bombs, bombs)
                xprint(str_play_score, score)
                xprint(str_play_total_score, total_score)
        
                undefine(`lives')
                undefine(`bombs')
                undefine(`score')
                undefine(`total_score')
        display_stats_normal_end:

        

        
        undefine(`_board')
        undefine(`_play')
        undefine(`peek')

        xret()


/**
 * Start game
 *
 * Record the start timestamp and set the status to gaming.
 */
startGame:
        xfunc()
        define(_play, x19)
        mov     _play, x0

        // Change play status to GAMING
        xwriteStruct(GAMING, _play, play_status, true)

        // Record start time
        mov     x0, 0
        bl      time
        xwriteStruct(x0, _play, play_start_timestamp, true)
        
        undefine(`_play')
        xret()


/**
 * Exit game
 *
 * Record end timestamp and calculate gaming duration.
 * Print user message.
 */
exitGame:
        xfunc()
        define(_play, x19)
        define(start_timestamp, x20)
        define(end_timestamp, x21)
        define(duration, x22)
        mov     _play, x0

        // Change play status to EXIT
        xwriteStruct(EXIT, _play, play_status, true)

        // Record end time
        mov     x0, 0
        bl      time
        xwriteStruct(x0, _play, play_end_timestamp, true)

        // Calculate duration
        xreadStruct(start_timestamp, _play, play_start_timestamp, true)
        xreadStruct(end_timestamp, _play, play_end_timestamp, true)
        sub     duration, end_timestamp, start_timestamp
        xwriteStruct(duration, _play, play_duration, true)
        
        undefine(`_play')
        undefine(`start_timestamp')
        undefine(`end_timestamp')
        undefine(`duration')
        xret()

