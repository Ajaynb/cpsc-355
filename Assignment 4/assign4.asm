
        include(`alloc.m4')
        include(`forloop3.m4')
        include(`foreach2.m4')
        include(`print.m4')
        include(`minmax.m4')
        include(`rand.m4')
        include(`addAll.m4')

        define(`g_counter',`0')dnl
        define(`g_count',`define(`g_counter',eval(g_counter+1))')dnl
        

        // Defining the strings
outstr: .string "ALLOC size: %d\n"                // The output string
aloc:   .string "ALLOC[%d][%d](%d) = %d\n"

        // Renaming registers
        x_row   .req    x19                     // row of table
        x_col   .req    x20                     // column of table
        x_arr   .req    x21                     // 2d array of table
        x_loc   .req    x23                     // 2d array allocate size
        x_dar   .req    x22                     // struct documents array

        x_crow  .req    x24                     // current row index
        x_ccol  .req    x25                     // current column index
        x_off   .req    x26                     // current offset

        // Renaming x29 and x30 to FP and LR
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 16
        min_row = 4
        max_col = 16
        min_col = 4

        // Equates for 2d array of table
        ta_val = 8                              // table_array_values = sizeof(int)

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

        // Limit the range of x_row and x_col as input validation
        min(x_row, x_row, max_row)
        max(x_row, x_row, min_row)
        min(x_col, x_col, max_col)
        max(x_col, x_col, min_col)

        // Allocate 2d array of table
        alloc(x_loc, x_row,  x_col, ta_val)
        print(outstr, x_loc)


generate_table:
        mov     x_crow, xzr

generate_table_row:
        cmp     x_crow, x_row
        b.eq    generate_table_row_end
        mov     x_ccol, xzr

        generate_table_col:
        cmp     x_ccol, x_col
        b.eq    generate_table_col_end

        

        mulAll(x_off, x_crow, x_col)
        add     x_off,  x_off,  x_ccol
        mulAll(x_off, x_off, ta_val, -1)

        random(x9, 0xF)
        add     x9,     x9,     1
        str 	x9,     [fp, x_off]
        ldr     x9,     [fp, x_off]

        print(aloc, x_crow, x_ccol, x_off, x9)


        add     x_ccol, x_ccol, 1
        b       generate_table_col
        generate_table_col_end:


        add     x_crow, x_crow, 1
        b       generate_table_row
generate_table_row_end:


print_table:
        mov     x_crow, xzr
        mov     x_off,  xzr

print_table_row:
        cmp     x_crow, x_row
        b.eq    print_table_row_end
        mov     x_ccol, xzr

        print_table_col:
        cmp     x_ccol, x_col
        b.eq    print_table_col_end

        

        mulAll(x_off, x_crow, x_col)
        add     x_off,  x_off,  x_ccol
        mulAll(x_off, x_off, ta_val, -1)


        ldr     x9,     [x29, x_off]
        print(aloc, x_crow, x_ccol, x_off, x9)

        add     x_ccol, x_ccol, 1
        b       print_table_col
        print_table_col_end:


        add     x_crow, x_crow, 1
        b       print_table_row
print_table_row_end:


end:    // Program end

        // Deallocate 2d array of table
        dealloc(x_loc)
        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
