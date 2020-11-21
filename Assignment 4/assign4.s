

                        
                             
                            
                          
        
                  // Includes also qu0te.m4
                             
                            
                              
        

                    
        

                    
                            

        

        // Defining the strings
outstr: .string "ALLOC size: %d\n"                // The output string
aloc:   .string "ALLOC[%d][%d](%d) = %d\n"

        // Renaming registers
        x_row   .req    x19                     // row of table
        x_col   .req    x20                     // column of table
        x_2da   .req    x21                     // 2d Array of Table
        x_1da   .req    x22                     // 5truct documents Array

        x_off   .req    x23                     // current offset
        x_crow  .req    x24                     // current row index
        x_ccol  .req    x25                     // current column index

        // Renaming x29 and x30 to FP and LR
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 16
        min_row = 4
        max_col = 16
        min_col = 4

        // Equates for 2d Array of table
        int = 4                                 // sizeof(int)

        // Equates for 5truct Document          // 5truct Document {
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
    
    


        
        // Allocate 2d Array for Table
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_row                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    int                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_2da,     x9                      // Result

        
        
cmp     x_2da,     xzr                             // Compare negative
        b.gt    if_4                           // Not negative
        b       else_4                         

if_4:   sub     x_2da,     xzr,    x_2da              // Negate the size
else_4:
        
        and     x_2da,     x_2da,     -16             // And -16
        add     sp,     sp,     x_2da              // Allocate on SP

        


        
    
    
        
        
    
        mov     x1,    x_2da
        
    
        ldr     x0,     =outstr
        bl      printf


        // Allocate 1d Array for Structures
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_row                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_1da,     x9                      // Result

        
        
cmp     x_1da,     xzr                             // Compare negative
        b.gt    if_5                           // Not negative
        b       else_5                         

if_5:   sub     x_1da,     xzr,    x_1da              // Negate the size
else_5:
        
        and     x_1da,     x_1da,     -16             // And -16
        add     sp,     sp,     x_1da              // Allocate on SP

        


        
    
    
        
        
    
        mov     x1,    x_1da
        
    
        ldr     x0,     =outstr
        bl      printf



generate_table:
        mov     x_crow, xzr

generate_table_row:
        cmp     x_crow, x_row
        b.eq    generate_table_row_end
        mov     x_ccol, xzr

        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x_off                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_1da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_2da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        
    
    
        
        
    
        mov     x1,    x_off
        
    
        ldr     x0,     =outstr
        bl      printf


        // Construct Structure
        
    
    
        
        
    
        
        add     x9,     x_off,     sd_occ               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
        
        add     x9,     x_off,     sd_frq               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
        
        add     x9,     x_off,     sd_ind               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    

        
        add     x9,     x_off,     sd_occ              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        
        add     x9,     x_off,     sd_frq              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        
        add     x9,     x_off,     sd_ind              // Add the size
        mov     x10,    x_crow
        str     x10,    [x29,   x9]             // And Adds x10 to x9


        
        add     x9,     x_off,     sd_ind              // Add the size
        ldr	    x11,     [x29,   x9]             // Load the value

        
    
    
        
        
    
        mov     x1,    x11
        
    
        ldr     x0,     =outstr
        bl      printf



        generate_table_col:
        cmp     x_ccol, x_col
        b.eq    generate_table_col_end

        // Generate Random Number
        
        bl      rand                            // rand();
        and  	x9,     x0,     0xF              // int x9 = rand() & 0xF;
        mov     x11,     x9                      // x11 = x9;

        add     x11,    x11,    1

        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x12,     x9                      // Result

        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x12                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_ccol                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x12,     x9                      // Result


        // Write to 2d Array of Table
        
        mov     x9,     int
        mov     x10,    x12
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     x_2da                  // Calculate Offset += Base

        mov     x10,    x11
        str     x10,    [x29,   x9]


        // Add occurence to Structure total occurence
        
        add     x9,     x_off,     sd_occ              // Add the size
        ldr	    x12,     [x29,   x9]             // Load the value

        
        add     x11, x11, x12

        
        add     x9,     x_off,     sd_occ              // Add the size
        mov     x10,    x11
        str     x10,    [x29,   x9]             // And Adds x10 to x9


        // Print
        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        mov     x2,    x_ccol
        
    
        mov     x3,    x9
        
    
        mov     x4,    x11
        
    
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

        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x_off                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_1da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_2da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x_off,     x9                      // Result

        
    
    
        
        
    
        mov     x1,    x_off
        
    
        ldr     x0,     =outstr
        bl      printf


        
        add     x9,     x_off,     sd_occ              // Add the size
        ldr	    x11,     [x29,   x9]             // Load the value

        
    
    
        
        
    
        mov     x1,    x11
        
    
        ldr     x0,     =outstr
        bl      printf




        print_table_col:
        cmp     x_ccol, x_col
        b.eq    print_table_col_end


        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x12,     x9                      // Result

        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x12                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_ccol                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x12,     x9                      // Result


        // Write to Array
        
        mov     x9,     int
        mov     x10,    x12
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     x_2da                  // Calculate Offset += Base

        ldr     x11,     [x29,   x9]


        // Print
        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        mov     x2,    x_ccol
        
    
        mov     x3,    x12
        
    
        mov     x4,    x11
        
    
        ldr     x0,     =aloc
        bl      printf




        
        add     x_ccol, x_ccol, 1


        b       print_table_col
        print_table_col_end:


        
        add     x_crow, x_crow, 1

        b       print_table_row
print_table_row_end:


end:    // Program end

        // Deallocate 2d Array of table
        
        sub     x_1da,     xzr,    x_1da              // Negate the size again to positive
        add     sp,     sp,     x_1da              // Deallocate on SP

        
        sub     x_2da,     xzr,    x_2da              // Negate the size again to positive
        add     sp,     sp,     x_2da              // Deallocate on SP

        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
