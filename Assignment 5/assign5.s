        























        // Defining strings
output: .string "st_row %d, st_col %d\n"
        
        // Equates for alloc & dealloc
        alloc = -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 10
        max_col = 10
        min_row = 5
        min_col = 5

        // Equantes for data types
        int = 8

        // Equates for struct Table
        st = 0
        st_row = 0
        st_col = 8
        st_arr = 16
        st_arr_amount = max_row * max_col
        st_arr_size = st_arr_amount * int
        st_size = -(st_arr + st_arr_size + 16) & -16

        // Equates for struct Word Frequency
        wf = 0
        wf_freqency = 0
        wf_word = 8
        wf_times = 16
        wf_document = 24
        wf_size = -(wf_document) & -16

        // Equates for array of word frequency
        wf_arr = (st_size + 16) & -16
        wf_arr_size = -(max_row * max_col * wf_size) & -16



        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // Main function
        // Saves state
        stp     fp,     lr,     [sp, alloc]!    // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                      // update FP to current SP

        mov     x19,    5                       // int row = 5;
        mov     x20,    5                       // int col = 5;

        // Rand seed
        
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));


        // Limit the range of row and col as input validation
        
    
        cmp     x19,     max_row
        b.lt    if_0
        b       else_0
if_0:  mov    x19,     x19
        b       end_0
else_0:mov  x19,     max_row
        b       end_0
end_0:
    
    
                 // row = min(row, max_row);
        
    
        cmp     x19,     min_row
        b.gt    if_1
        b       else_1
if_1:  mov    x19,     x19
        b       end_1
else_1:mov  x19,     min_row
        b       end_1
end_1:
    
    
                 // row = max(row, min_row);
        
    
        cmp     x20,     max_col
        b.lt    if_2
        b       else_2
if_2:  mov    x20,     x20
        b       end_2
else_2:mov  x20,     max_col
        b       end_2
end_2:
    
    
                 // col = min(col, max_col);
        
    
        cmp     x20,     min_col
        b.gt    if_3
        b       else_3
if_3:  mov    x20,     x20
        b       end_3
else_3:mov  x20,     min_col
        b       end_3
end_3:
    
    
                 // col = max(col, min_col);

        // Construct struct Table
        
        add     sp,     sp,     st_size              // allocate on SP
                         // allocate for struct Table
        
    
    
        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_row
        add     x9,     x11,    x12            // Add the size
        sub     x9,     xzr,    x9
        mov     x10,    xzr
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_col
        add     x9,     x11,    x12            // Add the size
        sub     x9,     xzr,    x9
        mov     x10,    xzr
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        
        
    
             // init struct Table attributes with 0
        
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_row
        add     x9,     x11,    x12            // Add the size
        sub     x9,     xzr,    x9
        mov     x10,    x19
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_col
        add     x9,     x11,    x12            // Add the size
        sub     x9,     xzr,    x9
        mov     x10,    x20
        str     x10,    [x29,   x9]             // And Adds x10 to x9

        

        
    
    
        
        
    
        mov     x1,    x21
        
    
        mov     x2,    x22
        
    
        ldr     x0,     =output
        bl      printf


        
    
    
        
        
    
        mov     x1,    st_size
        
    
        mov     x2,    st_arr_size
        
    
        ldr     x0,     =output
        bl      printf


        // Deallocate memory
        
        mov     x9,     st_size                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP
                        // deallocate struct Table

        // Restores state
        ldp     fp,     lr,     [sp], dealloc   // deallocate stack memory
        ret                                     // return to calling code in OS

