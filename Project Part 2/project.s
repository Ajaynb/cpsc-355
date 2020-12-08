        

output:         .string "%d\n"
output_f:       .string "%f\n"
output_s:       .string "%c\n"
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
str_play_bombs:                 .string "Bombs: %d	\n"
str_play_score:                 .string "Score: %.2f	\n"
str_play_total_score:           .string "Total: %.2f	\n"
str_result_header:              .string "Result: \n\n"
str_result_player:              .string "Player        %s\n"
str_result_total_score:          .string "Tiles score   %.2f pts\n"
str_result_left_bombs:          .string "Left bombs    %d\n"
str_result_left_lives:          .string "Left lives    %d\n"
str_result_duration:            .string "Duration      %lu s\n"
str_result_final_score:         .string "Final score   %d pts\n"
str_enter_q:                    .string "Enter q to quit, \n"
str_bomb_position_ask:          .string "Enter bomb position (x y): "
str_bomb_position_input:        .string "%d %d"



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
        

        // Expose main function to OS and set balign
        .global main
        .balign 4

        
/**
 * Main function
 */
main:   // main()
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        
        
        // Rand seed
        
        // M4: RAND SEED
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));


        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    sp
                
            

            
        
            
            
            
                mov     x2,    fp
                
            

            
        

        ldr     x0,     =allstr
        bl      printf
*/

        // Alloc for struct Play & struct Board
        
        // M4: ALLOC
        add     sp,     sp,     play_size_alloc              // allocate on SP

        
        // M4: ALLOC
        add     sp,     sp,     board_size_alloc              // allocate on SP


        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    sp
                
            

            
        
            
            
            
                mov     x2,    fp
                
            

            
        

        ldr     x0,     =allstr
        bl      printf
*/

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    board                      // int base (positive)
                mov     x12,    board_row                      // int attribute offset (positive)
                add     x9,     x11,    x12             // int offset = base + attribute (positive)
                sub     x9,     xzr,    x9              // offset = -offset (negative)
                mov    x10,    10           // float value

                str	x10,    [fp,   x9]   // offset += fp (negative + negative)
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    board                      // int base (positive)
                mov     x12,    board_column                      // int attribute offset (positive)
                add     x9,     x11,    x12             // int offset = base + attribute (positive)
                sub     x9,     xzr,    x9              // offset = -offset (negative)
                mov    x10,    10           // float value

                str	x10,    [fp,   x9]   // offset += fp (negative + negative)
        



        // Alloc for array in struct Board
        
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    MAX_ROW                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    MAX_COL                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size_alloc                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x19,     x9                      // result

        
        // M4: ADD EQUAL
        add     x19, x19, alloc

        and     x19, x19, -16
        
        // M4: ALLOC
        add     sp,     sp,     x19              // allocate on SP


        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    sp
                
            

            
        
            
            
            
                mov     x2,    fp
                
            

            
        

        ldr     x0,     =allstr
        bl      printf
*/
        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x19
                
            

            
        

        ldr     x0,     =output
        bl      printf
*/

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
        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_enter_continue
        bl      printf

        bl      getchar
        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf



        play_start:
                // Play one round
                // playGame(&board, &play, x, y);
                sub     x0,     fp,     board
                sub     x1,     fp,     play
                mov     x2,     5
                mov     x3,     5
                bl      playGame

                
                // Peek game board before start
                // displayGame(&board, &play, true);
                sub     x0,     fp,     board
                sub     x1,     fp,     play
                mov     x2,     FALSE
                bl      displayGame


                // Breaks for actual game
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_enter_continue
        bl      printf

                bl      getchar
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf


                // b       play_start
                
        // M4: SCAN
        ldr     x0,     =str_bomb_position_input                     // 1st parameter: scnocc, the formatted string

        
            
                sub     sp, sp, 16
                mov     x1, sp
            
        
            
                sub     sp, sp, 16
                mov     x2, sp
            
        
        
        bl      scanf                           // scanf(string, &pointer);

        
            ldr     x17, [sp]
            add     sp, sp, 16
        
            ldr     x18, [sp]
            add     sp, sp, 16
        

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x18
                
            

            
        
            
            
            
                mov     x2,    x17
                
            

            
        

        ldr     x0,     =str_bomb_position_input
        bl      printf


        play_end:
        

        // Dealloc for struct Play & struct Board and its array
        
        // M4: DEALLOC
        mov     x9,     play_size_alloc                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP

        
        // M4: DEALLOC
        mov     x9,     board_size_alloc                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP

        
        // M4: DEALLOC
        mov     x9,     x19                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP


        

        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret





/**
* Generate random number between the given range, inclusive.
*
* Firstly, get the smallest 2^x number that is larger than the upper bound,
* and then use this number by and operation and get the remainder.
* The remainder is the temporary number, then check if the remainder falls within the bounds.
* If falls WINthin, then return. Otherwise, generate another one, until satisfied.
*/
randomNum:      // randomNum(m, n)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        // Renaming
        
        
        
        
        
        
        

        mov     x19, x0                                   // int x19;
        mov     x20, x1                                   // int x20;

        cmp     x19, x20                                    // if (x19 == x20)
        b.eq    randomNum_end                           // {skip everything to the end}, to return x19 itself

        // For protection, check again the x28 and x27 bound
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    x20
        // csel    x27,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_0
        b       else_0

        if_0:  mov     x27,     x9
                b       end_0
        else_0:mov     x27,     x10
                b       end_0
        end_0:

        
        
        
                               // int x27 = max(x19, x20)
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    x20
        // csel    x28,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_1
        b       else_1

        if_1:  mov     x28,     x9
                b       end_1
        else_1:mov     x28,     x10
                b       end_1
        end_1:

        
        
        
                               // int x28 = min(x19, x20)

        
        // Calculate x21
        sub     x21, x27, x28                     // int x21 = x27 - x28

        // Get the smallest 2^x larger than x21
        mov     x22, 1
        rand_modular_shift:
                cmp     x21, x22
                b.lt    rand_modular_shift_end

                lsl     x22, x22, 1

                b       rand_modular_shift
        rand_modular_shift_end:


        // Generate random number, generate until within the bounds
        mov     x23, -1
        rand_generate_number:
                // Generate random number
                bl      rand

                // Arithmetically limit the x21 of random number
                mov     x18, x0
                sub     x17, x22, 1
                and     x23, x18, x17
                
        // M4: ADD EQUAL
        add     x23, x23, x28


                // If smaller than x28, regenerate
                cmp     x23, x28
                b.lt    rand_generate_number

                // If greater than x27, regenerate
                cmp     x23, x27
                b.gt    rand_generate_number

        rand_generate_number_end:


        mov     x0, x23


        
        
        
        
        
        
        

        randomNum_end:
        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret






/**
 * Initialize the game board and play
 *
 * Firstly, populate all the tiles with positive random numbers.
 * Then, calculate how many negative tiles are needed and
 * flip that number of tiles. By fliping, simply multiply -1.
 * Thirdly, flip tiles to special tiles. Simply assign new value.
 *
 * The board->array, the tile array, is a 1-d array, but used as a 2-d.
 * Simply convert between 1-d array 3 to x and y by math.
 */

initializeGame:        // initializeGame(struct Board* board, struct Play* play)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        
        
        
        
        
        

        
        // Store pointer of struct Table & struct Play
        mov     x19, x0
        mov     x20, x1

        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x19
                
            

            
        

        ldr     x0,     =output
        bl      printf
*/
        /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =output
        bl      printf
*/

        // Read x21 and x22
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x21,     [x9]                    // load the value
        

        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x22,     [x9]                    // load the value
        


        // Ensure the board is within the acceptable size
        
        // M4: MAX
        mov     x9,     x21
        mov     x10,    MIN_ROW
        // csel    x21,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_2
        b       else_2

        if_2:  mov     x21,     x9
                b       end_2
        else_2:mov     x21,     x10
                b       end_2
        end_2:

        
        
        

        
        // M4: MAX
        mov     x9,     x22
        mov     x10,    MIN_COL
        // csel    x22,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_3
        b       else_3

        if_3:  mov     x22,     x9
                b       end_3
        else_3:mov     x22,     x10
                b       end_3
        end_3:

        
        
        

        
        // M4: MIN
        mov     x9,     x21
        mov     x10,    MAX_ROW
        // csel    x21,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_4
        b       else_4

        if_4:  mov     x21,     x9
                b       end_4
        else_4:mov     x21,     x10
                b       end_4
        end_4:

        
        
        

        
        // M4: MIN
        mov     x9,     x22
        mov     x10,    MAX_COL
        // csel    x22,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_5
        b       else_5

        if_5:  mov     x22,     x9
                b       end_5
        else_5:mov     x22,     x10
                b       end_5
        end_5:

        
        
        


        // Write new x21 & x22 back to struct Board* board
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x21           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_column                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x22           // float value

                str	x10,    [x9]         // store the value
        


        // Calculate x23
        mul     x23, x21, x22

        // Set float zero
        
        mov     x18, 0
        scvtf   d28, x18

        // Initialize statistics, giving default values
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x23           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_negatives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    0           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_specials                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    0           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    3           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d28           // float value

                str	d10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d28           // float value

                str	d10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    5           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_range                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    1           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_uncovered_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    0           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    PREPARE           // float value

                str	x10,    [x9]         // store the value
        


        // Populate board with random positive values
        
        
        mov     x24, 0
        initialize_populate_row:
                // Loop condition
                cmp     x24, x23
                b.ge    initialize_populate_row_end
                
                // Generate random number
                mov     x0, MIN_TIL
                mov     x1, MAX_TIL
                bl      randomNum

                // Convert random number and divide by 100
                mov     x1, 100
                scvtf   d0, x0
                scvtf   d1, x1
                fdiv    d18, d0, d1

                /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                fmov     d0,    d18
                
            

            
        

        ldr     x0,     =output_f
        bl      printf
*/

                // Calculate and store the pointer of current struct Tile
                
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x24                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x25,     x9                      // result

                
        // M4: ADD EQUAL
        add     x25, x25, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x25,     x25,     x10

                
        // M4: ADD EQUAL
        add     x25, x25, x19

        


                // Write to struct Tile
                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x25                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d18           // float value

                str	d10,    [x9]         // store the value
        

                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x25                      // int base (negative)
                mov     x12,    tile_covered                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    TRUE           // float value

                str	x10,    [x9]         // store the value
        

                
                
        // M4: READ STRUCT

        
                mov     x11,    x25                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d18,     [x9]                    // load the value
        


                // Increment and loop again
                
        // M4: ADD ADD
        add     x24, x24, 1

                b       initialize_populate_row
        initialize_populate_row_end:
        
        
        


        // Flip to negative numbers
        
        
        
        
        
        
        // Calculate max amount of x25
        
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x23                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    NEG_PERCENT                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x26,     x9                      // result

        mov     x18, 100
        udiv    x26, x26, x18

        initialize_flip_neg:
                // Loop condition
                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_negatives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        

                cmp     x25, x26
                b.ge    initialize_flip_neg_end

                mov     x0, 0
                sub     x1, x23, 1
                bl      randomNum
                mov     x27, x0

                // Calculate and store the pointer of current struct Tile
                
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x27                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x24,     x9                      // result

                
        // M4: ADD EQUAL
        add     x24, x24, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x24,     x24,     x10

                
        // M4: ADD EQUAL
        add     x24, x24, x19

        

                // Read tile value
                
        // M4: READ STRUCT

        
                mov     x11,    x24                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d18,     [x9]                    // load the value
        


                // If the number is already negative, then skip
                fcmp    d18, d28
                b.lt    initialize_flip_neg
                
                // Else flip the tile to negative
                mov     x17, -1
                scvtf   d17, x17
                fmul    d18, d18, d17
                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x24                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d18           // float value

                str	d10,    [x9]         // store the value
        


                /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x27
                
            

            
        
            
            
            
                fmov     d0,    d18
                
            

            
        

        ldr     x0,     =output_init
        bl      printf
*/


                // Increase x25 amount in struct Board
                
        // M4: ADD ADD
        add     x25, x25, 1

                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_negatives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x25           // float value

                str	x10,    [x9]         // store the value
        


                // Loop again
                b       initialize_flip_neg
        initialize_flip_neg_end:
        
        
        
        
        



        // Flip to specials
        
        
        
        
        

        // Calculate max amount of x25
        
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x23                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    SPE_PERCENT                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x26,     x9                      // result

        mov     x18, 100
        udiv    x26, x26, x18

        initialize_flip_spe:
                // Loop condition
                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_specials                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        

                cmp     x25, x26
                b.ge    initialize_flip_spe_end

                mov     x0, 0
                sub     x1, x23, 1
                bl      randomNum
                mov     x27, x0
                
                // Calculate and store the pointer of current struct Tile
                
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x27                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x24,     x9                      // result

                
        // M4: ADD EQUAL
        add     x24, x24, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x24,     x24,     x10

                
        // M4: ADD EQUAL
        add     x24, x24, x19

        

                // Read tile value
                
        // M4: READ STRUCT

        
                mov     x11,    x24                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d18,     [x9]                    // load the value
        


                // Check if tile is already negative
                fcmp    d18, d28
                b.lt    initialize_flip_spe

                // Check if tile is already special
                mov     x17, 20
                scvtf   d17, x17
                fcmp    d18, d17
                b.ge    initialize_flip_spe

                // Else pick a special
                mov     x0, DOUBLE_RANGE
                mov     x1, DOUBLE_RANGE
                bl      randomNum
                mov     x18, x0
                scvtf   d18, x18

                // And flip the tile into special
                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x24                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d18           // float value

                str	d10,    [x9]         // store the value
        

                
                /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x27
                
            

            
        
            
            
            
                fmov     d0,    d18
                
            

            
        

        ldr     x0,     =output_init
        bl      printf
*/


                // Increase negatives amount in struct Board
                
        // M4: ADD ADD
        add     x25, x25, 1

                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_specials                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x25           // float value

                str	x10,    [x9]         // store the value
        


                /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x25
                
            

            
        

        ldr     x0,     =output
        bl      printf
*/

                // Loop again
                b       initialize_flip_spe

        initialize_flip_spe_end:
        
        
        
        
        



        // Generate Exit
        
        
        
                initialize_flip_exit:
                // Pick a tile
                mov     x0, 0
                sub     x1, x23, 1
                bl      randomNum
                mov     x27, x0

                // Calculate and store the pointer of current struct Tile
                
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x27                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x24,     x9                      // result

                
        // M4: ADD EQUAL
        add     x24, x24, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x24,     x24,     x10

                
        // M4: ADD EQUAL
        add     x24, x24, x19

        


                // Write value
                mov     x18, EXIT
                scvtf   d18, x18
                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x24                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d18           // float value

                str	d10,    [x9]         // store the value
        


                /*
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x27
                
            

            
        
            
            
            
                fmov     d0,    d18
                
            

            
        

        ldr     x0,     =output_init
        bl      printf
*/

                initialize_flip_exit_end:
        
        
        
        

        
        
        
        
        
        

        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret





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
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        
        
        
        
        

        // Store pointer of struct Table & struct Play & x21
        mov     x19, x0
        mov     x20, x1
        mov     x21, x2
        
        // Read x22 and x23
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x22,     [x9]                    // load the value
        

        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x23,     [x9]                    // load the value
        


        // Print a table header under x21 mode
        cmp     x21, TRUE
        b.eq    display_header_peek
        b       display_header_peek_end
        display_header_peek:
                // Print table header
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_table_header
        bl      printf

        display_header_peek_end:

        // Loop for displaying
        
        
        
        
        mov     x24, 0
        mov     x25, 0
        display_row:
                // Loop condition
                cmp     x24, x22
                b.ge    display_row_end
                
                mov     x25, 0
                display_col:
                        // Loop condition
                        cmp     x25, x23
                        b.ge    display_col_end
                        
                        // Calculate and store the pointer of current struct Tile
                        
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x24                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    x22                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x18,     x9                      // result

                        
        // M4: ADD EQUAL
        add     x18, x18, x25

                        
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x18                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x26,     x9                      // result

                
        // M4: ADD EQUAL
        add     x26, x26, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x26,     x26,     x10

                
        // M4: ADD EQUAL
        add     x26, x26, x19

        

                        
        // M4: READ STRUCT

        
                mov     x11,    x26                      // int base (negative)
                mov     x12,    tile_covered                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x18,     [x9]                    // load the value
        


                        // Read tile value
                        
        // M4: READ STRUCT

        
                mov     x11,    x26                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d27,     [x9]                    // load the value
        


                        // If tile is not covered
                        cmp     x18, FALSE
                        b.eq    display_uncovered

                        // Else If is in x21 mode
                        cmp     x21, TRUE
                        b.eq    display_uncovered

                        // Else
                        b       display_covered
                        
                        
                        // Uncovered tile
                        display_uncovered:

                                mov     x17, 20
                                scvtf   d17, x17
                                fcmp    d27, d17
                                b.gt    display_uncovered_specials
                                b       display_uncovered_number

                                // Special tiles
                                display_uncovered_specials:
                                        // If is in x21 mode
                                        cmp     x21, TRUE
                                        b.eq    display_uncovered_specials_peek
                                        b       display_uncovered_specials_normal

                                        // Peek mode display
                                        display_uncovered_specials_peek:
                                                // Print tile
                                                fcvtns  x27, d27
                                                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x27
                
            

            
        

        ldr     x0,     =str_tile_special_peek
        bl      printf

                                        display_uncovered_specials_peek_end:
                                        b       display_uncovered_specials_normal_end
                                        
                                        // Normal mode display
                                        display_uncovered_specials_normal:
                                                // Print tile
                                                fcvtns  x27, d27
                                                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x27
                
            

            
        

        ldr     x0,     =str_tile_special
        bl      printf

                                        display_uncovered_specials_normal_end:
                                        
                                display_uncovered_specials_end:
                                b       display_uncovered_number_end

                                // Number tile
                                display_uncovered_number:
                                        // If is in x21 mode
                                        cmp     x21, TRUE
                                        b.eq    display_uncovered_number_peek
                                        b       display_uncovered_number_normal
                                        
                                        // Peek mode display
                                        display_uncovered_number_peek:
                                                // Print tile
                                                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                fmov     d0,    d27
                
            

            
        

        ldr     x0,     =str_tile_number_peek
        bl      printf

                                        display_uncovered_number_peek_end:
                                        b       display_uncovered_number_normal_end

                                        // Normal mode display
                                        display_uncovered_number_normal:
                                                // Print tile
                                                mov     x17, 0
                                                scvtf   d17, x17

                                                fcmp    d27, d17
                                                b.gt    display_uncovered_number_normal_pos
                                                b       display_uncovered_number_normal_neg
                                                
                                                // Positive value
                                                display_uncovered_number_normal_pos:
                                                        // Print positive sign
                                                        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    POSITIVE
                
            

            
        

        ldr     x0,     =str_tile_number
        bl      printf

                                                display_uncovered_number_normal_pos_end:
                                                b       display_uncovered_number_normal_neg_end
                                                
                                                // Negative value
                                                display_uncovered_number_normal_neg:
                                                        // Print negative sign
                                                        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    NEGATIVE
                
            

            
        

        ldr     x0,     =str_tile_number
        bl      printf

                                                display_uncovered_number_normal_neg_end:

                                        display_uncovered_number_normal_end:

                                display_uncovered_number_end:


                        display_uncovered_end:
                        b       display_covered_end

                        // Covered tile
                        display_covered:
                                // Print tile covered
                                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_tile_covered
        bl      printf

                        display_covered_end:

                        
                        // Increment and loop again
                        
        // M4: ADD ADD
        add     x25, x25, 1

                        b       display_col
                display_col_end:

                // Print line break
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_linebr
        bl      printf


                // Increment and loop again
                
        // M4: ADD ADD
        add     x24, x24, 1

                b       display_row
        display_row_end:
        
        
        
        
        
        
        


        // Print stats, accordingly
        cmp     x21, TRUE
        b.eq    display_stats_peek
        b       display_stats_normal

        // If x21, then print statistic of the board.
        display_stats_peek:
                
                
                
                

                // Read values
                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x26,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_negatives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x24,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_specials                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        


                // Calculate x24 x27
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x24                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    100                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x18,     x9                      // result

                udiv    x27, x18, x26
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x24
                
            

            
        
            
            
            
                mov     x2,    x26
                
            

            
        
            
            
            
                mov     x3,    x27
                
            

            
        

        ldr     x0,     =str_stats_peek_negatives
        bl      printf


                // Calculate x25 x27
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x25                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    100                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x18,     x9                      // result

                udiv    x27, x18, x26
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x25
                
            

            
        
            
            
            
                mov     x2,    x26
                
            

            
        
            
            
            
                mov     x3,    x27
                
            

            
        

        ldr     x0,     =str_stats_peek_specials
        bl      printf


                
                
                
                
        display_stats_peek_end:
        b       display_stats_normal_end

        // Otherwise, print the current play statistics.
        display_stats_normal:
                
                
                
                
                
                // Read from struct Play* play
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x24,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d26,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d27,     [x9]                    // load the value
        


                // Print stats
                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x24
                
            

            
        

        ldr     x0,     =str_play_lives
        bl      printf

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x25
                
            

            
        

        ldr     x0,     =str_play_bombs
        bl      printf

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                fmov     d0,    d26
                
            

            
        

        ldr     x0,     =str_play_score
        bl      printf

                
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                fmov     d0,    d27
                
            

            
        

        ldr     x0,     =str_play_total_score
        bl      printf

        
                
                
                
                
        display_stats_normal_end:

        

        
        
        
        

        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret





/**
 * Start game
 *
 * Record the start timestamp and set the status to gaming.
 */
startGame:      // startGame(struct Play* play)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0

        
        mov     x19, x0

        // Change play status to GAMING
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    GAMING           // float value

                str	x10,    [x9]         // store the value
        


        // Record start time
        mov     x0, 0
        bl      time
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_start_timestamp                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x0           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret





/**
 * Exit game
 *
 * Record end timestamp and calculate gaming duration.
 * Print user message.
 */
exitGame:       // exitGame(struct Play* play)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0

        
        
        
        
        mov     x19, x0

        // Change play status to EXIT
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    EXIT           // float value

                str	x10,    [x9]         // store the value
        


        // Record end time
        mov     x0, 0
        bl      time
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_end_timestamp                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x0           // float value

                str	x10,    [x9]         // store the value
        


        // Calculate x22
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_start_timestamp                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the value
        

        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_end_timestamp                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x21,     [x9]                    // load the value
        

        sub     x22, x21, x20
        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_duration                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x22           // float value

                str	x10,    [x9]         // store the value
        

        
        
        
        
        
        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret






/**
 * Display play result
 *
 * Just printing values. Nicely with text colors and formats.
 */
displayResult:  // displayResult(struct Play* play)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        
        
        
        mov     x19, x0

        // Print header
        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_result_header
        bl      printf


        // Print player name
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_player                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =str_result_player
        bl      printf


        // Print total tile score
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                fmov     d0,    d20
                
            

            
        

        ldr     x0,     =str_result_total_score
        bl      printf


        // Print left bombs
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =str_result_left_bombs
        bl      printf

        
        // Print left lives
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =str_result_left_lives
        bl      printf

        
        // Print duration
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_duration                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =str_result_duration
        bl      printf

        
        // Print final score
        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    play_final_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x20,     [x9]                    // load the x20
        

        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        
            
            
            
                mov     x1,    x20
                
            

            
        

        ldr     x0,     =str_result_final_score
        bl      printf


        // Print enter continue
        
        // M4: PRINT
        
        
        

        
            
            
            
                
                
            

            
        

        ldr     x0,     =str_enter_continue
        bl      printf



        
        
        

        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret





/**
 * Calculate the final score of play
 *
 * It calculates a comprehensive score for the game.
 *
 * According to the formula, by doing the following would get a higher mark:
 * 1. Uncover more tiles
 * 2. Get higher uncover tile score
 * 3. Use less bombs to win
 * 4. Keep more lives to win
 * 5. Use less time to win
 *
 * The following formula gives player a relatively fair score.
 */

calculateScore:        // calculateScore(struct Board* board, struct Play* play)
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0

        
        
        
        
        
        

        // Calculate d21
        // float d21 = 1.0 * play->uncovered_tiles / board->tiles;
        calculate_score_rate:
                
                

                // Read stats from struct Play* play
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_uncovered_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x26,     [x9]                    // load the value
        

                
                // Calculate portion of uncovered x26
                scvtf   d18, x25
                scvtf   d17, x26
                fdiv    d21, d18, d17

                
                
        
        // Calculate d22
        // float d22 = play->total_score * 20 + play->bombs * 33 + play->lives * 10;
        calculate_score_score:
                
                
                

                // Read stats from struct Play* play
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x26,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x27,     [x9]                    // load the value
        


                // Calculate portion of total d22
                mov     x18, 20
                scvtf   d17, x25
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    d22, d22, d16

                // Calculate protion of x26 left
                mov     x18, 33
                scvtf   d17, x26
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    d22, d22, d16
                
                // Calculate protion of x27 left
                mov     x18, 33
                scvtf   d17, x27
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    d22, d22, d16
                
                
                
                
        

        // Calculate time deduct
        // float d23 = play->duration * 46;
        calculate_score_time_deduct:
                

                // Read stats from struct Play* play
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_duration                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        


                // Calculate protion of lives left
                mov     x18, 46
                scvtf   d17, x25
                scvtf   d18, x18
                fmul    d16, d17, d18
                fadd    d23, d23, d16

                
        
        // Calculate final d22
        // int x24 = d21 * d22 - d23;
        calculate_score_final_score:
                fmul    d18, d21, d22
                fsub    d18, d18, d23

                fcvtns  x24, d18

        // Write final d22 to struct Play* play
        // play->x24 = x24
        
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_final_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x24,     [x9]                    // load the value
        



        
        
        
        
        
        
        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret






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
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        // Save registers
        str 	x19,    [fp, 16]
        str 	x20,    [fp, 24]
        str 	x21,    [fp, 32]
        str 	x22,    [fp, 40]
        str 	x23,    [fp, 48]
        str 	x24,    [fp, 56]
        str 	x25,    [fp, 64]
        str 	x26,    [fp, 72]
        str 	x27,    [fp, 80]
        str 	x28,    [fp, 88]

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0

        
        
        
        
        
        

        // Store pointer of struct Table & struct Play & x21 & x22
        mov     x19, x0
        mov     x20, x1
        mov     x21, x2
        mov     x22, x3

        // Check both x21 and x22 values within the board and gaming status
        play_game_check_x_y:
                
                

                // Read from struct
                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_row                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x23,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_column                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x24,     [x9]                    // load the value
        


                // Check x25 for x21, if less than 0, then return
                cmp     x21, 0
                b.lt    play_game_end

                // Check x25 for x21, if greter or equal to x23, then return
                cmp     x21, x23
                b.ge    play_game_end

                // Check x25 for x22, if less than 0, then return
                cmp     x22, 0
                b.lt    play_game_end

                // Check rnage for x22, if greater or equal to x24, then return
                cmp     x22, x24
                b.ge    play_game_end

                
                

        


        // Reset x25 and deduct bomb by one
        play_game_deduct:
                
                

                // Read values
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x23,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_range                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x25,     [x9]                    // load the value
        


                // Modify values
                mov     x18, 1    // play->x25 = 1;
                
        // M4: MINUS MINUS
        sub     x23, x23, 1
      // play->x23--;

                // Write back values
                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x23           // float value

                str	x10,    [x9]         // store the value
        

                
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_range                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x25           // float value

                str	x10,    [x9]         // store the value
        


                
                


        // Loop for uncover tiles
        play_game_uncover_tile:

                // Set value for t
                
                
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x25                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    -1                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x23,     x9                      // result


                // Loop for uncovering rows in x25
                play_game_uncover_tile_row:
                        cmp     x23, x25
                        b.gt    play_game_uncover_tile_row_end

                        // Set value for x24
                        
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x25                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    -1                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x24,     x9                      // result


                        // Loop for uncovering columns in x25
                        play_game_uncover_tile_column:
                                cmp     x24, x25
                                b.gt    play_game_uncover_tile_column_end

                                
                                // Validate if the 4 is within valid x25
                                play_game_uncover_tile_index_validate:
                                        // Define uncover 4 variable
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        

                                        // Read from struct Board* board
                                        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_tiles                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x16,     [x9]                    // load the value
        

                                        
        // M4: READ STRUCT

        
                mov     x11,    x19                      // int base (negative)
                mov     x12,    board_column                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x27,     [x9]                    // load the value
        


                                        // Calculate x21 and x22 of the tile to uncover
                                        
        // M4: ADD
        
        mov     x9,     0                       // initialize x9 to 0
        
        
            
            
        
            
                mov     x10,    x21                       // move next number to x10
                add     x9,     x9,     x10             // and Adds x10 to x9
            
            
        
            
                mov     x10,    x23                       // move next number to x10
                add     x9,     x9,     x10             // and Adds x10 to x9
            
            
        
        
        mov     x17,     x9                      // result
   // int x17 = x21 + x23;
                                        
        // M4: ADD
        
        mov     x9,     0                       // initialize x9 to 0
        
        
            
            
        
            
                mov     x10,    x22                       // move next number to x10
                add     x9,     x9,     x10             // and Adds x10 to x9
            
            
        
            
                mov     x10,    x24                       // move next number to x10
                add     x9,     x9,     x10             // and Adds x10 to x9
            
            
        
        
        mov     x18,     x9                      // result
   // int x18 = x22 + x24;

                                        // int 4 = (x17 * board->x27) + x18;
                                        madd    x28, x17, x27, x18


                                        // If 4 < 0, then it's invalid, do nothing
                                        cmp     x28, 0
                                        b.lt    play_game_uncover_tile_index_validate_end

                                        // If 4 >= x16, then it's invalid, do nothing
                                        cmp     x28, x16
                                        b.ge    play_game_uncover_tile_index_validate_end

                                        // If x22 of uncover tile < 0, then it's invalid, do nothing
                                        cmp     x18, 0
                                        b.lt    play_game_uncover_tile_index_validate_end

                                        // If x22 of uncover tile >= x27, then it's invalid, do nothing
                                        cmp     x18, x27
                                        b.ge    play_game_uncover_tile_index_validate_end
                                        
                                        // Get current tile pointer
                                        
                
        // M4: MUL
        
        mov     x9,     1                       // initialize x9 to 1
        
        
            
            
        
            
                mov     x10,    x28                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
            
                mov     x10,    tile_size                       // move next multiplier to x10
                mul     x9,     x9,     x10             // and multiplies x10 to x9
            
            
        
        
        mov     x26,     x9                      // result

                
        // M4: ADD EQUAL
        add     x26, x26, board_array

                
        // M4: MUL EQUAL
        mov     x10,    -1
        mul     x26,     x26,     x10

                
        // M4: ADD EQUAL
        add     x26, x26, x19

        

                                        // If tile.covered == FALSE, then it's already uncovered, do nothing
                                        
        // M4: READ STRUCT

        
                mov     x11,    x26                      // int base (negative)
                mov     x12,    tile_covered                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x15,     [x9]                    // load the value
        

                                        cmp     x15, FALSE
                                        b.eq    play_game_uncover_tile_index_validate_end

                                        // Uncover tile
                                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x26                      // int base (negative)
                mov     x12,    tile_covered                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    FALSE           // float value

                str	x10,    [x9]         // store the value
        


                                        // Read the tile value
                                        
        // M4: READ STRUCT

        
                mov     x11,    x26                      // int base (negative)
                mov     x12,    tile_value                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d20,     [x9]                    // load the value
        


                                        // Do different things when meet different x16
                                        play_game_uncover_tile_value:
                                                
                                                // If the tile is EXIT
                                                ldr     x16, =EXIT
                                                scvtf   d16, x16
                                                fcmp    d20, d16
                                                b.eq    play_game_uncover_tile_value_exit
                                                b       play_game_uncover_tile_value_exit_end
                                                
                                                play_game_uncover_tile_value_exit:
                                                        // Claim winning
                                                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    WIN           // float value

                str	x10,    [x9]         // store the value
        

                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_exit_end:

                                                
                                                // If the tile is DOUBLE RANGE
                                                ldr     x16, =DOUBLE_RANGE
                                                scvtf   d16, x16
                                                fcmp    d20, d16
                                                b.eq    play_game_uncover_tile_value_double_range
                                                b       play_game_uncover_tile_value_double_range_end
                                                
                                                play_game_uncover_tile_value_double_range:
                                                        // Increase x25 by 1
                                                        

                                                        
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_range                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x17,     [x9]                    // load the value
        

                                                        
        // M4: MUL EQUAL
        mov     x10,    2
        mul     x17,     x17,     x10

                                                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_range                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x17           // float value

                str	x10,    [x9]         // store the value
        


                                                        
                                                        b       play_game_uncover_tile_value_end
                                                play_game_uncover_tile_value_double_range_end:


                                                // Else the tile is a number tile
                                                play_game_uncover_tile_value_number:
                                                        
                                                        
                                                        
                                                        // Read total d16 and increase by tile value, and write back
                                                        
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d17,     [x9]                    // load the value
        

                                                        fadd    d17, d17, d20
                                                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_total_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d17           // float value

                str	d10,    [x9]         // store the value
        

                                                        
                                                        // Read d16 and increase by tile value, and write back
                                                        
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d16,     [x9]                    // load the value
        

                                                        fadd    d16, d16, d20
                                                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d16           // float value

                str	d10,    [x9]         // store the value
        


                                                        
                                                        
                                                        b       play_game_uncover_tile_value_end

                                                
                                        play_game_uncover_tile_value_end:


                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                play_game_uncover_tile_index_validate_end:



                                // Increment & loop again
                                
        // M4: ADD ADD
        add     x24, x24, 1

                                b       play_game_uncover_tile_column
                        play_game_uncover_tile_column_end:

                        // Increment & loop again
                        
        // M4: ADD ADD
        add     x23, x23, 1

                        b       play_game_uncover_tile_row
                play_game_uncover_tile_row_end:

                
                
                


        // If the current life score is negative number, then lose a life and reset the score.
        play_game_score_check:
                
                

                // Set float zero
                
                mov     x18, 0
                scvtf   d28, x18

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	d18,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x26,     [x9]                    // load the value
        


                fcmp    d18, d28
                b.lt    play_game_score_check_decrement
                b       play_game_score_check_decrement_end

                play_game_score_check_decrement:
                        // Decrease live and set d18 to 0
                        
        // M4: MINUS MINUS
        sub     x26, x26, 1
              // play->x26--;
                        fmov    d18, d28       // play->d18 = 0;
                        
                        // Write back to struct
                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_score                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                fmov    d10,    d18           // float value

                str	d10,    [x9]         // store the value
        

                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    x26           // float value

                str	x10,    [x9]         // store the value
        

                play_game_score_check_decrement_end:
                
                
                
                


        // If the player is running out of bombs, or lives, then die.
        // Also need to see if the game status is not win (from above), 
        // because there's possibility that player is winning this round 
        // but also run out of lives or bombs, but we're saying the player is winning.
        play_game_lives_bombs_check:
                
                
                

                // Read values from struct
                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x26,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_bombs                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x27,     [x9]                    // load the value
        

                
        // M4: READ STRUCT

        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_lives                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                
                ldr	x28,     [x9]                    // load the value
        


                // If already win, then skip lose
                cmp     x26, WIN
                b.eq    play_game_lives_bombs_check_lose_end

                // If x27 is less than 0, then lose
                cmp     x27, 0
                b.lt    play_game_lives_bombs_check_lose

                // If x28 is less than 0, then lose
                cmp     x28, 0
                b.lt    play_game_lives_bombs_check_lose

                // Otherwise, do nothing
                b       play_game_lives_bombs_check_lose_end

                play_game_lives_bombs_check_lose:
                        // Claim die
                        
        
        
        

        // M4: WRITE STRUCT
        
                
                
        
        
        
                mov     x11,    x20                      // int base (negative)
                mov     x12,    play_status                      // int attribute offset (positive)
                sub     x12,    xzr,    x12             // attibute = -attibute (negative)
                add     x9,     x11,    x12             // int offset = base + attribute (negative)
                mov    x10,    DIE           // float value

                str	x10,    [x9]         // store the value
        
     // play->x26 = DIE;
                play_game_lives_bombs_check_lose_end:


                
                
                
                


        // Function end
        play_game_end:

        
        
        
        
        

        
        // M4: RET

        // Restore registers
        ldr 	x19,    [fp, 16]
        ldr 	x20,    [fp, 24]
        ldr 	x21,    [fp, 32]
        ldr 	x22,    [fp, 30]
        ldr 	x23,    [fp, 48]
        ldr 	x24,    [fp, 56]
        ldr 	x25,    [fp, 64]
        ldr 	x26,    [fp, 72]
        ldr 	x27,    [fp, 80]
        ldr 	x28,    [fp, 88]

        ldp     fp,     lr,     [sp], dealloc            // deallocate stack memory
        ret






        .data                                            // global variables
n:      .int    0                                        // int n = 0

