        

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
        // csel    x19,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_0
        b       else_0
if_0:  mov     x19,     x9
        b       end_0
else_0:mov     x19,     x10
        b       end_0
end_0:

        
        
        
                 // row = min(row, max_row);
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    min_row
        // csel    x19,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_1
        b       else_1
if_1:  mov     x19,     x9
        b       end_1
else_1:mov     x19,     x10
        b       end_1
end_1:

        
        
        
                 // row = max(row, min_row);
        
        // M4: MIN
        mov     x9,     x20
        mov     x10,    max_col
        // csel    x20,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_2
        b       else_2
if_2:  mov     x20,     x9
        b       end_2
else_2:mov     x20,     x10
        b       end_2
end_2:

        
        
        
                 // col = min(col, max_col);
        
        // M4: MAX
        mov     x9,     x20
        mov     x10,    min_col
        // csel    x20,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_3
        b       else_3
if_3:  mov     x20,     x9
        b       end_3
else_3:mov     x20,     x10
        b       end_3
end_3:

        
        
        
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
loop_4:
        cmp     x9,     st_arr_amount                          // if reach amount
        b.eq    loop_end_4

        mov     x10,    int                          // get element size
        mul     x10,    x10,    x9                  // calculate element offset by 4
        
        mov     x11,    st_arr_base                          // get base
        add     x10,    x10,    x11                 // calculate total offset, offset in array + base

        str 	xzr,    [fp,    x10]                // initialize with 0

        add     x9,     x9,     1                   // increment
        b       loop_4

loop_end_4:

    
    

        
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

        // Top Docs
        mov     x0,     x28
        mov     x1,     -2
        mov     x2,     22
        bl      topRelevantDocs


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
        // csel    x27,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_5
        b       else_5
if_5:  mov     x27,     x9
        b       end_5
else_5:mov     x27,     x10
        b       end_5
end_5:

        
        
        
                     // int upper = max(m, n)
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    x20
        // csel    x28,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_6
        b       else_6
if_6:  mov     x28,     x9
        b       end_6
else_6:mov     x28,     x10
        b       end_6
end_6:

        
        
        
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
             // int 4 = t * table.row
                        
        // M4: ADD EQUAL
        add     x26, x26, x24
             // 4 += r

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







topRelevantDocs:        // topRelevantDocs(struct Table* table, int 1, int top)
        
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


        // Save pointer of table and other two parameters
        mov     x19,    x0                              // int pointer;
        mov     x20,    x1                              // int 1;
        mov     x21,    x2                              // int top;
        
        // Preventing invalid user input. Index cannot be greater than the table size or smaller than 0.
        // If smaller than 0, set to 0. If greater than table size, set to table size.
        
        // M4: MIN
        mov     x9,     x20
        mov     x10,    x23
        // csel    x20,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_7
        b       else_7
if_7:  mov     x20,     x9
        b       end_7
else_7:mov     x20,     x10
        b       end_7
end_7:

        
        
        
                             // 1 = min(1, table.column)
        
        // M4: MAX
        mov     x9,     x20
        mov     x10,    0
        // csel    x20,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_8
        b       else_8
if_8:  mov     x20,     x9
        b       end_8
else_8:mov     x20,     x10
        b       end_8
end_8:

        
        
        
                               // 1 = max(1, 0)
        
        // M4: MIN
        mov     x9,     x21
        mov     x10,    x22
        // csel    x21,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_9
        b       else_9
if_9:  mov     x21,     x9
        b       end_9
else_9:mov     x21,     x10
        b       end_9
end_9:

        
        
        
                             // top = min(top, table.row)
        
        // M4: MAX
        mov     x9,     x21
        mov     x10,    0
        // csel    x21,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_10
        b       else_10
if_10:  mov     x21,     x9
        b       end_10
else_10:mov     x21,     x10
        b       end_10
end_10:

        
        
        
                               // top = max(top, 0)

        // Read row and column from table struct
        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x22,     [x9]                    // load the value
        
             // int row = table.row;
        
        // M4: READ STRUCT
        mov     x11,    x19                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x23,     [x9]                    // load the value
        
             // int column = table.column;


        // Save pointer of table.array
        add     x19,    x19,    st_arr                  // int array_base = *table.array; get array base offset

        // Calculate memory alloc for WordFrequency array
        
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x22                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    wf_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -1                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x24,     x9                      // result
                     // int size = row * sizeof(struct WordFrequency) * -1
        and     x24,    x24,    -16                     // size = size & -16


        // Build WordFrequency array
        
        // M4: ALLOC
        add     sp,     sp,     x24              // allocate on SP

        mov     x25,    0                               // int t = 0;
        mov     x26,    0                               // int r = 0;
        
        topdoc_wq_struct_row:

                // Check for t - current 5 of row
                cmp     x25,    x22                     // if (t >= table.row)
                b.ge    topdoc_wq_struct_row_end        // {end}

                // Reset local variables
                mov     x26,    0                       // int r = 0;
                mov     x27,    0                       // int totalOccurence = 0;

                topdoc_wq_struct_col:

                        // Check for r - current 5 of column
                        cmp     x26,    x23             // if (r >= table.col)
                        b.ge    topdoc_wq_struct_col_end// {end}
                        
                        // Calculate current 5: (t * table.row) + r
                        
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x25                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    x22                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x17,     x9                      // result
             // int 4 = t * table.row
                        
        // M4: ADD EQUAL
        add     x17, x17, x26
             // 4 += r

                        // Read from array
                        
        // M4: READ ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    x17                          // x10 - 4
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     x19                  // calculate Offset += Base

        
        ldr     x18,     [x9]
             


                        // Add to totalOccurence
                        
        // M4: ADD EQUAL
        add     x27, x27, x18
             // totalOccurence += occurence;
                        

                        // Increment and loop
                        
        // M4: ADD ADD
        add     x26, x26, 1
                    // r ++;
                        b       topdoc_wq_struct_col    // go back to loop top

                topdoc_wq_struct_col_end:


                
        // M4: PRINT
    
    
        
        
    
        mov     x1,    x27
        
    
        mov     x2,    x27
        
    
        ldr     x0,     =output
        bl      printf




                
                // Increment and loop
                
        // M4: ADD ADD
        add     x25, x25, 1
                            // t ++;
                b       topdoc_wq_struct_row            // go back to loop top

        
        topdoc_wq_struct_row_end:


       
        // Dealloc WordFrequency array
        
        // M4: DEALLOC
        mov     x9,     x24                      // move to x9
        sub     x9,     xzr,    x9              // negate the size again to positive
        add     sp,     sp,     x9              // dealloc on SP


        
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


