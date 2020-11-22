

        define(`g_counter',`0')dnl
        define(`g_count',`define(`g_counter',eval(g_counter+1))')dnl
        
        include(`alloc.m4')                     
        include(`array.m4')                    
        include(`forloop3.m4')                  
        include(`foreach2.m4')                  // Includes also qu0te.m4
        include(`print.m4')                     
        include(`minmax.m4')                    
        include(`rand.m4')                      
        include(`addAll.m4')                    
        include(`mulAll.m4')                    
        include(`struct.m4')                    

        

        // Defining the strings
outstr: .string "ALLOC size: %d\n"              // The output string
aloc:   .string "ALLOC[%d][%d](%d) = %d\n"
highocc:.string "HIGHEST %d\n"
tblhead:.string "Document   | Words              | Most Frequent | Percentage (Occurence / Total Occurence)\n----------------------------------------------------------------------------------------\n"
docstr: .string "Document %d |"                 // Doucment 4:
occstr: .string "%3.d "                         // Occurences
frqstr: .string "|        Word %d | %d%% (%d/%d)"                         // Frequency
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

        // Renaming x29 and x30 to FP and LR
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 16
        min_row = 4
        max_col = 16
        min_col = 4

        // Equates for 2d Array of table
        int = 8                                 // sizeof(int)

        // Equates for 5truct Document          // 5truct Document {
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

        // Random seed
        randomSeed()
        
        // Set up row and col variables
        mov     x_row,  5
        mov     x_col,  5

        // Limit the range of x_row and x_col as input validation
        min(x_row, x_row, max_row)
        max(x_row, x_row, min_row)
        min(x_col, x_col, max_col)
        max(x_col, x_col, min_col)

        
        // Allocate 2d Array for Table
        mulAll(x_2da, x_row,  x_col, int)
        alloc(x_2da)
        print(outstr, x_2da)

        // Allocate 1d Array for Structures
        mulAll(x_1da, x_row, sd)
        alloc(x_1da)
        print(outstr, x_1da)


generate_table:
        mov     x_crow, xzr

generate_table_row:
        cmp     x_crow, x_row
        b.eq    generate_table_row_end
        mov     x_ccol, xzr
        mov     x_hiocc, xzr

        // Calculate Index
        mulAll(x_off, x_crow, sd)
        addAll(x_off, x_off, x_1da, x_2da)
        print(outstr, x_off)

        // Construct Structure
        struct(x_off, sd_occ, sd_frq, sd_ind, sd_tocc)
        writeStruct(0, x_off, sd_occ)
        writeStruct(0, x_off, sd_frq)
        writeStruct(0, x_off, sd_tocc)
        writeStruct(x_crow, x_off, sd_ind)

        readStruct(x11, x_off, sd_ind)
        print(outstr, x11)


        generate_table_col:
        cmp     x_ccol, x_col
        b.eq    generate_table_col_end

        // Generate Random Number
        random(x11, 0xF)
        addEqual(x11, 1)

        // Calculate Index
        mulAll(x12, x_crow, x_col)
        addAll(x12, x12, x_ccol)

        // Write to 2d Array of Table
        writeArray(x11, x_2da, int, x12)

        // Add occurence to Structure total occurence
        readStruct(x12, x_off, sd_tocc)
        addAll(x10, x11, x12)
        writeStruct(x10, x_off, sd_tocc)

        // Check highest occurence & index
        cmp     x_hiocc,x11
        b.lt    struct_write
        b       struct_else
struct_write:
        mov     x_hiocc,x11
        mov     x_hiind,x_ccol
struct_else:

        // Print
        print(aloc, x_crow, x_ccol, x9, x11)

        addAdd(x_ccol)

        b       generate_table_col
        generate_table_col_end:

        // Write highest occurence & index
        writeStruct(x_hiocc, x_off, sd_occ)
        writeStruct(x_hiind, x_off, sd_ind)
        
        // Calculate Highest Frequency
        readStruct(x11, x_off, sd_tocc)
        mulAll(x_hiocc, x_hiocc, 100)
        sdiv    x_hiocc,    x_hiocc,    x11
        print(highocc, x11)
        print(highocc, x_hiocc)
        writeStruct(x_hiocc, x_off, sd_frq)

        addAdd(x_crow)
        b       generate_table_row
generate_table_row_end:



print_table:
        mov     x_crow, xzr
        mov     x_off,  xzr

        print(tblhead)

print_table_row:
        cmp     x_crow, x_row
        b.eq    print_table_row_end
        mov     x_ccol, xzr

        // Calculate Offset
        mulAll(x_off, x_crow, sd)
        addAll(x_off, x_off, x_1da, x_2da)

        // Print Document Index
        print(docstr, x_crow)


        print_table_col:
        cmp     x_ccol, x_col
        b.eq    print_table_col_end


        // Calculate Index
        mulAll(x12, x_crow, x_col)
        addAll(x12, x12, x_ccol)

        // Write to Array
        readArray(x11, x_2da, int, x12)

        // Print Current Word Occurence
        print(occstr, x11)


        addAdd(x_ccol)

        b       print_table_col
        print_table_col_end:


        readStruct(x11, x_off, sd_ind)
        readStruct(x12, x_off, sd_frq)
        readStruct(x13, x_off, sd_occ)
        readStruct(x14, x_off, sd_tocc)
        print(frqstr, x11, x12, x13, x14)
        
        print(linebr)


        addAdd(x_crow)
        b       print_table_row
print_table_row_end:


end:    // Program end

        // Deallocate 2d Array of table
        dealloc(x_1da)
        dealloc(x_2da)
        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
