        

output:         .string "%d\n"
output_f:       .string "%f\n"
allstr:         .string "sp %d, fp %d\n"


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


        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    sp
                
        

        
    
        
        
        
                mov     x2,    fp
                
        

        
    
        ldr     x0,     =allstr
        bl      printf


        // Alloc for struct Play & struct Board
        
        // M4: ALLOC
        add     sp,     sp,     play_size_alloc              // allocate on SP

        
        // M4: ALLOC
        add     sp,     sp,     board_size_alloc              // allocate on SP


        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    sp
                
        

        
    
        
        
        
                mov     x2,    fp
                
        

        
    
        ldr     x0,     =allstr
        bl      printf


        
        
        

        // M4: WRITE STRUCT
        mov     x11,    board                      // int base
        mov     x12,    board_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    5              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    board                      // int base
        mov     x12,    board_column                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    5              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        


        
        mov     x11,    play                    // int base
        mov     x12,    play_player             // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset
        add     x9,     fp,     x9
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x9
                
        

        
    
        ldr     x0,     =output
        bl      printf


        mov     x11,    play                    // int base
        mov     x12,    play_lives              // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset
        add     x9,     fp,     x9
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x9
                
        

        
    
        ldr     x0,     =output
        bl      printf



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

        and     x19, x19, -16
        
        // M4: ALLOC
        add     sp,     sp,     x19              // allocate on SP


        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    sp
                
        

        
    
        
        
        
                mov     x2,    fp
                
        

        
    
        ldr     x0,     =allstr
        bl      printf



        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x19
                
        

        
    
        ldr     x0,     =output
        bl      printf



        sub     x0, fp, board
        sub     x1, fp, play

        // bl      initializeGame


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
 * Simply convert between 1-d array 2 to x and y by math.
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

        // Read x21 and x22
        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    board_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
        ldr	x21,     [x9]                    // load the value
        

        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    board_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
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

        
        
        


        // Calculate x23
        mul     x23, x21, x22

        // Initialize statistics, giving default values
        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    board_tiles                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    x23              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    board_negatives                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    0              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    board_specials                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    0              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_lives                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    3              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_score                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    0              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_total_score                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    0              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_bombs                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    5              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_range                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    1              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_uncovered_tiles                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    0              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        

        
        
        

        // M4: WRITE STRUCT
        mov     x11,    x20                      // int base
        mov     x12,    play_status                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        sub     x9,     xzr,    x9              // offset = -offset

        
                mov     x10,    PREPARE              // int value
                
        
        
        
        str	x10,    [x9]                    // store the value
        


        // Populate board with random positive values
        
        
        mov     x24, 0
        initialize_populate_row:
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

                // Calculate array offset for current struct Tile (This calculation is an exception, it runs backwards)
                
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x24                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    tile_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x25,     x9                      // result

                
        // M4: ADD EQUAL
        add     x25, x25, board_array

                
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x25                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -1                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x25,     x9                      // result

                
        // M4: ADD EQUAL
        add     x25, x25, x19


                /*
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x25
                
        

        
    
        ldr     x0,     =output
        bl      printf
*/
        
                
        // M4: ADD ADD
        add     x24, x24, 1

                b       initialize_populate_row
        initialize_populate_row_end:
        
        
        

        

        
        
        
        
        
        


        
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



