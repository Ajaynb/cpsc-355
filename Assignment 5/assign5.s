        

        // Defining strings
output:         .string "%d, %d\n"
output_float:   .string "%f, %f\n"
output_str:     .string "%s\n"
allstr:         .string "alloc %d, sp %d, fp %d\n"
test_out:       .string "frq: %f, occurence: %d, word %d\n"

str_integer:    .string "%d"
str_table_head: .string "===== Table =====\n"
str_occ:        .string " %d "
str_linebr:     .string "\n"
str_test:       .string "table[%d][%d](%d): %d\n"
str_top_head:   .string "The top documents are: \n"
str_top_doc:    .string "Document %02d: Occurence of %d, Frequency of %.3f\n"
str_top_index:  .string "What is the index of the word you are searching for? "
str_top_amount: .string "How many top documents you want to retrieve? "
str_scan_again: .string "Do you want to search again? (0 = no / 1 = yes) "
str_ended:      .string "Ended.\n"

filename:       .string "test.txt"
filemode:       .string "a+"

        
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
        wf_occurence = 16
        wf_document = 24
        wf_size = -(wf_document) & -16

        // Array of WordFrequency
        wf_arr = -alloc + 0
        wf_arr_size = -(max_row * -wf_size) & -16

        // File operations
        AT_FDCWD = -100
        buffer = -alloc + 0
        buffer_size = 4




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
        mov     x19,    min_row                         // int row = 5;
        mov     x20,    min_col                         // int col = 5;

        // If command arguments contain row & col
        cmp     x0,     3                               // if (argc >= 3)
        b.ge    command_param                           // {read argument from command line}
        b       command_param_end                       // {do nothing}

        command_param:
                mov         x21, x1

                // Store row
                ldr         x0,         [x21, 8]
                bl         atoi
                mov        x19,         x0

                // Store column
                ldr        x0,         [x21, 16]
                bl         atoi
                mov         x20,         x0
        command_param_end:

        // If command arguments contain file name
        cmp     x0,     4                               // if (argc >= 4)
        b.ge    command_param_file                      // {read argument from command line}
        b       command_param_file_end                  // {do nothing}

        command_param_file:
                // Store arguments
                ldr x23, [x21, 24]                      // char* file = argv[3]
        command_param_file_end:

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
        
        
                mov     x10,    xzr              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

        
        
    
        
            
        
        

        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    xzr              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

        
        
    
                     // init struct Table attributes with 0
        
        
        

        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_row                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x19              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        
                   // write the reset row to struct
        
        
        

        // M4: WRITE STRUCT
        mov     x11,    st                      // int base
        mov     x12,    st_col                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x20              // int value
                
        
        
        
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
        



        // struct Table table;                          // x28
        mov     x28,    st                              // base
        add     x28,    x28,    fp                      // offset = base + fp



        // Initialize table
        mov     x0,     x28
        mov     x1,     x23
        bl      initialize                              // initialize(&table, file)

        // Display table
        mov     x0,     x28
        bl      display                                 // display(&table)

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_linebr
        bl      printf

        bl      logToFile




        main_topdoc_ask:

        // Ask for 1
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_top_index
        bl      printf

        bl      logToFile

        
        // M4: SCAN
        ldr     x0,     =str_integer                     // 1st parameter: scnocc, the formatted string
        ldr     x1,     =n                      // 2nd parameter: &n, the data to store for user input
        bl      scanf                           // scanf(scnocc, &n);
        ldr     x1,     =n                      // 2nd parameter: &n
        ldr     x27,    [x1]                     // int n = x1;
                         // int 1;

        // Ask for top document amount
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_top_amount
        bl      printf

        bl      logToFile

        
        // M4: SCAN
        ldr     x0,     =str_integer                     // 1st parameter: scnocc, the formatted string
        ldr     x1,     =n                      // 2nd parameter: &n, the data to store for user input
        bl      scanf                           // scanf(scnocc, &n);
        ldr     x1,     =n                      // 2nd parameter: &n
        ldr     x26,    [x1]                     // int n = x1;
                         // int top;

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_linebr
        bl      printf

        bl      logToFile

        
        // Run top docs
        mov     x0,     x28                             // pointer
        mov     x1,     x27                             // 1
        mov     x2,     x26                             // top
        bl      topRelevantDocs                         // topRelevantDocs(&table, 1, top)

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_linebr
        bl      printf

        bl      logToFile


        // Ask for search again
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_scan_again
        bl      printf

        bl      logToFile

        
        // M4: SCAN
        ldr     x0,     =str_integer                     // 1st parameter: scnocc, the formatted string
        ldr     x1,     =n                      // 2nd parameter: &n, the data to store for user input
        bl      scanf                           // scanf(scnocc, &n);
        ldr     x1,     =n                      // 2nd parameter: &n
        ldr     x25,    [x1]                     // int n = x1;

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_linebr
        bl      printf

        bl      logToFile


        cmp     x25,    1
        b.eq    main_topdoc_ask

        main_topdoc_ask_end:

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_ended
        bl      printf

        bl      logToFile

        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_linebr
        bl      printf

        bl      logToFile



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










initialize:     // initialize(struct Table* table, char* file)
        
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


        // Save pointer of table & file name
        mov     x19,    x0                              // int pointer;
        mov     x22,    x1                              // char* file;

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
        
        // Open file
        mov     w0,     -100                            // 1st arg (cwd)
        mov     x1,     x22                             // 2nd arg (pathname)        
        mov     w2,     0                               // 3rd arg (read-only)
        mov     w3,     0                               // 4th arg (not used)
        mov     x8,     56                              // openat I/O request - to open a file
        svc     0                                       // call system function
        mov     w18,    w0                              // int fd; Record FD
        
        // Check file opens
        cmp     w18,    0                               // Check if File Descriptor = -1 (error occured)
        b.ge    initialize_from_file                    // If no error branch over
        b       initialize_from_random
        

        // Initialize from given file
        initialize_from_file:
        
        // For loop
        mov     x23,    0                               // int t = 0; current 1
        mul     x26,    x20,    x21                     // int size = row * column;

        initialize_array_file:

                cmp     x23,    x26                     // if (t >= size)
                b.ge    initialize_array_file_end       // {end}

                // Read number
                mov     w0,     w18                     // 1st arg (fd)
                add     x1,     fp,     buffer          // 2nd arg (buffer)
                mov     w2,     buffer_size             // 3rd arg (n) - how many bytes to read from buffer each time
                mov     x8,     63                      // read I/O request
                svc     0                               // call system function
                mov     w17,    w0                      // int actualSize; Record number of bytes actually read

                // Judge if read successfully
                cmp     w17,    buffer_size             // if (nread != buffersize)
                b.eq    initialize_file_read_success    // {load to register}
                b.ne    initialize_file_read_fail       // {set to 0}

                // Read success, load the number to register
                initialize_file_read_success:
                ldr     x25,    [sp, buffer]            // 2nd arg (load string from buffer)
                b       initialize_file_write           // write to array

                // Read fail, set the register to default 0
                initialize_file_read_fail:
                mov     x25,    0                       // set to 0
                b       initialize_file_write           // write to array

                // Write the number to array
                initialize_file_write:
                
        // M4: WRITE ARRAY
        mov     x9,     int                          // x9 - size
        mov     x10,    x23                          // x10 - 1
        mul     x9,     x9,     x10                 // calculate Offset = Size * Index
        add     x9,     x9,     x19                  // calculate Offset += Base

        mov     x10,    x25

        
        str     x10,    [x9]
        
   // table.array[t] = random

                // Increment and loop
                
        // M4: ADD ADD
        add     x23, x23, 1
                            // t ++;
                b       initialize_array_file           // go back to loop top

        initialize_array_file_end:


        b       initialize_array_end
        

        // Initialize from random numbers
        initialize_from_random:

        // For loop
        mov     x23,    0                               // int t = 0; current 1
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
        mov     x10,    x23                          // x10 - 1
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


        initialize_end:
        
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


        mov     x19,    x0                              // int m;
        mov     x20,    x1                              // int n;

        cmp     x19,    x20                             // if (m == n)
        b.eq    randomNum_end                           // {skip everything to the end}, to return m itself

        // For protection, check again the lower and upper bound
        
        // M4: MAX
        mov     x9,     x19
        mov     x10,    x20
        // csel    x27,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_4
        b       else_4
if_4:  mov     x27,     x9
        b       end_4
else_4:mov     x27,     x10
        b       end_4
end_4:

        
        
        
                             // int upper = max(m, n)
        
        // M4: MIN
        mov     x9,     x19
        mov     x10,    x20
        // csel    x28,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_5
        b       else_5
if_5:  mov     x28,     x9
        b       end_5
else_5:mov     x28,     x10
        b       end_5
end_5:

        
        
        
                             // int lower = min(m, n)

        // Calculate range
        sub     x21,    x27,    x28                     // int range = upper - lower
        
        // M4: ADD ADD
        add     x21, x21, 1
                                    // range += 1;

        // Generate random number
        bl      rand

        // Limit range
        udiv    x22,    x0,     x21                     // int quotient = rand / range;
        mul     x23,    x22,    x21                     // int product = quotient * range
        sub     x24,    x0,     x23                     // int remainder = rand - product

        mov     x0,     x24                             // return the remainder as the generated random number
       
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
        mov     x23,    0                               // int t = 0; current row 1
        mov     x24,    0                               // int r = 0; current col 1

        // Print table head
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_table_head
        bl      printf

        bl      logToFile


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

        bl      logToFile


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

        bl      logToFile


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


        // Save pointer of table and other two integer parameters
        mov     x19,    x0                              // int pointer;
        mov     x20,    x1                              // int 1;
        mov     x21,    x2                              // int top;

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
        
        // Preventing invalid user input. Index cannot be greater than the table size or smaller than 0.
        // If smaller than 0, set to 0. If greater than table size, set to table size.
        sub     x18,    x23,    1                       // table.column - 1
        
        // M4: MIN
        mov     x9,     x20
        mov     x10,    x18
        // csel    x20,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_6
        b       else_6
if_6:  mov     x20,     x9
        b       end_6
else_6:mov     x20,     x10
        b       end_6
end_6:

        
        
        
                             // 1 = min(1, table.column - 1)
        
        // M4: MAX
        mov     x9,     x20
        mov     x10,    0
        // csel    x20,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_7
        b       else_7
if_7:  mov     x20,     x9
        b       end_7
else_7:mov     x20,     x10
        b       end_7
end_7:

        
        
        
                               // 1 = max(1, 0)
        
        // M4: MIN
        mov     x9,     x21
        mov     x10,    x22
        // csel    x21,     x9,     x10,    le

        

        cmp     x9,     x10
        b.lt    if_8
        b       else_8
if_8:  mov     x21,     x9
        b       end_8
else_8:mov     x21,     x10
        b       end_8
end_8:

        
        
        
                             // top = min(top, table.row)
        
        // M4: MAX
        mov     x9,     x21
        mov     x10,    0
        // csel    x21,     x9,     x10,    ge

        

        cmp     x9,     x10
        b.gt    if_9
        b       else_9
if_9:  mov     x21,     x9
        b       end_9
else_9:mov     x21,     x10
        b       end_9
end_9:

        
        
        
                               // top = max(top, 0)



        // Save pointer of table.array
        add     x19,    x19,    st_arr                  // int array_base = *table.array; get array base offset


        // Build WordFrequency array
        
        // M4: ALLOC
        add     sp,     sp,     wf_arr_size              // allocate on SP

        mov     x25,    0                               // int t = 0;
        mov     x26,    0                               // int r = 0;
        
        topdoc_wq_struct_row:

                // Check for t - current 1 of row
                cmp     x25,    x22                     // if (t >= table.row)
                b.ge    topdoc_wq_struct_row_end        // {end}

                // Reset local variables
                mov     x26,    0                       // int r = 0;
                mov     x27,    0                       // int totalOccurence = 0;

                // Calculate array offset
                
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x25                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -wf_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x28,     x9                      // result
                // int offset = t * sizeof(struct WordFrequency)
                add     x28,    x28,    wf_arr          // offset += base
                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x25              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        
     // array[t].document = t;
                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_word                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x20              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        
         // array[t].word = 4;

                topdoc_wq_struct_col:

                        // Check for r - current 4 of column
                        cmp     x26,    x23             // if (r >= table.col)
                        b.ge    topdoc_wq_struct_col_end// {end}
                        
                        // Calculate current 4: (t * table.row) + r
                        
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

        
        ldr     x24,     [x9]
             


                        // Add to totalOccurence
                        
        // M4: ADD EQUAL
        add     x27, x27, x24
             // totalOccurence += occurence;
                        
                        // Store 4's occurence
                        cmp     x26,    x20             // if (r == 4)
                        b.eq    topdoc_write_occ        // {write}
                        b       topdoc_write_occ_end    // {do nothing}

                        topdoc_write_occ:
                                // array[t].occurence = occurence;
                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x24              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                        topdoc_write_occ_end:

                        // Increment and loop
                        
        // M4: ADD ADD
        add     x26, x26, 1
                    // r ++;
                        b       topdoc_wq_struct_col    // go back to loop top

                topdoc_wq_struct_col_end:


                // Get occurence
                
        // M4: READ STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x24,     [fp,   x9]              // load the value
        


                // Convert registers
                scvtf   d24,    x24
                scvtf   d27,    x27
    
                // Calculate frequency and write to struct
                fdiv    d24,    d24,    d27             // int frequency = occurence / totalOccurence;
                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                fmov    d10,    d24              // float value
                
        
        
        
        str	d10,    [fp,   x9]              // store the value
        



                // Increment and loop
                
        // M4: ADD ADD
        add     x25, x25, 1
                            // t ++;
                b       topdoc_wq_struct_row            // go back to loop top

        
        topdoc_wq_struct_row_end:




        // Bubble sort
        mov     x25,    0                               // int t = 0;
        mov     x26,    0                               // int r = 0;
        mov     x27,    0                               // int base1 = 0;
        mov     x28,    0                               // int base2 = 0;
        fmov    d27,    xzr                             // double frequency1 = 0;
        fmov    d28,    xzr                             // double frequency2 = 0;

        topdoc_bubble_row:

                // Check for t - current 4 of row
                cmp     x25,    x22                     // if (t >= table.row)
                b.ge    topdoc_bubble_row_end           // {end}

                // Reset local variables
                mov     x26,    0                       // int r = 0;

                topdoc_bubble_row2:

                        // Check for r - current 4 of column
                        sub     x18,    x23,    1       // table.row - 1
                        cmp     x26,    x18             // if (r >= table.row - 1)
                        b.ge    topdoc_bubble_row2_end  // {end}

                        // Calculate array offset for rth struct WordFrequency
                        
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x26                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -wf_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x27,     x9                      // result
                // int offset = r * sizeof(struct WordFrequency)
                        add     x27,    x27,    wf_arr          // offset += base

                        // Calculate array offset for (r + 1)th struct WordFrequency
                        add     x18,    x26,    1
                        
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x18                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -wf_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x28,     x9                      // result
                // int offset = (r + 1) * sizeof(struct WordFrequency)
                        add     x28,    x28,    wf_arr          // offset += base
                        
                        
        // M4: READ STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	d27,     [fp,   x9]              // load the value
        
      // frequency1 = array[r].frequency
                        
        // M4: READ STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	d28,     [fp,   x9]              // load the value
        
      // frequency2 = array[r + 1].frequency

                        fcmp     d27,    d28                    // if (frequency1 < frequency2)
                        b.lt    topdoc_bubble_swap              // {swap two structs}
                        b       topdoc_bubble_swap_end          // {do nothing}

                        topdoc_bubble_swap:
                                
                                // Swap frequency
                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                fmov    d10,    d28              // float value
                
        
        
        
        str	d10,    [fp,   x9]              // store the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                fmov    d10,    d27              // float value
                
        
        
        
        str	d10,    [fp,   x9]              // store the value
        


                                // Swap document
                                
        // M4: READ STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x17,     [fp,   x9]              // load the value
        

                                
        // M4: READ STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x18,     [fp,   x9]              // load the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x17              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x18              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                                
                                // Swap occurence
                                
        // M4: READ STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x17,     [fp,   x9]              // load the value
        

                                
        // M4: READ STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x18,     [fp,   x9]              // load the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x17              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x18              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                                
                                // Swap word
                                
        // M4: READ STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_word                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x17,     [fp,   x9]              // load the value
        

                                
        // M4: READ STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_word                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x18,     [fp,   x9]              // load the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x28                      // int base
        mov     x12,    wf_word                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x17              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        

                                
        
        

        // M4: WRITE STRUCT
        mov     x11,    x27                      // int base
        mov     x12,    wf_word                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        
        
                mov     x10,    x18              // int value
                
        
        
        
        str	x10,    [fp,   x9]              // store the value
        


                        topdoc_bubble_swap_end:
                        
                        // Increment and loop
                        
        // M4: ADD ADD
        add     x26, x26, 1
                    // r ++;
                        b       topdoc_bubble_row2      // go back to loop top


                topdoc_bubble_row2_end:

                // Increment and loop
                
        // M4: ADD ADD
        add     x25, x25, 1
                            // t ++;
                b       topdoc_bubble_row               // go back to loop top

        topdoc_bubble_row_end:


        // Print result
        mov     x25,    0                               // int t = 0;
        mov     x24,    0                               // int offset = 0;
        
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        ldr     x0,     =str_top_head
        bl      printf

        bl      logToFile
                            // print header

        topdoc_print:

                // Check for t - current 1 of row
                cmp     x25,    x21                     // if (t >= top)
                b.ge    topdoc_print_end                // {end}

                
                
        // M4: MUL
    
        mov     x9,     1                       // initialize x9 to 1
    
        
        
    
        
        mov     x10,    x25                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        
        mov     x10,    -wf_size                       // move next multiplier to x10
        mul     x9,     x9,     x10             // and multiplies x10 to x9
        
        
    
        mov     x24,     x9                      // result
                // int offset = r * sizeof(struct WordFrequency)
                add     x24,    x24,    wf_arr          // offset += base
                
                
        // M4: READ STRUCT
        mov     x11,    x24                      // int base
        mov     x12,    wf_document                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x26,     [fp,   x9]              // load the value
        

                
        // M4: READ STRUCT
        mov     x11,    x24                      // int base
        mov     x12,    wf_occurence                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	x27,     [fp,   x9]              // load the value
        

                
        // M4: READ STRUCT
        mov     x11,    x24                      // int base
        mov     x12,    wf_freqency                      // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute

        
        ldr	d28,     [fp,   x9]              // load the value
        


                
        // M4: PRINT
    
    
    

    
        
        
        
                
                
        

        
    
        
        
        
                mov     x1,    x26
                
        

        
    
        
        
        
                mov     x2,    x27
                
        

        
    
        
        
        
                fmov     d0,    d28
                
        

        
    
        ldr     x0,     =str_top_doc
        bl      printf

        bl      logToFile


                
                // Increment and loop
                
        // M4: ADD ADD
        add     x25, x25, 1
                            // t ++;
                b       topdoc_print                    // go back to loop top


        topdoc_print_end:
        


        
        // Dealloc WordFrequency array
        
        // M4: DEALLOC
        mov     x9,     wf_arr_size                      // move to x9
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






logToFile:
        
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


        str     x0,     [fp, 96]
        str     x1,     [fp, 104]
        str     x2,     [fp, 112]

        // Open log file
        ldr     x0, =filename
        ldr     x1, =filemode
        bl      fopen
        mov     x19, x0

        
        mov     x0,     x19
        mov     x2,     x1
        mov     x3,     x2
        mov     x4,     x3
        mov     x5,     x4
        mov     x6,     x5
        mov     x7,     x6
        ldr     x1,     [fp, 96]
        ldr     x2,     [fp, 104]
        ldr     x3,     [fp, 112]
        bl      fprintf


        mov     x0, x19
        bl      fclose

        
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







        .data                                            // global variables
n:      .int    0                                        // int n = 0

