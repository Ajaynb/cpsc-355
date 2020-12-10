        include(`macros.m4')

output:         .string "%d\n"
output_f:       .string "%f\n"
output_s:       .string "%s\n"
allstr:         .string "sp %d, fp %d\n"
output_init:    .string "tile index %d, tile value %f\n"

str_linebr:                     .string "\n"
str_enter_continue:             .string "press ENTER to continue..."
str_table_header:               .string "Board: \n\n"
str_tile_covered:               .string "·  "
str_tile_special_peek:          .string "   %c    "
str_tile_special:               .string "%c  "
str_tile_number_peek:           .string "%+6.2f  "
str_tile_number:                .string "%c  "
str_stats_peek_negatives:       .string "Total negatives: %d/%d (%d%%)\n"
str_stats_peek_specials:        .string "Total specials:  %d/%d (%d%%)\n"
str_play_lives:                 .string "Lives: %d	\n"
str_play_bombs:                 .string "Bombs: %d	(range: x%d)\n"
str_play_score:                 .string "Score: %.2f	\n"
str_play_total_score:           .string "Total: %.2f	\n"
str_result_header:              .string "Result: \n\n"
str_result_player:              .string "Player        %s\n"
str_result_total_score:         .string "Tiles score   %.2f pts\n"
str_result_left_bombs:          .string "Left bombs    %d\n"
str_result_left_lives:          .string "Left lives    %d\n"
str_result_duration:            .string "Duration      %lus\n"
str_result_final_score:         .string "Final score   %d pts\n"
str_enter_q:                    .string "Enter q to quit, \n"
str_bomb_position_ask:          .string "Enter bomb position (x y): "
str_bomb_position_input:        .string "%d %d"
str_player:                     .string "player"
str_log_filename:               .string "scores.log"
str_log_filemode_append:        .string "a"
str_log_filemode_read:          .string "r"
str_log_line:                   .string "%s %d %d\n"
str_result_win:                 .string "\nYou win\n"
str_result_die:                 .string "\nYou die\n"


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
        EXTRA_BOMB = '@'
        EXTRA_SCORE = '!'
        HEAVEN = '~'
        HELL = '#'

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
        * Define gaming board
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

        // Press ENTER to continue
        define(xenterContinue, `
                xprint(str_linebr)
                xprint(str_enter_continue)
                bl      getchar
                xprint(str_linebr)
                xprint(str_linebr)
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
        define(row, x20)
        define(column, x21)
        define(player, x22)
        define(argv, x23)

        // Set default values
        mov     row, MIN_ROW
        mov     column, MIN_COL
        ldr     player, =str_player

        // If command arguments contain row & col & player name
        cmp     x0, 4                                   // if (argc >= 4)
        b.ge    command_param                           // {read argument from command line}
        b       command_param_end                       // {do nothing}

        command_param:
                mov     argv, x1

                // Store row
                ldr     x0, [argv, 8]
                bl      atoi
                mov     row, x0

                // Store column
                ldr     x0, [argv, 16]
                bl      atoi
                mov     column, x0

                // Store column
                ldr     player, [argv, 24]
        command_param_end:

        
        // Rand seed
        xrandSeed()

        /*xprint(allstr, sp, fp)*/

        // Alloc for struct Play & struct Board
        xalloc(play_size_alloc)
        xalloc(board_size_alloc)

        /*xprint(allstr, sp, fp)*/

        xwriteStruct(row, board, board_row)
        xwriteStruct(column, board, board_column)
        xwriteStruct(player, play, play_player)


        // Alloc for array in struct Board
        xmul(board_array_size_alloc, MAX_ROW, MAX_COL, tile_size_alloc)
        xaddEqual(board_array_size_alloc, alloc)
        and     board_array_size_alloc, board_array_size_alloc, -16
        xalloc(board_array_size_alloc)


        // Initialize game
        // initializeGame(&board, &play);
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        bl      initializeGame

        // Peek game board before start
        // displayGame(&board, &play, true);
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        mov     x2,     TRUE
        bl      displayGame


        // Breaks for actual game
        xenterContinue()


        // Start game
        // startGame(&play);
        sub     x0,     fp,     play
        bl      startGame


        play_start:
                define(x, x27)
                define(y, x28)
                define(status, x26)
                
                // Display game board, normally
                // displayGame(&board, &play, true);
                sub     x0,     fp,     board
                sub     x1,     fp,     play
                mov     x2,     FALSE
                bl      displayGame

                // Ask for user input
                xprint(str_bomb_position_ask)
                xscan(str_bomb_position_input, x, y)

                // Play one round
                // playGame(&board, &play, x, y);
                sub     x0,     fp,     board
                sub     x1,     fp,     play
                mov     x2,     x
                mov     x3,     y
                bl      playGame

                // Line br
                xprint(str_linebr)
                xprint(str_linebr)

                // Get gamming status, if not gamming, then get out from loop
                xreadStruct(status, play, play_status)
                cmp     status, GAMING
                b.ne    play_end

                b       play_start
                undefine(`x')
                undefine(`y')
                undefine(`status')
        play_end:

        
        // Exit game
        // exitGame(&play);
        sub     x0,     fp,     play
        bl      exitGame
        
        xenterContinue()


        // Calculate gamming score
        // calculateScore(&board, &play);
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        bl      calculateScore
        
        // Log score
        // logScore(&play);
        sub     x0,     fp,     play
        bl      logScore


        // Display game board, normally
        // displayGame(&board, &play, true);
        sub     x0,     fp,     board
        sub     x1,     fp,     play
        mov     x2,     FALSE
        bl      displayGame

        
        define(status, x26)
        xreadStruct(status, play, play_status)
        cmp     status, WIN
        b.eq    play_result_win

        cmp     status, DIE
        b.eq    play_result_die

        b       play_result_end

        play_result_win:
                xprint(str_result_win)
                b       play_result_end

        play_result_die:
                xprint(str_result_die)
                b       play_result_end

        play_result_end:
        undefine(`status')
        

        xenterContinue()

        

        // Line br
        xprint(str_linebr)
        xprint(str_linebr)

        // Display result
        // displayResult(&play);
        sub     x0,     fp,     play
        bl      displayResult

        xenterContinue()


        // Line br
        xprint(str_linebr)
        xprint(str_linebr)

        // Dealloc for struct Play & struct Board and its array
        xdealloc(play_size_alloc)
        xdealloc(board_size_alloc)
        xdealloc(board_array_size_alloc)

        undefine(`board_array_size_alloc')
        undefine(`row')
        undefine(`column')
        undefine(`player')
        undefine(`argv')

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

        /*xprint(output, _board)*/
        /*xprint(output, _play)*/

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
        xwriteStruct(column, _board, board_column, true)

        // Calculate tiles
        mul     tiles, row, column

        // Set float zero
        define(`float_zero', d28)
        mov     x18, 0
        scvtf   float_zero, x18

        // Initialize statistics, giving default values
        xwriteStruct(tiles, _board, board_tiles, true)
        xwriteStruct(0, _board, board_negatives, true)
        xwriteStruct(0, _board, board_specials, true)
        xwriteStruct(3, _play, play_lives, true)
        xwriteStruct(float_zero, _play, play_score, true)
        xwriteStruct(float_zero, _play, play_total_score, true)
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

                // Read tile value
                xreadStruct(t_value, _tile, tile_value, true)

                // If the number is already negative, then skip
                fcmp    t_value, float_zero
                b.lt    initialize_flip_neg
                
                // Else flip the tile to negative
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
                fcmp    t_value, float_zero
                b.lt    initialize_flip_spe

                // Check if tile is already special
                mov     x17, 20
                scvtf   d17, x17
                fcmp    t_value, d17
                b.ge    initialize_flip_spe

                // Else pick a special
                // 1 ~ 40 = DOUBLE_RANGE
                // 41 ~ 45 = EXTRA_BOMB
                // 46 ~ 50 = EXTRA_SCORE
                // 51 = HEAVEN
                // 52 = HELL
                mov     x0, 1
                mov     x1, 52
                bl      randomNum

                // If random number is 1 ~ 6, then go to DOUBLE_RANGE
                cmp     x0, 40
                b.le    initialize_flip_spe_decide_double_range
                
                // If random number is 7, then go to EXTRA_BOMB
                cmp     x0, 45
                b.le    initialize_flip_spe_decide_extra_bomb

                // If random number is 8, then go to EXTRA_SCORE
                cmp     x0, 50
                b.le    initialize_flip_spe_decide_extra_score

                // If random number is 9, then go to EXTRA_BOMB
                cmp     x0, 51
                b.eq    initialize_flip_spe_decide_heaven

                // If random number is 10, then go to EXTRA_SCORE
                cmp     x0, 52
                b.eq    initialize_flip_spe_decide_hell


                // Else
                b       initialize_flip_spe_decide_end


                // DOUBLE_RANGE
                initialize_flip_spe_decide_double_range:
                        mov     x18, DOUBLE_RANGE
                        b       initialize_flip_spe_decide_end

                // EXTRA_BOMB
                initialize_flip_spe_decide_extra_bomb:
                        mov     x18, EXTRA_BOMB
                        b       initialize_flip_spe_decide_end

                // EXTRA_SCORE
                initialize_flip_spe_decide_extra_score:
                        mov     x18, EXTRA_SCORE
                        b       initialize_flip_spe_decide_end

                // HEAVEN
                initialize_flip_spe_decide_heaven:
                        mov     x18, HEAVEN
                        b       initialize_flip_spe_decide_end

                // HELL
                initialize_flip_spe_decide_hell:
                        mov     x18, HELL
                        b       initialize_flip_spe_decide_end

                initialize_flip_spe_decide_end:


                // And flip the tile into special
                scvtf   t_value, x18
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

                        // If tile is not covered
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
                define(range, x28)
                define(total_score, d27)
                
                // Read from struct Play* play
                xreadStruct(lives, _play, play_lives, true)
                xreadStruct(bombs, _play, play_bombs, true)
                xreadStruct(score, _play, play_score, true)
                xreadStruct(range, _play, play_range, true)
                xreadStruct(total_score, _play, play_total_score, true)

                // Print stats
                xprint(str_play_lives, lives)
                xprint(str_play_bombs, bombs, range)
                xprint(str_play_score, score)
                xprint(str_play_total_score, total_score)
        
                undefine(`lives')
                undefine(`bombs')
                undefine(`score')
                undefine(`range')
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
startGame:      // startGame(struct Play* play)
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
exitGame:       // exitGame(struct Play* play)
        xfunc()
        define(_play, x19)
        define(start_timestamp, x20)
        define(end_timestamp, x21)
        define(duration, x22)
        mov     _play, x0

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



/**
 * Display play result
 *
 * Just printing values. Nicely with text colors and formats.
 */
displayResult:  // displayResult(struct Play* play)
        xfunc()

        define(_play, x19)
        define(value, x20)
        define(value_float, d20)

        // Store struct Play* play pointer
        mov     _play, x0

        // Print header
        xprint(str_result_header)

        // Print player name
        xreadStruct(value, _play, play_player, true)
        xprint(str_result_player, value)

        // Print total tile score
        xreadStruct(value_float, _play, play_total_score, true)
        xprint(str_result_total_score, value_float)

        // Print left bombs
        xreadStruct(value, _play, play_bombs, true)
        xprint(str_result_left_bombs, value)
        
        // Print left lives
        xreadStruct(value, _play, play_lives, true)
        xprint(str_result_left_lives, value)
        
        // Print duration
        xreadStruct(value, _play, play_duration, true)
        xprint(str_result_duration, value)
        
        // Print final score
        xreadStruct(value, _play, play_final_score, true)
        xprint(str_result_final_score, value)


        undefine(`_play')
        undefine(`value')
        undefine(`value_float')

        xret()


/**
 * Calculate the final score of play
 *
 * It calculates a comprehensive score for the game.
 *
 * According to the formula, by doing the following would get a higher mark:
 * 1. Uncover more tiles
 * 2. Get higher uncover tile score (if at the end the score is negative, then probably the final score is negative too)
 * 3. Use less bombs to win
 * 4. Keep more lives to win
 * 5. Use less time to win
 */

calculateScore:        // calculateScore(struct Board* board, struct Play* play)
        xfunc()
        define(_board, x19)
        define(_play, x20)
        define(rate, d21)
        define(score, d22)
        define(time_deduct, d23)
        define(final_score, x24)
        
        // Store pointer of struct Table & struct Play
        mov     _board, x0
        mov     _play, x1

        // Calculate rate
        // float rate = 1.0 * play->uncovered_tiles / board->tiles;
        calculate_score_rate:
                define(uncovered_tiles, x25)
                define(tiles, x26)

                // Read stats from struct Play* play
                xreadStruct(uncovered_tiles, _play, play_uncovered_tiles, true)
                xreadStruct(tiles, _board, board_tiles, true)
                
                // Calculate portion of uncovered tiles
                scvtf   d18, uncovered_tiles
                scvtf   d17, tiles
                fdiv    rate, d18, d17

                undefine(`uncovered_tiles')
                undefine(`tiles')
        
        // Calculate score
        // float score = play->total_score * 20 + play->bombs * 33 + play->lives * 10;
        calculate_score_score:
                define(total_score, d25)
                define(bombs, x26)
                define(lives, x27)

                // Read stats from struct Play* play
                xreadStruct(total_score, _play, play_total_score, true)
                xreadStruct(bombs, _play, play_bombs, true)
                xreadStruct(lives, _play, play_lives, true)

                // Calculate portion of total score
                mov     x18, 20
                xaddEqual(x18, 1000)
                scvtf   d18, x18
                fmul    d16, total_score, d18
                fadd    score, score, d16

                // Calculate protion of bombs left
                mov     x18, 69
                scvtf   d17, bombs
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    score, score, d16
                
                // Calculate protion of lives left
                mov     x18, 69
                scvtf   d17, lives
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    score, score, d16
                
                undefine(`total_score')
                undefine(`bombs')
                undefine(`lives')
        

        // Calculate time deduct
        // float time_deduct = play->duration * 46;
        calculate_score_time_deduct:
                define(duration, x25)

                // Read stats from struct Play* play
                xreadStruct(duration, _play, play_duration, true)

                // Calculate protion of lives left
                mov     x18, 46
                scvtf   d17, duration
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    time_deduct, time_deduct, d16

                undefine(`duration')
        
        // Calculate final score
        // int final_score = rate * score - time_deduct;
        calculate_score_final_score:
                fmul    d18, rate, score
                fsub    d18, d18, time_deduct

                fcvtns  final_score, d18

        // Write final score to struct Play* play
        // play->final_score = final_score
        xwriteStruct(final_score, _play, play_final_score, true)


        undefine(`_board')
        undefine(`_play')
        undefine(`rate')
        undefine(`score')
        undefine(`time_deduct')
        undefine(`final_score')
        xret()



/**
 * Select position and place bomb.
 *
 * Only when the x and y values are within the board and the current status is gaming,
 * invalid x and y would be ignored and this round would be ignored. So no effect if user
 * accidently input incorrect value, everything (eg. double ranged bomb) will be saved
 * for the next time, always.
 *
 * Using for loop with range to uncover tiles.
 */

playGame:       // playGame(struct Board* board, struct Play* play, const int x, const int y)
        xfunc()
        
        define(_board, x19)
        define(_play, x20)
        define(x, x21)
        define(y, x22)
        define(range, x25)

        // Store pointer of struct Table & struct Play & x & y
        mov     _board, x0
        mov     _play, x1
        mov     x, x2
        mov     y, x3

        // Check both x and y values within the board and gaming status
        play_game_check_x_y:
                define(row, x23)
                define(column, x24)

                // Read from struct
                xreadStruct(row, _board, board_row, true)
                xreadStruct(column, _board, board_column, true)

                // Check range for x, if less than 0, then return
                cmp     x, 0
                b.lt    play_game_end

                // Check range for x, if greter or equal to row, then return
                cmp     x, row
                b.ge    play_game_end

                // Check range for y, if less than 0, then return
                cmp     y, 0
                b.lt    play_game_end

                // Check rnage for y, if greater or equal to column, then return
                cmp     y, column
                b.ge    play_game_end

                undefine(`row')
                undefine(`column')

        
        // Range max value protection
        // If the range is extremely big, when uncover tils, inefficient
        // Set the range value to the max size of board if exceeded
        play_game_range_control:
                // Read range value
                xreadStruct(range, _play, play_range, true)

                // Find larger max value and set max value of range
                xmax(x18, MAX_ROW, MAX_COL)
                xmin(range, range, x18)




        // Reset range and deduct bomb by one
        play_game_deduct:
                define(bombs, x23)

                // play->bombs --;
                xreadStruct(bombs, _play, play_bombs, true)
                xminusMinus(bombs)
                xwriteStruct(bombs, _play, play_bombs, true)

                // play->range = 1
                xwriteStruct(1, _play, play_range, true)

                undefine(`bombs')


        // Loop for uncover tiles
        play_game_uncover_tile:

                // Set value for t
                define(t, x23)
                define(r, x24)
                xmul(t, range, -1)

                // Loop for uncovering rows in range
                play_game_uncover_tile_row:
                        cmp     t, range
                        b.gt    play_game_uncover_tile_row_end

                        // Set value for r
                        xmul(r, range, -1)

                        // Loop for uncovering columns in range
                        play_game_uncover_tile_column:
                                cmp     r, range
                                b.gt    play_game_uncover_tile_column_end

                                
                                // Validate if the index is within valid range
                                play_game_uncover_tile_index_validate:
                                        // Define uncover index variable
                                        define(uncover_index, x28)
                                        define(uncover_x, x17)
                                        define(uncover_y, x18)
                                        define(column, x27)
                                        define(tiles, x16)
                                        define(_tile, x26)
                                        define(t_covered, x15)
                                        define(t_value, d20)

                                        // Read from struct Board* board
                                        xreadStruct(tiles, _board, board_tiles, true)
                                        xreadStruct(column, _board, board_column, true)

                                        // Calculate x and y of the tile to uncover
                                        xadd(uncover_x, x, t)   // int uncover_x = x + t;
                                        xadd(uncover_y, y, r)   // int uncover_y = y + r;

                                        // int index = (uncover_x * board->column) + uncover_y;
                                        madd    uncover_index, uncover_x, column, uncover_y


                                        // If index < 0, then it's invalid, do nothing
                                        cmp     uncover_index, 0
                                        b.lt    play_game_uncover_tile_index_validate_end

                                        // If index >= tiles, then it's invalid, do nothing
                                        cmp     uncover_index, tiles
                                        b.ge    play_game_uncover_tile_index_validate_end

                                        // If y of uncover tile < 0, then it's invalid, do nothing
                                        cmp     uncover_y, 0
                                        b.lt    play_game_uncover_tile_index_validate_end

                                        // If y of uncover tile >= column, then it's invalid, do nothing
                                        cmp     uncover_y, column
                                        b.ge    play_game_uncover_tile_index_validate_end
                                        
                                        // Get current tile pointer
                                        xtilePointer(_tile, _board, uncover_index)

                                        // If tile.covered == FALSE, then it's already uncovered, do nothing
                                        xreadStruct(t_covered, _tile, tile_covered, true)
                                        cmp     t_covered, FALSE
                                        b.eq    play_game_uncover_tile_index_validate_end

                                        // Uncover tile
                                        xwriteStruct(FALSE, _tile, tile_covered, true)

                                        // Increase uncovered tile amount
                                        // play->uncovered_tiles++;
                                        define(uncovered_tiles, x16)
                                        xreadStruct(uncovered_tiles, _play, play_uncovered_tiles, true)
                                        xaddAdd(uncovered_tiles)
                                        xwriteStruct(uncovered_tiles, _play, play_uncovered_tiles, true)
                                        undefine(`uncovered_tiles')


                                        // Read the tile value
                                        xreadStruct(t_value, _tile, tile_value, true)

                                        // Do different things when meet different tiles
                                        play_game_uncover_tile_value:
                                                
                                                // If the tile is EXIT
                                                ldr     x16, =EXIT
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_exit
                                                b       play_game_uncover_tile_value_exit_end
                                                
                                                play_game_uncover_tile_value_exit:
                                                        // Claim winning
                                                        xwriteStruct(WIN, _play, play_status, true)
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_exit_end:

                                                
                                                // If the tile is DOUBLE RANGE
                                                ldr     x16, =DOUBLE_RANGE
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_double_range
                                                b       play_game_uncover_tile_value_double_range_end
                                                
                                                play_game_uncover_tile_value_double_range:
                                                        // Increase range by 1
                                                        define(t_range, x17)

                                                        xreadStruct(t_range, _play, play_range, true)
                                                        xmulEqual(t_range, 2)
                                                        xwriteStruct(t_range, _play, play_range, true)

                                                        undefine(`t_range')
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_double_range_end:

                                                // If the tile is EXTRA BOMB
                                                ldr     x16, =EXTRA_BOMB
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_extra_bomb
                                                b       play_game_uncover_tile_value_extra_bomb_end
                                                
                                                play_game_uncover_tile_value_extra_bomb:
                                                        // Increase bombs by 2
                                                        define(t_bombs, x17)

                                                        xreadStruct(t_bombs, _play, play_bombs, true)
                                                        xaddEqual(t_bombs, 2)
                                                        xwriteStruct(t_bombs, _play, play_bombs, true)

                                                        undefine(`t_bombs')
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_extra_bomb_end:

                                
                                                // If the tile is EXTRA SCORE
                                                ldr     x16, =EXTRA_SCORE
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_extra_score
                                                b       play_game_uncover_tile_value_extra_score_end
                                                
                                                play_game_uncover_tile_value_extra_score:
                                                        // Increase score by 100
                                                        define(t_score, d17)

                                                        xreadStruct(t_score, _play, play_score, true)
                                                        mov     x18, 100
                                                        scvtf   d18, x18
                                                        fadd    t_score, t_score, d18
                                                        xwriteStruct(t_score, _play, play_score, true)

                                                        undefine(`t_score')
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_extra_score_end:

                                                
                                                // If the tile is HEAVEN
                                                ldr     x16, =HEAVEN
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_heaven
                                                b       play_game_uncover_tile_value_heaven_end
                                                
                                                play_game_uncover_tile_value_heaven:
                                                        // Die
                                                        xwriteStruct(DIE, _play, play_status, true)
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_heaven_end:

                                                
                                                // If the tile is HELL
                                                ldr     x16, =HELL
                                                scvtf   d16, x16
                                                fcmp    t_value, d16
                                                b.eq    play_game_uncover_tile_value_hell
                                                b       play_game_uncover_tile_value_hell_end
                                                
                                                play_game_uncover_tile_value_hell:
                                                        // Win
                                                        xwriteStruct(WIN, _play, play_status, true)
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_hell_end:



                                                // Else the tile is a number tile
                                                play_game_uncover_tile_value_number:
                                                        define(total_score, d17)
                                                        define(score, d16)
                                                        
                                                        // Read total score and increase by tile value, and write back
                                                        xreadStruct(total_score, _play, play_total_score, true)
                                                        fadd    total_score, total_score, t_value
                                                        xwriteStruct(total_score, _play, play_total_score, true)
                                                        
                                                        // Read score and increase by tile value, and write back
                                                        xreadStruct(score, _play, play_score, true)
                                                        fadd    score, score, t_value
                                                        xwriteStruct(score, _play, play_score, true)

                                                        undefine(`total_score')
                                                        undefine(`score')
                                                        b       play_game_uncover_tile_value_end

                                                
                                        play_game_uncover_tile_value_end:


                                        undefine(`uncover_index')
                                        undefine(`uncover_x')
                                        undefine(`uncover_y')
                                        undefine(`column')
                                        undefine(`tiles')
                                        undefine(`_tile')
                                        undefine(`t_covered')
                                        undefine(`t_value')
                                play_game_uncover_tile_index_validate_end:



                                // Increment & loop again
                                xaddAdd(r)
                                b       play_game_uncover_tile_column
                        play_game_uncover_tile_column_end:

                        // Increment & loop again
                        xaddAdd(t)
                        b       play_game_uncover_tile_row
                play_game_uncover_tile_row_end:

                undefine(`t')
                undefine(`r')
                undefine(`row')


        // If the current life score is negative number, then lose a life and reset the score.
        play_game_score_check:
                define(score, d18)
                define(lives, x26)

                // Set float zero
                define(`float_zero', d28)
                mov     x18, 0
                scvtf   float_zero, x18

                xreadStruct(score, _play, play_score, true)
                xreadStruct(lives, _play, play_lives, true)

                fcmp    score, float_zero
                b.lt    play_game_score_check_decrement
                b       play_game_score_check_decrement_end

                play_game_score_check_decrement:
                        // Decrease live and set score to 0
                        xminusMinus(lives)              // play->lives--;
                        fmov    score, float_zero       // play->score = 0;
                        
                        // Write back to struct
                        xwriteStruct(score, _play, play_score, true)
                        xwriteStruct(lives, _play, play_lives, true)
                play_game_score_check_decrement_end:
                
                undefine(`score')
                undefine(`lives')
                undefine(`float_zero')


        // If the player is running out of bombs, or lives, then die.
        // Also need to see if the game status is not win (from above), 
        // because there's possibility that player is winning this round 
        // but also run out of lives or bombs, but we're saying the player is winning.
        play_game_lives_bombs_check:
                define(status, x26)
                define(bombs, x27)
                define(lives, x28)

                // Read values from struct
                xreadStruct(status, _play, play_status, true)
                xreadStruct(bombs, _play, play_bombs, true)
                xreadStruct(lives, _play, play_lives, true)

                // If already win, then skip lose
                cmp     status, WIN
                b.eq    play_game_lives_bombs_check_lose_end

                // If bombs is less than 0, then lose
                cmp     bombs, 0
                b.le    play_game_lives_bombs_check_lose

                // If lives is less than 0, then lose
                cmp     lives, 0
                b.le    play_game_lives_bombs_check_lose

                // Otherwise, do nothing
                b       play_game_lives_bombs_check_lose_end

                play_game_lives_bombs_check_lose:
                        // Claim die
                        xwriteStruct(DIE, _play, play_status, true)     // play->status = DIE;
                play_game_lives_bombs_check_lose_end:


                undefine(`status')
                undefine(`bombs')
                undefine(`lives')
                


        // Function end
        play_game_end:

        undefine(`_board')
        undefine(`_play')
        undefine(`x')
        undefine(`y')
        undefine(`range')

        xret()



/**
 * Log the score to file
 *
 * Open the log file and append the score.
 */
logScore:       // void logScore(struct Play* play)
        xfunc()
        define(_play, x19)
        define(_file, x20)

        // Store pointer of struct Table & struct Play & x & y
        mov     _play, x0

        // Open log file
        ldr     x0, =str_log_filename
        ldr     x1, =str_log_filemode_append
        bl      fopen
        mov     _file, x0

        // Print to file
        mov     x0, _file
        ldr     x1, =str_log_line
        xreadStruct(x2, _play, play_player, true)
        xreadStruct(x3, _play, play_final_score, true)
        xreadStruct(x4, _play, play_duration, true)
        bl      fprintf

        // Close file
        mov     x0, _file
        bl      fclose

        undefine(`_play')
        undefine(`_file')
        xret()


/**
 * Display top scores.
 *
 * Using bubble sort. Sort and print top scores.
 */
displayTopScores:       // displayTopScores(int n)
        xfunc()
        define(n, x19)
        define(_file, x20)
        define(amount, x24)
        define(array, x25)

        // Store int n & set array pointer
        mov     n, x0
        mov     array, sp

        // Open log file
        ldr     x0, =str_log_filename
        ldr     x1, =str_log_filemode_read
        bl      fopen
        mov     _file, x0

        // Rewind file (set file position to the beginning)
        mov     x0, _file
        bl      rewind

        // Read one line from log file each time
        top_scores_read_line:
                define(player, x21)
                define(final_score, x22)
                define(duration, x23)
                define(isEOF, x28)
        
                // Read one line
                top_scores_read_line_one_line:
                        // Load file pointer & format string
                        mov     x0, _file
                        ldr     x1, =str_log_line

                        // Assign memory for read data
                        sub     sp, sp, 16
                        mov     x2, sp
                        sub     sp, sp, 16
                        mov     x3, sp
                        sub     sp, sp, 16
                        mov     x4, sp

                        // Invoke fscanf
                        bl      fscanf

                        // Store read data in memory to registers
                        ldr     duration, [sp]
                        add     sp, sp, 16
                        ldr     final_score, [sp]
                        add     sp, sp, 16
                        mov     player, sp
                        add     sp, sp, 16
                

                // Get EOF status
                mov     x0, _file
                bl      feof
                mov     isEOF, x0

                // If it is the end of file, then end the reading loop
                cmp     isEOF, TRUE
                b.eq    top_scores_read_line_end


                // Create struct Play
                top_scores_read_line_create_play:
                        xalloc(play_size_alloc)
                        define(_play, sp)
                        xaddAdd(amount)

                        /*xprint(allstr, sp, fp)
                        xprint(output, _play)*/

                        xwriteStruct(player, _play, play_player, true)
                        xwriteStruct(final_score, _play, play_final_score, true)
                        xwriteStruct(duration, _play, play_duration, true)

                        xprint(str_log_line, player, final_score, duration)

                        undefine(`_play')


                // Go back to loop top
                undefine(`player')
                undefine(`final_score')
                undefine(`duration')
                undefine(`isEOF')
                b       top_scores_read_line
        top_scores_read_line_end:

        // Close file
        mov     x0, _file
        bl      fclose


        // Bubble Sort
        define(t, x21)
        define(r, x22)
        mov     t, 0
        mov     r, 0
        xmin(n, n, amount)      // n = min(n, amount); If n exceeded the amount, protect
        top_scores_bubble_sort_row:
                // If meet amount, then end loop
                cmp     t, n
                b.ge    top_scores_bubble_sort_row_end

                // Reset r
                mov     r, 0
                top_scores_bubble_sort_row2:
                        // If meet amount, then end loop
                        cmp     r, n
                        b.ge    top_scores_bubble_sort_row2_end

                        // Calculate array offset
                        define(offset, x23)
                        xmul(offset, r, play_size, -1)
                        xaddEqual(offset, array)
                        /*xaddEqual(offset, play_size_alloc)*/
                        
                        // Read values
                        define(final_score, x24)
                        define(player, x25)
                        define(duration, x26)

                        xreadStruct(duration, offset, play_duration, true)
                        xprint(output, duration)
                        /*xprint(output, offset)*/
                        

                        

                        undefine(`offset')
                        undefine(`final_score')
                        undefine(`player')
                        undefine(`duration')

                        // Increment and loop again
                        xaddAdd(r)
                        b       top_scores_bubble_sort_row2
                top_scores_bubble_sort_row2_end:

                // Increment and loop again
                xaddAdd(t)
                b       top_scores_bubble_sort_row
        top_scores_bubble_sort_row_end:




        // Dealloc memory
        xmul(x18, play_size_alloc, amount)
        xdealloc(x18)

        undefine(`n')
        undefine(`_file')
        undefine(`amount')
        xret()
