        
        
        



        
        

        
        
        


                        

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
        
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));

        
        // Set up row and col variables
        mov     x_row,  5
        mov     x_col,  5

        // Allocate 2d array of table
        
        
        mov     x_loc,     1
    
        mov     x15,    x_loc
        mul     x_loc,     x_loc,     x15
    
        mov     x15,    x_loc
        mul     x_loc,     x_loc,     x15
    
        mov     x15,    x_row
        mul     x_loc,     x_loc,     x15
    
        mov     x15,    x_col
        mul     x_loc,     x_loc,     x15
    
        mov     x15,    ta_val
        mul     x_loc,     x_loc,     x15
    

        sub     x_loc,     xzr,    x_loc
        and     x_loc,     x_loc,     -16
        add     sp,     sp,     x_loc

        
        mov     x27,     1
    
        mov     x15,    x27
        mul     x27,     x27,     x15
    
        mov     x15,    x_loc
        mul     x27,     x27,     x15
    
        mov     x15,    x_row
        mul     x27,     x27,     x15
    
        mov     x15,    1000
        mul     x27,     x27,     x15
    

        
    
    
        
        
    
        mov     x1,    x_loc
        
    
        ldr     x0,     =outstr
        bl      printf



        
        bl      rand                            // rand();
        and  	x9,     x0,     0xF              // int x9 = rand() & 0xF;
        mov     x27,     x9                      // x27 = x9;

        
    
    
        
        
    
        mov     x1,    x27
        
    
        ldr     x0,     =outstr
        bl      printf



end:    // Program end

        // Deallocate 2d array of table
        
        sub     x_loc,     xzr,    x_loc
        add     sp,     sp,     x_loc

        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
