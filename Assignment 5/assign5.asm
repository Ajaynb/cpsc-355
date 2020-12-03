        include(`macros.m4')

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



        xprint(allstr, alloc, sp, fp)

        sub     x0,     fp,     st_row
        sub     x1,     fp,     st_col
        bl      initialize


        // Deallocate memory
        xdealloc(st_size)                       // deallocate struct Table

        xret()





initialize: // initialize(struct Table* table)
	xfunc()

        
        ldr     x19,    [x0]
        ldr     x20,    [x1]

        xprint(output, x19, x20)



        xprint(allstr, alloc, sp, fp)


        xret()

