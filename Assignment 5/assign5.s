        

        // Defining strings
output: .string "%d, %d\n"
allstr: .string "alloc %d, sp %d, fp %d\n"
        
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
        st = -alloc + 0
        st_row = 0
        st_col = 8
        st_arr = 16
        st_arr_base = st + st_arr
        st_arr_amount = max_row * max_col
        st_arr_size = st_arr_amount * int
        st_size = -(st_arr + st_arr_size + 16) & -16

        // Equates for struct Word Frequency
        wf_freqency = 0
        wf_word = 8
        wf_times = 16
        wf_document = 24
        wf_size = -(wf_document) & -16

        // Equates for array of word frequency
        wf_arr = (st + st_size + 16) & -16
        wf_arr_size = -(max_row * max_col * wf_size) & -16



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


        // Initialize values
        mov     x19,    5                       // int row = 5;
        mov     x20,    5                       // int col = 5;

        // Rand seed
        
        // M4: RAND SEED
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));


        // Limit the range of row and col as input validation
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    max_row
        csel    x19,     x9,     x10,    le
                 // row = min(row, max_row);
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    min_row
        csel    x19,     x9,     x10,    ge
                 // row = max(row, min_row);
        
        // M4: MIN
        mov     x9,     x20
        mov     x10,    max_col
        csel    x20,     x9,     x10,    le
                 // col = min(col, max_col);
        
        // M4: MAX
        mov     x9,     x20
        mov     x10,    min_col
        csel    x20,     x9,     x10,    ge
                 // col = max(col, min_col);

        // Construct struct Table
        
        // M4: ALLOC
        add     sp,     sp,     st_size              // allocate on SP
                         // allocate for struct Table
        
        // M4: STRUCT
    
    
        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        mov     x10,    xzr                      // int value
        
        
        str	x10,    [fp,   x9]              // store the value
        

        
        
    
        
            
        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        mov     x10,    xzr                      // int value
        
        
        str	x10,    [fp,   x9]              // store the value
        

        
        
    
             // init struct Table attributes with 0
        
        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        mov     x10,    x19                      // int value
        
        
        str	x10,    [fp,   x9]              // store the value
        
           // write the reset row to struct
        
        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        mov     x10,    x20                      // int value
        
        
        str	x10,    [fp,   x9]              // store the value
        
           // write the reset col to struct

        
        // M4: READ STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x21,     [fp,   x9]              // load the value
        

        
        // M4: READ STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x22,     [fp,   x9]              // load the value
        

        

        
        // M4: ARRAY
    
        mov     x9,     0                           // loop Counter
loop_0:
        cmp     x9,     st_arr_amount                          // if reach amount
        b.eq    loop_end_0

        mov     x10,    int                          // get element size
        mul     x10,    x10,    x9                  // calculate element offset by 4
        
        mov     x11,    st_arr_base                          // get base
        add     x10,    x10,    x11                 // calculate total offset, offset in array + base

        str 	xzr,    [fp,    x10]                // initialize with 0

        add     x9,     x9,     1                   // increment
        b       loop_0

loop_end_0:

    
    

        
        // M4: WRITE ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    0                          // x10 - 4
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     st_arr_base                  // calculate Offset += Base

        mov     x10,    18

        
        str     x10,    [fp,   x9]
        

        
        // M4: WRITE ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    1                          // x10 - 4
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     st_arr_base                  // calculate Offset += Base

        mov     x10,    19

        
        str     x10,    [fp,   x9]
        

        

        mov     x11,    st                      // int base
        mov     x12,    st_row                  // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        add     x9,     x9,     fp              // offset += fp

        mov     x0,     x9
        bl      initialize

        
        
        // M4: READ STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x24,     [fp,   x9]              // load the value
        

        
        // M4: READ STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x25,     [fp,   x9]              // load the value
        

        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x24
        
    
        mov     x2,    x25
        
    
        ldr     x0,     =output
        bl      printf



        
        // M4: READ ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    0                          // x10 - 3
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     st_arr_base                  // calculate Offset += Base

        
        ldr     x27,     [fp,   x9]
             

        
        // M4: READ ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    1                          // x10 - 3
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     st_arr_base                  // calculate Offset += Base

        
        ldr     x28,     [fp,   x9]
             

        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x27
        
    
        mov     x2,    x28
        
    
        ldr     x0,     =output
        bl      printf




        // Deallocate memory
        
        // M4: DEALLOC
        mov     x9,     st_size                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP
                       // deallocate struct Table

        
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




        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    alloc
        
    
        mov     x2,    sp
        
    
        mov     x3,    fp
        
    
        ldr     x0,     =allstr
        bl      printf







initialize: // initialize(struct Table* table)
	
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


        // Save pointer
        mov     x19,    x0                              // int pointer;
        
        // Read row and column from table struct
        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x20,     [x9]                    // load the value
        
             // int row = table.row;
        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x21,     [x9]                    // load the value
        
             // int column = table.column;
        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x20
        
    
        mov     x2,    x21
        
    
        ldr     x0,     =output
        bl      printf


        // Save pointer for table.array
        add     x19,    x19,    st_arr                  // int array_base; get array base offset

        // Calculate actual size
        mul     x26,    x20,    x21                     // int size = row * column;
        
        // For loop
        mov     x23,    0                               // int t = 0; current 3

        initialize_array:

                cmp     x23,    x26                     // if (t >= size)
                b.ge    initialize_array_end            // {end}

                mov     x0,     0
                mov     x1,     9
                bl      randomNum
                

                mov     x25,    x0                      // int random = rand()

                

                
        // M4: WRITE ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    x23                          // x10 - 3
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     x19                  // calculate Offset += Base

        mov     x10,    x25

        
        str     x10,    [x9]
        
   // table.array[t] = random




                
        // M4: ADD ADD
        add     x23, x23, 1
                            // t ++;

                b       initialize_array

        initialize_array_end:

        





        
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






randomNum: // randomNum(m, n)
	
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


        mov     x19,    x0                      // int m;
        mov     x20,    x1                      // int n;

        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x19
        
    
        mov     x2,    x20
        
    
        ldr     x0,     =output
        bl      printf



        cmp     x19,    x20                     // if (m == n)
        b.eq    randomNum_end                   // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    x20
        csel    x19,     x9,     x10,    ge
                     // int upper = max(m, n)
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    x20
        csel    x20,     x9,     x10,    le
                     // int lower = min(m, n)


        // Calculate range
        sub     x21,    x19,    x20             // int range = upper - lower
        
        // M4: ADD ADD
        add     x21, x21, 1
                             // range += 1;

        // Generate random number
        bl      rand

        // Limit range
        udiv    x22,    x0,     x21             // int quotient = rand / range;
        mul     x23,    x22,    x21             // int product = quotient * range
        sub     x24,    x0,     x23             // int remainder = rand - product

        mov     x0,     x24                     // return the remainder as the generated random number
       
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




