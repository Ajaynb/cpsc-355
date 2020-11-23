

        define(`g_counter',`0')dnl
        define(`g_count',`define(`g_counter',eval(g_counter+1))')dnl
        
        include(`alloc.m4')                     
        include(`array.m4')                    
        include(`forloop3.m4')                  
        include(`foreach2.m4')                  // Includes qu0te.m4
        include(`print.m4')                     
        include(`minmax.m4')                    
        include(`rand.m4')                      
        include(`addAll.m4')                    
        include(`mulAll.m4')                    
        include(`struct.m4')                    

        

        // Defining the strings
tblhead:.string "Document   | Words              | Most Frequent | Frequency (Occurence / Total Occurence)\n------------------------------------------------------------------------------------------\n"
docstr: .string "Document %d |"
occstr: .string "%3.d "
frqstr: .string "|        Word %d | %d%% (%d/%d)"
linebr: .string "\n"

        // Renaming registers
        x_row   .req    x19                     // row of table
        x_col   .req    x20                     // column of table
        x_2da   .req    x21                     // 2d Array of Table
        x_1da   .req    x22                     // 5truct documents Array

        x_off   .req    x23                     // current offset
        x_crow  .req    x24                     // current row index
        x_ccol  .req    x25                     // current column index
        x_hiocc .req    x26                     // highest occurence
        x_hiind .req    x27                     // highest index
        x_argv  .req    x28

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

        // Equates for Structucture Document    // Struct Document {
        sd_occ = 0                              //     int hiOccurence;
        sd_frq = 8                              //     int hiFrequency;
        sd_ind = 16                             //     int hiIndex;
        sd_tocc = 32                            //     int totalOccurence;
        sd = 40                                 // };

        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // Main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!      // space stack pointer
        mov     x29,    sp                      // frame-pointer = stack-pointer;

        
        // Set up row and col variables
        mov     x_row,  0                       // Intialize a default value
        mov     x_col,  0                       // Intialize a default value

        cmp     x0,     3                       // if (argc >= 3);              If the command argument amount is at least 3
        b.ge    command_param                   // then {command_param}         Read arguments
        b       command_param_skip              // else {command_param_skip}    Else skip

command_param:
        mov 	x_argv, x1                      //                              Store argv to the variable
        ldr 	x0, 	[x_argv, 8]             // Argument 1: argv[0]
        bl 	atoi                            // atoi(argv[0])
        mov	x_row, 	x0                      // int row = atoi(argv[0])

        ldr	x0, 	[x_argv, 16]            // Argument 1: argv[1]
        bl 	atoi                            // atoi(argv[1])
        mov 	x_col, 	x0                      // int col = atoi(argv[1])
command_param_skip:


        // Random seed
        randomSeed()

        // Limit the range of row and col as input validation
        min(x_row, x_row, max_row)              // x_row = Min(x_row, max_row);
        max(x_row, x_row, min_row)              // x_row = Max(x_row, min_row);
        min(x_col, x_col, max_col)              // x_col = Min(x_col, max_col);
        max(x_col, x_col, min_col)              // x_col = Max(x_col, min_col);

        
        // Allocate 2d Array for Table
        mulAll(x_2da, x_row,  x_col, int)       // x_2da = x_row * x_col * int; Calculate memory size of 2d Array of the Table
        alloc(x_2da)                            //                              Allocate x_2da size of memory

        // Allocate 1d Array for Structures
        mulAll(x_1da, x_row, sd)                // x_1da = x_row * sd; Calculate memory size of 1d Array of Structures
        alloc(x_1da)                            //                              Allocate x_1da size of memory

generate_table:
        mov     x_crow, xzr                     // x_crow = 0; Set current row index to 0

generate_table_row:                             // Start of the while loop
        cmp     x_crow, x_row                   // if (x_crow == x_row)         If the current row index reaches the row amount
        b.eq    generate_table_row_end          // {generate_table_row_end}     then go to generate_table_row_end to end the loop
        mov     x_ccol, xzr                     // x_ccol = 0;                  Set current column index to 0
        mov     x_hiocc, xzr                    // x_hiocc = 0;                 Set the current highest occurence to 0

        // Calculate Index
        mulAll(x_off, x_crow, sd)               // x_off = x_crow * sd;         Calculate offset of the current element in 1d Array of Structures
        addAll(x_off, x_off, x_1da, x_2da)      // x_off = x_off + x_1da + x_2da;

        // Construct Structure
        struct(x_off, sd_occ, sd_frq, sd_ind, sd_tocc)  // Construct the Structure
        writeStruct(0, x_off, sd_occ)           // Initialize 0 to the Structure document.hiOccurence
        writeStruct(0, x_off, sd_frq)           // Initialize 0 to the Structure document.hiFrequency
        writeStruct(0, x_off, sd_tocc)          // Initialize 0 to the Structure document.totalOccurence
        writeStruct(0, x_off, sd_ind)           // Initialize 0 to the Structure document.occurence


        generate_table_col:                     // Start of the while loop
        cmp     x_ccol, x_col                   // if (x_ccol == x_col)         If current column index reached the column amount
        b.eq    generate_table_col_end          // {generate_table_col_end}     then go to generate_table_col_end to end the loop

        // Generate Random Number
        random(x11, 0xF)                        // int rand = Random(15);       Generate a Random number from 0 to 15
        addEqual(x11, 1)                        // rand += 1;                   Let the range be 1 to 16

        // Calculate Index
        mulAll(x12, x_crow, x_col)              // int index = x_crow * x_col; 
        addAll(x12, x12, x_ccol)                // index = index + x_ccol;      Calculate current index in the 2d Array of the Table

        // Write to 2d Array of Table
        writeArray(x11, x_2da, int, x12)        // x_2da[index] = rand; Write the Random number to the Array

        // Add occurence to Structure total occurence
        readStruct(x12, x_off, sd_tocc)         // int totalOccurence = x_1da[x_off].tocc;              Read the total occurence from the current Structure from the 1d Array of Structure
        addAll(x10, x11, x12)                   // int newTotalOccurnece = totalOccurence + rand;       Calculate the new total occurence
        writeStruct(x10, x_off, sd_tocc)        // x_1da[x_off].tocc = newTotalOccurnece;               Write back the new total occurence to the Structure

        // Check highest occurence & index
        cmp     x_hiocc,x11                     // if (x_hiocc < rand)          If the current rand value is greater than the highest occurence
        b.lt    struct_write                    // {struct_write}               then go to struct_write to overwrite the value
        b       struct_else                     // else{}                       otherwise do nothing
struct_write:
        mov     x_hiocc,x11                     // x_hiocc = rand;              Set the highest value to rand as the new highest one
        mov     x_hiind,x_ccol                  // x_hiind = x_ccol;            Set the highest index to the current index
struct_else:

        addAdd(x_ccol)                          // x_ccol ++;                   Index increment
        b       generate_table_col              // Go back to the loop top
        generate_table_col_end:                 // End of while loop

        // Write highest occurence & index
        writeStruct(x_hiocc, x_off, sd_occ)     // x_1da[x_off].occurence = x_hiocc             Write the hiOccurent to the Structure
        writeStruct(x_hiind, x_off, sd_ind)     // x_1da[x_off].index = x_hiind                 Write the hiIndex to the Structure
        
        // Calculate Highest Frequency
        readStruct(x11, x_off, sd_tocc)         // int totalOccurence = x_1da[x_off].tocc;      Read the total occurence from the Structure
        mulAll(x_hiocc, x_hiocc, 100)           // x_hiocc = x_hiocc * 100;                         
        sdiv    x_hiocc,    x_hiocc,    x11     // x_hiocc = x_hiocc / totalOccurence;          Divide to get the frequency
        writeStruct(x_hiocc, x_off, sd_frq)     // x_1da[x_off].frequency = x_hiocc;            Write the highest frequency to the Structure

        addAdd(x_crow)                          // x_crow ++;                                   Index increment
        b       generate_table_row              // Go back to the top
generate_table_row_end:                         // End of while loop



print_table:
        mov     x_crow, xzr                     // x_crow = 0; Set current row index to 0
        mov     x_off,  xzr                     // x_off = 0; Set current offset to 0

        print(tblhead)                          // Print table head

print_table_row:                                // Start of the while loop
        cmp     x_crow, x_row                   // if (x_crow == x_row)         If current row index reached the row amount
        b.eq    print_table_row_end             // {print_table_row_end}        then go to print_table_row_end to end the loop
        mov     x_ccol, xzr                     // x_ccol = 0;                  Intialize 0 to the current column index

        // Calculate Offset
        mulAll(x_off, x_crow, sd)               // x_off = x_crow * sd;
        addAll(x_off, x_off, x_1da, x_2da)      // x_off = x_off + x_1da + x_2da;

        // Print Document Index
        print(docstr, x_crow)                   //                              Print the document index


        print_table_col:                        // Start of the while loop
        cmp     x_ccol, x_col                   // if (x_ccol == x_col)         If current column index reached the column amount
        b.eq    print_table_col_end             // {print_table_col_end}        then go to print_table_col_end to end the loop


        // Calculate Index
        mulAll(x12, x_crow, x_col)              // int index = x_crow + x_col;
        addAll(x12, x12, x_ccol)                // index = index + x_ccol;      Calculate current index in the 2d Array of the Table

        // Read from Array
        readArray(x11, x_2da, int, x12)         // int occ = x_2da[index];      Read the occurence of current word from 2d Array of the Table

        // Print Current Word Occurence
        print(occstr, x11)                      //                              Print the word occurence


        addAdd(x_ccol)                          // x_ccol ++;                   Index increment

        b       print_table_col                 // Go back to the loop
        print_table_col_end:                    // End of the while loop

        // Print out the highest frequency word
        readStruct(x11, x_off, sd_ind)          // int hiIndex = x_1da[x_off].sd_ind;
        readStruct(x12, x_off, sd_frq)          // int hiFrequency = x_1da[x_off].sd_frq;
        readStruct(x13, x_off, sd_occ)          // int hiOccurence = x_1da[x_off].sd_occ;
        readStruct(x14, x_off, sd_tocc)         // int totalOccurence = x_1da[x_off].sd_tocc;
        print(frqstr, x11, x12, x13, x14)       // Print(frqstr, hiIndex, hiFrequency, hiOccurence, totalOccurence);
        
        print(linebr)                           // Print line break


        addAdd(x_crow)                          // x_crow ++;                   Index increment
        b       print_table_row                 // Go back to the loop
print_table_row_end:                            // End of the while loop


end:    // Program end

        // Deallocate 2d Array of table
        dealloc(x_1da)                          // Deallocate 1d Array
        dealloc(x_2da)                          // Deallocate 2d Array
        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
