        include(`macros.m4')

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
        xfunc()

        // Initialize values
        mov     x19,    5                       // int row = 5;
        mov     x20,    5                       // int col = 5;

        // Rand seed
        xrandSeed()

        // Limit the range of row and col as input validation
        xmin(x19, x19, max_row)                 // row = min(row, max_row);
        xmax(x19, x19, min_row)                 // row = max(row, min_row);
        xmin(x20, x20, max_col)                 // col = min(col, max_col);
        xmax(x20, x20, min_col)                 // col = max(col, min_col);

        // Construct struct Table
        xalloc(st_size)                         // allocate for struct Table
        xstruct(st, st_row, st_col)             // init struct Table attributes with 0
        xwriteStruct(x19, st, st_row)           // write the reset row to struct
        xwriteStruct(x20, st, st_col)           // write the reset col to struct

        xreadStruct(x21, st, st_row)
        xreadStruct(x22, st, st_col)
        

        xarray(st_arr_base, st_arr_amount, int)
        xwriteArray(18, st_arr_base, int, 0)
        xwriteArray(19, st_arr_base, int, 1)
        

        mov     x11,    st                      // int base
        mov     x12,    st_row                  // int attribute offset
        add     x9,     x11,    x12             // int offset = base + attribute
        add     x9,     x9,     fp              // offset += fp

        mov     x0,     x9
        bl      initialize

        
        xreadStruct(x24, st, st_row)
        xreadStruct(x25, st, st_col)
        xprint(output, x24, x25)


        xreadArray(x27, st_arr_base, int, 0)
        xreadArray(x28, st_arr_base, int, 1)
        xprint(output, x27, x28)



        // Deallocate memory
        xdealloc(st_size)                       // deallocate struct Table

        xret()

        xprint(allstr, alloc, sp, fp)






initialize: // initialize(struct Table* table)
	xfunc()

        mov     x19,    x0
        
        xreadStruct(x20, x19, st_row, true)
        xreadStruct(x21, x19, st_col, true)


        xprint(output, x20, x21)

        mov     x21,    20
        xwriteStruct(x21, x19, st_col, true)
        
        xreadStruct(x24, x19, st_col, true)
        xprint(output, x21, x24)



        add     x19,    x19,    st_arr

        xreadArray(x25, x19, int, 0, true)
        xreadArray(x26, x19, int, 1, true)
        xprint(output, x25, x26)

        add     x25,    x25,    10
        add     x26,    x26,    10

        xwriteArray(x25, x19, int, 0, true)
        xwriteArray(x26, x19, int, 1, true)
        





        xret()

