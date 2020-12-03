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

        mov     x19,    5
        mov     x20,    5


        // Construct struct Table
        xalloc(st_size)                         // allocate for struct Table
        xstruct(st, st_row, st_col)             // init struct Table attributes with 0
        xwriteStruct(x19, st, st_row)
        xwriteStruct(x20, st, st_col)


        mov     x19,    123
        mov     x20,    123

        xprint(allstr, alloc, sp, fp)

        sub     x0,     fp,     st_row
        sub     x1,     fp,     st_col
        bl      initialize

        
exit:
        // Deallocate memory
        xdealloc(st_size)                       // deallocate struct Table

        xret()





initialize: // initialize(struct Table* table)
	xfunc()

        
        ldr     x19,    [x0]
        ldr     x20,    [x1]

        mov     x1,     x19
        mov     x2,     x20
        ldr     x0,     =output
        bl      printf



        xprint(allstr, alloc, sp, fp)




intiializein:

        xret()

