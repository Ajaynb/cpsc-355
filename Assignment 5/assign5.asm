        include(`macros.m4')
        
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
        xrandSeed()

        // Limit the range of row and col as input validation
        xmin(w19, w19, max_row)                 // row = min(row, max_row);
        xmax(w19, w19, min_row)                 // row = max(row, min_row);
        xmin(w20, w20, max_col)                 // col = min(col, max_col);
        xmax(w20, w20, min_col)                 // col = max(col, min_col);

        // Construct struct Table
        xalloc(st_size)                         // allocate for struct Table
        xstruct(st, st_row, st_col)             // init struct Table attributes with 0
        

        // Deallocate memory
        xdealloc(st_size)                        // deallocate struct Table

        // Restores state
        ldp     fp,     lr,     [sp], dealloc   // deallocate stack memory
        ret                                     // return to calling code in OS

