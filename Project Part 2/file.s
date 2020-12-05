
        // Expose main function to OS and set balign
        .global main
        .balign 4

        
        // Define register aliases
        fp      .req    x29
        lr      .req    x30

filename: .string "test.txt"
filemode: .string "w"

main:   stp     fp,     lr,     [sp, -16]!            // store FP and LR on stack, and allocate space for local variables
        mov     fp,     sp                              // update FP to current SP
        
        ldr x0, =filename
        ldr x1, =filemode
        bl fopen

        mov x20, x0

        mov x0, x20
        bl fclose
        
        ldp     fp,     lr,     [sp], 16            // deallocate stack memory
        ret

