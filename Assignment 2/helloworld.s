
.balign 4
.global main
    
main:   
    stp x29, x30, [sp, -16]!
    mov x29, sp

    ldp x29, x30, [sp], 16
    ret

    