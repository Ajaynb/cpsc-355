        include(`macros.m4')
        
        // Equates for alloc & dealloc
        alloc = -16
        dealloc = -alloc

         //Define register aliases
        fp      .req    x29
        lr      .req    x30

        // Equates for constants
        max_row = 20
        max_col = 20
        min_row = 5
        min_col = 5



        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // Main function
        // Saves state
        stp     fp,     lr,     [sp, alloc]!    // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                      // update FP to current SP



        // Restores state
        ldp     fp,     lr,     [sp], dealloc   // deallocate stack memory
        ret                                     // return to calling code in OS

