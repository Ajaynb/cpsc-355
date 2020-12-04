        

        // Defining strings
output:         .string "%d, %d\n"
allstr:         .string "alloc %d, sp %d, fp %d\n"

str_table_head: .string "===== Table =====\n"
str_occ:        .string " %d "
str_linebr:     .string "\n"
str_test:       .string "table[%d][%d](%d): %d\n"
        
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

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


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
        

        

        // struct Table table;                  // x28
        mov     x28,    st                      // base
        add     x28,    x28,    fp              // offset = base + fp


        // Initialize table
        mov     x0,     x28
        bl      initialize                      // initialize(&table)

        // Display table
        mov     x0,     x28
        bl      display                         // display(&table)

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







initialize:     // initialize(struct Table* table)
	
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

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        // Save pointer of table
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

        // Save pointer of table.array
        add     x19,    x19,    st_arr                  // int array_base = *table.array; get array base offset

        // For loop
        mov     x23,    0                               // int t = 0; current 4
        mul     x26,    x20,    x21                     // int size = row * column;

        initialize_array:

                cmp     x23,    x26                     // if (t >= size)
                b.ge    initialize_array_end            // {end}

                // Generate random number
                mov     x0,     0
                mov     x1,     9
                bl      randomNum                       // randomNum(0, 9)

                // Write random number to array
                mov     x25,    x0                      // int random = rand()
                
        // M4: WRITE ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    x23                          // x10 - 4
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     x19                  // calculate Offset += Base

        mov     x10,    x25

        
        str     x10,    [x9]
        
   // table.array[t] = random

                // Increment and loop
                
        // M4: ADD ADD
        add     x23, x23, 1
                            // t ++;
                b       initialize_array                // go back to loop top

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






randomNum:      // randomNum(m, n)
	
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

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        mov     x19,    x0                      // int m;
        mov     x20,    x1                      // int n;

        cmp     x19,    x20                     // if (m == n)
        b.eq    randomNum_end                   // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    x20
        csel    x27,     x9,     x10,    ge
                     // int upper = max(m, n)
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    x20
        csel    x28,     x9,     x10,    le
                     // int lower = min(m, n)

        // Calculate range
        sub     x21,    x27,    x28             // int range = upper - lower
        
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







display:        // display(struct Table* table)
        
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

        // Reset registers to 0
        mov     x19,    0
        mov     x20,    0
        mov     x21,    0
        mov     x22,    0
        mov     x23,    0
        mov     x24,    0
        mov     x25,    0
        mov     x26,    0
        mov     x27,    0
        mov     x28,    0


        // Save pointer of table
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

        // Save pointer of table.array
        add     x19,    x19,    st_arr                  // int array_base = *table.array; get array base offset

        // Counters
        mov     x23,    0                               // int t = 0; current row 4
        mov     x24,    0                               // int r = 0; current col 4

        // Print table head
        
        // M4: PRINT
    
    
        
        
    
        ldr     x0,     =str_table_head
        bl      printf


        // For loop of row
        display_array_row:

                // Check for t - current 1 of row
                cmp     x23,    x20                     // if (t >= table.row)
                b.ge    display_array_row_end           // {end}


                mov     x24,    0                       // int r = 0; current col 1

                // For loop of column
                display_array_col:

                        // Check for r - current 1 of column
                        cmp     x24,    x21             // if (r >= table.col)
                        b.ge    display_array_col_end   // {end}

                        // Calculate current 1: (t * table.row) + r
                        
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x23                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    x20                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x26,     x9                      // result

                        
        // M4: ADD EQUAL
        add     x26, x26, x24


                        // Read from array
                        
        // M4: READ ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    x26                          // x10 - 4
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     x19                  // calculate Offset += Base

        
        ldr     x25,     [x9]
             

                        
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x25
        
    
        ldr     x0,     =str_occ
        bl      printf


                        // Increment and loop
                        
        // M4: ADD ADD
        add     x24, x24, 1
                    // r ++;
                        b       display_array_col       // go back to loop top

                display_array_col_end:


                // Print line break
                
        // M4: PRINT
    
    
        
        
    
        ldr     x0,     =str_linebr
        bl      printf


                // Increment and loop
                
        // M4: ADD ADD
        add     x23, x23, 1
                            // t ++;
                b       display_array_row               // go back to loop top

        display_array_row_end:


        
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


