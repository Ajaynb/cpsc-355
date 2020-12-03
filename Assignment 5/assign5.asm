        // Defining strings
output: .string "%d, %d\n"
allstr: .string "alloc %d, sp %d, fp %d\n"


        // Expose main function to OS and set balign
        .global main
        .balign 4
        
        // Equates for alloc & dealloc
        alloc = -16
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
        st_arr_amount = max_row * max_col
        st_arr_size = st_arr_amount * int
        st_size = -(st_arr + st_arr_size + 16) & -16



main: 
        stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
        mov fp, sp									//Update FP to current SP

        // allocate the required space for struct
		add 	sp,			sp, 	st_size

        bl initialize

        
        //deallocate struct
		sub 	x9, 	xzr, 	st_size
		add		sp, 		sp, 	x9

        mov x0, 0
        ldp fp, lr, [sp], dealloc				    //Deallocate stack memory
        ret



initialize:
        stp fp, lr, [sp, alloc]!						//Store FP and LR on stack, and allocate space for local variables
        mov fp, sp									//Update FP to current SP
        
        

        ldp fp, lr, [sp], dealloc						//Deallocate stack memory
        ret			

