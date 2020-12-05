  include(`macros.m4')

        // Equates for alloc & dealloc
        alloc =  -(16 + 96) & -16
        dealloc = -alloc

        // Define register aliases
        fp      .req    x29
        lr      .req    x30


        // Expose main function to OS and set balign
        .global main
        .balign 4

main:   // main()
        xfunc()


        xret()
