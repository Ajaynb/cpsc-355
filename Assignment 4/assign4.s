

                        
                             
                            
                          
        
                  // Includes qu0te.m4
                             
                            
                              
        

                    
        

                    
                            

        

        // Defining the strings
outstr: .string "ALLOC size: %d\n"
aloc:   .string "ALLOC[%d][%d](%d) = %d\n"
highocc:.string "HIGHEST %d\n"
tblhead:.string "Document   | Words              | Most Frequent | Percentage (Occurence / Total Occurence)\n------------------------------------------------------------------------------------------\n"
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

        // Random seed
        
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));


        // Set up row and col variables
        mov     x_row,  5
        mov     x_col,  5

        // Limit the range of row and col as input validation
        
    
        cmp     x_row,     max_row
        b.lt    if_0
        b       else_0
if_0:   mov    x_row,     x_row
        b       end_0
else_0: mov  x_row,     max_row
        b       end_0
end_0:
    
    
              // x_row = Min(x_row, max_row);
        
    
        cmp     x_row,     min_row
        b.gt    if_1
        b       else_1
if_1:   mov    x_row,     x_row
        b       end_1
else_1: mov  x_row,     min_row
        b       end_1
end_1:
    
    
              // x_row = Max(x_row, min_row);
        
    
        cmp     x_col,     max_col
        b.lt    if_2
        b       else_2
if_2:   mov    x_col,     x_col
        b       end_2
else_2: mov  x_col,     max_col
        b       end_2
end_2:
    
    
              // x_col = Min(x_col, max_col);
        
    
        cmp     x_col,     min_col
        b.gt    if_3
        b       else_3
if_3:   mov    x_col,     x_col
        b       end_3
else_3: mov  x_col,     min_col
        b       end_3
end_3:
    
    
              // x_col = Max(x_col, min_col);

        
        // Allocate 2d Array for Table
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_row                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    int                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_2da,     x9                      // Result
       // x_2da = x_row * x_col * int; Calculate memory size of 2d Array of the Table
        
        
cmp     x_2da,     xzr                             // Compare negative
        b.gt    if_4                           // Not negative
        b       else_4                         

if_4:   sub     x_2da,     xzr,    x_2da              // Negate the size
else_4:
        
        and     x_2da,     x_2da,     -16             // And -16
        add     sp,     sp,     x_2da              // Allocate on SP

        

                            //                              Allocate x_2da size of memory
        
    
    
        
        
    
        mov     x1,    x_2da
        
    
        ldr     x0,     =outstr
        bl      printf


        // Allocate 1d Array for Structures
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_row                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_1da,     x9                      // Result
                // x_1da = x_row * sd; Calculate memory size of 1d Array of Structures
        
        
cmp     x_1da,     xzr                             // Compare negative
        b.gt    if_5                           // Not negative
        b       else_5                         

if_5:   sub     x_1da,     xzr,    x_1da              // Negate the size
else_5:
        
        and     x_1da,     x_1da,     -16             // And -16
        add     sp,     sp,     x_1da              // Allocate on SP

        

                            //                              Allocate x_1da size of memory
        
    
    
        
        
    
        mov     x1,    x_1da
        
    
        ldr     x0,     =outstr
        bl      printf



generate_table:
        mov     x_crow, xzr                     // x_crow = 0; Set current row 2 to 0

generate_table_row:                             // Start of the while loop
        cmp     x_crow, x_row                   // if (x_crow == x_row)         If the current row 2 reaches the row amount
        b.eq    generate_table_row_end          // {generate_table_row_end}     then go to generate_table_row_end to end the loop
        mov     x_ccol, xzr                     // x_ccol = 0;                  Set current column 2 to 0
        mov     x_hiocc, xzr                    // x_hiocc = 0;                 Set the current highest occurence to 0

        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result
               // x_off = x_crow * sd;         Calculate offset of the current element in 1d Array of Structures
        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x_off                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_1da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_2da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x_off,     x9                      // Result
      // x_off = x_off + x_1da + x_2da; 
        
    
    
        
        
    
        mov     x1,    x_off
        
    
        ldr     x0,     =outstr
        bl      printf


        // Construct Structure
        
    
    
        
        
    
        
        add     x9,     x_off,     sd_occ               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
        
        add     x9,     x_off,     sd_frq               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
        
        add     x9,     x_off,     sd_ind               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
        
        add     x9,     x_off,     sd_tocc               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        
        
    
  // Construct the Structure
        
        add     x9,     x_off,     sd_occ              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9
           // Initialize 0 to the Structure document.hiOccurence
        
        add     x9,     x_off,     sd_frq              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9
           // Initialize 0 to the Structure document.hiFrequency
        
        add     x9,     x_off,     sd_tocc              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9
          // Initialize 0 to the Structure document.totalOccurence
        
        add     x9,     x_off,     sd_ind              // Add the size
        mov     x10,    0
        str     x10,    [x29,   x9]             // And Adds x10 to x9
           // Initialize 0 to the Structure document.occurence


        generate_table_col:                     // Start of the while loop
        cmp     x_ccol, x_col                   // if (x_ccol == x_col)         If current column 6 reached the column amount
        b.eq    generate_table_col_end          // {generate_table_col_end}     then go to generate_table_col_end to end the loop

        // Generate Random Number
        
        bl      rand                            // rand();
        and  	x9,     x0,     0xF              // int x9 = rand() & 0xF;
        mov     x11,     x9                      // x11 = x9;
                        // int rand = Random(15);       Generate a Random number from 0 to 15
        
        add     x11, x11, 1
                        // rand += 1;                   Let the range be 1 to 16

        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x12,     x9                      // Result
              // int 4 = x_crow * x_col; 
        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x12                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_ccol                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x12,     x9                      // Result
                // 4 = 4 + x_ccol;      Calculate current 4 in the 2d Array of the Table

        // Write to 2d Array of Table
        
        mov     x9,     int
        mov     x10,    x12
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     x_2da                  // Calculate Offset += Base

        mov     x10,    x11
        str     x10,    [x29,   x9]
        // x_2da[4] = rand; Write the Random number to the Array

        // Add occurence to Structure total occurence
        
        add     x9,     x_off,     sd_tocc              // Add the size
        ldr	    x12,     [x29,   x9]             // Load the value
         // int totalOccurence = x_1da[x_off].tocc;              Read the total occurence from the current Structure from the 1d Array of Structure
        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x11                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x12                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x10,     x9                      // Result
                   // int newTotalOccurnece = totalOccurence + rand;       Calculate the new total occurence
        
        add     x9,     x_off,     sd_tocc              // Add the size
        mov     x10,    x10
        str     x10,    [x29,   x9]             // And Adds x10 to x9
        // x_1da[x_off].tocc = newTotalOccurnece;               Write back the new total occurence to the Structure

        // Check highest occurence & 4
        cmp     x_hiocc,x11                     // if (x_hiocc < rand)          If the current rand value is greater than the highest occurence
        b.lt    struct_write                    // {struct_write}               then go to struct_write to overwrite the value
        b       struct_else                     // else{}                       otherwise do nothing
struct_write:
        mov     x_hiocc,x11                     // x_hiocc = rand;              Set the highest value to rand as the new highest one
        mov     x_hiind,x_ccol                  // x_hiind = x_ccol;            Set the highest 4 to the current 4
struct_else:

        // Print
        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        mov     x2,    x_ccol
        
    
        mov     x3,    x9
        
    
        mov     x4,    x11
        
    
        ldr     x0,     =aloc
        bl      printf


        
        add     x_ccol, x_ccol, 1
                          // x_ccol ++;                   Index increment
        b       generate_table_col              // Go back to the loop top
        generate_table_col_end:                 // End of while loop

        // Write highest occurence & 5
        
        add     x9,     x_off,     sd_occ              // Add the size
        mov     x10,    x_hiocc
        str     x10,    [x29,   x9]             // And Adds x10 to x9
     // x_1da[x_off].occurence = x_hiocc             Write the hiOccurent to the Structure
        
        add     x9,     x_off,     sd_ind              // Add the size
        mov     x10,    x_hiind
        str     x10,    [x29,   x9]             // And Adds x10 to x9
     // x_1da[x_off].5 = x_hiind                 Write the hiIndex to the Structure
        
        // Calculate Highest Frequency
        
        add     x9,     x_off,     sd_tocc              // Add the size
        ldr	    x11,     [x29,   x9]             // Load the value
         // int totalOccurence = x_1da[x_off].tocc;      Read the total occurence from the Structure
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_hiocc                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    100                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_hiocc,     x9                      // Result
           // x_hiocc = x_hiocc * 100;                         
        sdiv    x_hiocc,    x_hiocc,    x11     // x_hiocc = x_hiocc / totalOccurence;          Divide to get the frequency
        
    
    
        
        
    
        mov     x1,    x11
        
    
        ldr     x0,     =highocc
        bl      printf
                     
        
    
    
        
        
    
        mov     x1,    x_hiocc
        
    
        ldr     x0,     =highocc
        bl      printf

        
        add     x9,     x_off,     sd_frq              // Add the size
        mov     x10,    x_hiocc
        str     x10,    [x29,   x9]             // And Adds x10 to x9
     // x_1da[x_off].frequency = x_hiocc;            Write the highest frequency to the Structure

        
        add     x_crow, x_crow, 1
                          // x_crow ++;                                   Index increment
        b       generate_table_row              // Go back to the top
generate_table_row_end:                         // End of while loop



print_table:
        mov     x_crow, xzr                     // x_crow = 0; Set current row 2 to 0
        mov     x_off,  xzr                     // x_off = 0; Set current offset to 0

        
    
    
        
        
    
        ldr     x0,     =tblhead
        bl      printf
                          // Print table head

print_table_row:                                // Start of the while loop
        cmp     x_crow, x_row                   // if (x_crow == x_row)         If current row 1 reached the row amount
        b.eq    print_table_row_end             // {print_table_row_end}        then go to print_table_row_end to end the loop
        mov     x_ccol, xzr                     // x_ccol = 0;                  Intialize 0 to the current column 1

        // Calculate Offset
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    sd                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x_off,     x9                      // Result
               // x_off = x_crow * sd;
        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x_off                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_1da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_2da                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x_off,     x9                      // Result
      // x_off = x_off + x_1da + x_2da;

        // Print Document Index
        
    
    
        
        
    
        mov     x1,    x_crow
        
    
        ldr     x0,     =docstr
        bl      printf
                   //                              Print the document 2


        print_table_col:                        // Start of the while loop
        cmp     x_ccol, x_col                   // if (x_ccol == x_col)         If current column 2 reached the column amount
        b.eq    print_table_col_end             // {print_table_col_end}        then go to print_table_col_end to end the loop


        // Calculate Index
        
    
        mov     x9,     1                       // Initialize x9 to 1
    
        
        
    
        
        mov     x10,    x_crow                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        
        mov     x10,    x_col                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        
        
    
        mov     x12,     x9                      // Result
              // int 4 = x_crow + x_col;
        
    
        mov     x9,     0                       // Initialize x9 to 0
    
        
        
    
        
        mov     x10,    x12                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        
        mov     x10,    x_ccol                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        
        
    
        mov     x12,     x9                      // Result
                // 4 = 4 + x_ccol;      Calculate current 4 in the 2d Array of the Table

        // Read from Array
        
        mov     x9,     int
        mov     x10,    x12
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     x_2da                  // Calculate Offset += Base

        ldr     x11,     [x29,   x9]
         // int occ = x_2da[4];      Read the occurence of current word from 2d Array of the Table

        // Print Current Word Occurence
        
    
    
        
        
    
        mov     x1,    x11
        
    
        ldr     x0,     =occstr
        bl      printf
                      //                              Print the word occurence


        
        add     x_ccol, x_ccol, 1
                          // x_ccol ++;                   Index increment

        b       print_table_col                 // Go back to the loop
        print_table_col_end:                    // End of the while loop

        // Print out the highest frequency word
        
        add     x9,     x_off,     sd_ind              // Add the size
        ldr	    x11,     [x29,   x9]             // Load the value
          // int hiIndex = x_1da[x_off].sd_ind;
        
        add     x9,     x_off,     sd_frq              // Add the size
        ldr	    x12,     [x29,   x9]             // Load the value
          // int hiFrequency = x_1da[x_off].sd_frq;
        
        add     x9,     x_off,     sd_occ              // Add the size
        ldr	    x13,     [x29,   x9]             // Load the value
          // int hiOccurence = x_1da[x_off].sd_occ;
        
        add     x9,     x_off,     sd_tocc              // Add the size
        ldr	    x14,     [x29,   x9]             // Load the value
         // int totalOccurence = x_1da[x_off].sd_tocc;
        
    
    
        
        
    
        mov     x1,    x11
        
    
        mov     x2,    x12
        
    
        mov     x3,    x13
        
    
        mov     x4,    x14
        
    
        ldr     x0,     =frqstr
        bl      printf
       // Print(frqstr, hiIndex, hiFrequency, hiOccurence, totalOccurence);
        
        
    
    
        
        
    
        ldr     x0,     =linebr
        bl      printf
                           // Print line break


        
        add     x_crow, x_crow, 1
                          // x_crow ++;                   Index increment
        b       print_table_row                 // Go back to the loop
print_table_row_end:                            // End of the while loop


end:    // Program end

        // Deallocate 2d Array of table
        
        sub     x_1da,     xzr,    x_1da              // Negate the size again to positive
        add     sp,     sp,     x_1da              // Deallocate on SP
                          // Deallocate 1d Array
        
        sub     x_2da,     xzr,    x_2da              // Negate the size again to positive
        add     sp,     sp,     x_2da              // Deallocate on SP
                          // Deallocate 2d Array
        
        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS
