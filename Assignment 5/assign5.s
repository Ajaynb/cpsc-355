        

























        // Defining strings
output: .string "%d, %d\n"
allstr:  .string "alloc %d, sp %d, fp %d\n"
        
        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 20
        max_col = 20
        min_row = 5
        min_col = 5

        // Equantes for data types
        int = 8

        // Equates for struct Table
        st = 0
        st_row = 0
        st_col = 8
        st_arr = 16
        st_arr_base = st + st_arr
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

main:   // main()
        
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!                // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
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


        mov     x19,    5
        mov     x20,    5


        // Construct struct Table
        
        // M4: ALLOC
        add     sp,     sp,     st_size              // allocate on SP
        // mov     fp,     sp                              // update FP to current SP
                         // allocate for struct Table
        
        // M4: STRUCT
    
    
        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_row
        add     x9,     x11,    x12             // add the size
        sub     x9,     xzr,    x9              // negate offset
        mov     x10,    xzr
        str     x10,    [fp,   x9]             // and Adds x10 to x9

        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_col
        add     x9,     x11,    x12             // add the size
        sub     x9,     xzr,    x9              // negate offset
        mov     x10,    xzr
        str     x10,    [fp,   x9]             // and Adds x10 to x9

        
        
    
             // init struct Table attributes with 0
        
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_row
        add     x9,     x11,    x12             // add the size
        sub     x9,     xzr,    x9              // negate offset
        mov     x10,    x19
        str     x10,    [fp,   x9]             // and Adds x10 to x9

        
        // M4: WRITE STRUCT
        mov     x11,    st
        mov     x12,    st_col
        add     x9,     x11,    x12             // add the size
        sub     x9,     xzr,    x9              // negate offset
        mov     x10,    x20
        str     x10,    [fp,   x9]             // and Adds x10 to x9



        mov     x19,    123
        mov     x20,    123

        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    alloc
        
    
        mov     x2,    sp
        
    
        mov     x3,    fp
        
    
        ldr     x0,     =allstr
        bl      printf


        add     x0,     fp,     st_row
        add     x1,     fp,     st_col
        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x0
        
    
        mov     x2,    x1
        
    
        ldr     x0,     =output
        bl      printf


        bl      initialize

        
exit:
        // Deallocate memory
        
        // M4: DEALLOC
        mov     x9,     st_size                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP
        // mov     fp,     sp                              // update FP to current SP
                       // deallocate struct Table

        
        // M4: RET

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








initialize: // initialize(struct Table* table)
	
        // M4: FUNC
        stp     fp,     lr,     [sp, alloc]!                // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
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


        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    alloc
        
    
        mov     x2,    sp
        
    
        mov     x3,    fp
        
    
        ldr     x0,     =allstr
        bl      printf



        //ldr     x19,    [x0]
        //ldr     x20,    [x1]


intiializein:

        
        // M4: RET

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




