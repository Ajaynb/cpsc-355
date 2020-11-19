        
        
        include(`alloc.m4')
        include(`forloop3.m4')
        include(`foreach2.m4')
        include(`print.m4')
        include(`minmax.m4')
        include(`rand.m4')

        define(`g_counter',`0')dnl
        define(`g_count',`define(`g_counter',eval(g_counter+1))')dnl
        

        // Defining the strings
outstr: .string "ALLOC size: %d\n"                // The output string

        // Renaming registers
        x_row   .req    x19                     // row of table
        x_col   .req    x20                     // column of table
        x_arr   .req    x21                     // 2d array of table
        x_loc   .req    x23                     // 2d array allocate size
        x_dar   .req    x22                     // struct documents array

        // Renaming x29 and x30 to FP and LR
        fp      .req    x29
        lr      .req    x30

        // Equates for 2d array of table
        ta_val = 4                              // table_array_values = sizeof(int)

        // Equates for struct Document          // struct Document {
        sd_occ = 0                              //     int occurence;
        sd_frq = 4                              //     int frequency;
        sd_ind = 8                              //     int index;
        sd = 12                                 // };

        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // Main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!      // space stack pointer
        mov     x29,    sp                      // frame-pointer = stack-pointer;

        // Random seed
        randomSeed()
        
        // Set up row and col variables
        mov     x_row,  5
        mov     x_col,  5

        // Allocate 2d array of table
        alloc(x_loc, x_row,  x_col, ta_val)
        multiply(x27, x_loc, x_row, 1000)
        print(outstr, x_loc)


        random(x27, 0xF)
        print(outstr, x27)


end:    // Program end

        // Deallocate 2d array of table
        dealloc(x_loc)
        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
