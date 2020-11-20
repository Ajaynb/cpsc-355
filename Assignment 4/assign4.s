
        



        
        

        
        
        
        



                        

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
        
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));

        
        // Set up row and col variables
        mov     x_row,  5
        mov     x_col,  5

        // Limit the range of x_row and x_col as input validation
        
    
        cmp     x_row,     max_row
        b.lt    if_0
        b       else_0
if_0:   mov    x_row,     x_row
        b       end_0
else_0: mov  x_row,     max_row
        b       end_0
end_0:
    
    

        
    
        cmp     x_row,     min_row
        b.gt    if_1
        b       else_1
if_1:   mov    x_row,     x_row
        b       end_1
else_1: mov  x_row,     min_row
        b       end_1
end_1:
    
    

        
    
        cmp     x_col,     max_col
        b.lt    if_2
        b       else_2
if_2:   mov    x_col,     x_col
        b       end_2
else_2: mov  x_col,     max_col
        b       end_2
end_2:
    
    

        
    
        cmp     x_col,     min_col
        b.gt    if_3
        b       else_3
if_3:   mov    x_col,     x_col
        b       end_3
else_3: mov  x_col,     min_col
        b       end_3
end_3:
    
    


        // Allocate 2d array of table
        
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_row                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    ta_val                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_loc,     x9                      // Result
                            // Multiply all parameters to get a final size
        sub     x_loc,     xzr,    x_loc              // Negate the size
        and     x_loc,     x_loc,     -16             // And -16
        add     sp,     sp,     x_loc              // Allocate on SP

        
    
    
        
        
    
        mov     x1,    x_loc
        
    
        ldr     x0,     =outstr
        bl      printf



generate_table:
        mov     x_crow, xzr

generate_table_row:
        cmp     x_crow, x_row
        b.eq    generate_table_row_end
        mov     x_ccol, xzr

        generate_table_col:
        cmp     x_ccol, x_col
        b.eq    generate_table_col_end

        

        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        add     x_off,  x_off,  x_ccol
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_off                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    ta_val                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    -1                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result


        
        bl      rand                            // rand();
        and  	x9,     x0,     0xF              // int x9 = rand() & 0xF;
        mov     x9,     x9                      // x9 = x9;

        add     x9,     x9,     1
        str 	x9,     [fp, x_off]
        ldr     x9,     [fp, x_off]

        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        mov     x2,    x_ccol
        
    
        mov     x3,    x_off
        
    
        mov     x4,    x9
        
    
        ldr     x0,     =aloc
        bl      printf



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

        

        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        add     x_off,  x_off,  x_ccol
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_off                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    ta_val                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    -1                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result



        ldr     x9,     [x29, x_off]
        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        mov     x2,    x_ccol
        
    
        mov     x3,    x_off
        
    
        mov     x4,    x9
        
    
        ldr     x0,     =aloc
        bl      printf


        add     x_ccol, x_ccol, 1
        b       print_table_col
        print_table_col_end:


        add     x_crow, x_crow, 1
        b       print_table_row
print_table_row_end:


end:    // Program end

        // Deallocate 2d array of table
        
        sub     x_loc,     xzr,    x_loc              // Negate the size again to positive
        add     sp,     sp,     x_loc              // Deallocate on SP

        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
