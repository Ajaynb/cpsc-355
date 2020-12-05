        

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


        // m and n

        mov     x0,     min_til
        mov     x1,     max_til
        bl      randomNum

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x0
                
        

        
    
        ldr     x0,     =output
        bl      printf


        // m and n


        
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


        
        
        
        
        


        mov     x19,    x0                              // int x19;
        mov     x20,    x1                              // int x20;

        cmp     x19,    x20                             // if (x19 == x20)
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
        sub     x21,    x27,    x28                     // int x21 = x27 - x28
        
        // M4: ADD ADD
        add     x21, x21, 1
                                    // x21 += 1;

        // Generate random number
        bl      rand

        // Limit x21
        udiv    x22,    x0,     x21                     // int quotient = rand / x21;
        mul     x23,    x22,    x21                     // int product = quotient * x21
        sub     x24,    x0,     x23                     // int remainder = rand - product

        mov     x0,     x24                             // return the remainder as the generated random number
       

        
        
        
        
        

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




