        






















        
        // Equates for alloc & dealloc
        alloc = -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 20
        max_col = 20
        min_row = 5
        min_col = 5

        // Equates for struct Table
        st = 0
        st_row = st
        st_col = 4
        st_arr = 8
        st_size = (max_row * max_col + st_arr) & -16

        // Equates for struct Word Frequency
        wf = 0
        wf_freqency = 0
        wf_word = 4
        wf_times = 8
        wf_document = 12
        wf_size = (wf_document) & -16

        // Equates for array of word frequency
        wf_arr = (st_size + 16) & -16
        wf_arr_size = (max_row * max_col * wf_size) & -16



        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // Main function
        // Saves state
        stp     fp,     lr,     [sp, alloc]!    // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                      // update FP to current SP

        mov     w19,    5                       // int row = 5;
        mov     w20,    5                       // int col = 5;

        // Rand seed
        
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));


        // Limit the range of row and col as input validation
        
    
        cmp     w19,     max_row
        b.lt    if_0
        b       else_0
if_0:  mov    w19,     w19
        b       end_0
else_0:mov  w19,     max_row
        b       end_0
end_0:
    
    
                 // row = min(row, max_row);
        
    
        cmp     w19,     min_row
        b.gt    if_1
        b       else_1
if_1:  mov    w19,     w19
        b       end_1
else_1:mov  w19,     min_row
        b       end_1
end_1:
    
    
                 // row = max(row, min_row);
        
    
        cmp     w20,     max_col
        b.lt    if_2
        b       else_2
if_2:  mov    w20,     w20
        b       end_2
else_2:mov  w20,     max_col
        b       end_2
end_2:
    
    
                 // col = min(col, max_col);
        
    
        cmp     w20,     min_col
        b.gt    if_3
        b       else_3
if_3:  mov    w20,     w20
        b       end_3
else_3:mov  w20,     min_col
        b       end_3
end_3:
    
    
                 // col = max(col, min_col);

        // Construct struct Table
        
        add     sp,     sp,     st_size              // allocate on SP
                         // allocate for struct Table
        
    
    
        
        
    
        
        // add     x9,     st,     st_row               // add the size
        // str     xzr,    [x29,   x9]             // store value
        
        mov     x10,    st                      // base
        mov     x11,    st_row                      // attribute
        add     x9,     x10,    x11             // base + attribute
        mov     w12,    wzr
        str     w12,    [x29,   x9]             // and adds x10 to x9

        
        
    
        
        // add     x9,     st,     st_col               // add the size
        // str     xzr,    [x29,   x9]             // store value
        
        mov     x10,    st                      // base
        mov     x11,    st_col                      // attribute
        add     x9,     x10,    x11             // base + attribute
        mov     w12,    wzr
        str     w12,    [x29,   x9]             // and adds x10 to x9

        
        
    
                 // init struct Table
        
        mov     x10,    st                      // base
        mov     x11,    st_row                      // attribute
        add     x9,     x10,    x11             // base + attribute
        mov     w12,    w19
        str     w12,    [x29,   x9]             // and adds x10 to x9
           // table.row = row;
        
        mov     x10,    st                      // base
        mov     x11,    st_col                      // attribute
        add     x9,     x10,    x11             // base + attribute
        mov     w12,    w20
        str     w12,    [x29,   x9]             // and adds x10 to x9
           // table.col = col;


        // Deallocate memory
        
        mov     x9,     st_size                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP
                        // deallocate struct Table

        // Restores state
        ldp     fp,     lr,     [sp], dealloc   // deallocate stack memory
        ret                                     // return to calling code in OS

