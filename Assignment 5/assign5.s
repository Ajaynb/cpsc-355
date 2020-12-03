

str_occ:                .string " %d "
str_end:                .string "Ended."
str_doc:                .string "Document %02d: "
access_r:               .string "r"
str_table_header:       .string "===== Table====="
str_top_doc:            .string "The top documents are: "
str_hi_occ:             .string "Occurence of %d and "
str_hi_frq:             .string "Frequency of %.1f%% "
str_search_for_index:   .string "What is the index of the word you are searching for? "
str_input:              .string " %d"
str_ask_top_doc:        .string "How many top documents you want to retrieve? "
str_table_header0:      .string "Do you want to search again? (y/n) "
str_table_header1:      .string " %c"

        // Expose main function to OS and set balign
        .global main
        .balign 4

        // Renaming fp and lr to FP and LR
        fp      .req    fp
        lr      .req    lr


randomNum:
        // Compare m and n, if equal then return
        cmp     w0, w1
        b.eq    randret

        stp     fp, lr, [sp, -32]!
        mov     fp, sp

        // For protection, check again the lower and upper bound
        stp     x19, x20, [sp, 16]
        csel    w19, w0, w1, le         // int lower = min(m,n);
        csel    w20, w0, w1, ge         // int upper = max(m,n);
                
        // Generate random number
        bl      rand

        // Limit random number in range
        sub     w1, w20, w19            // int range = upper - lower;
        add     w1, w1, 1               // range += 1;
        sdiv    w2, w0, w1              // int random = rand() % range
        msub    w0, w2, w1, w0
        add     w0, w0, w19             // random += lower
        ldp     x19, x20, [sp, 16]


        ldp     fp, lr, [sp], 32
randret:ret



initialize:
        stp     fp, lr, [sp, -336]!
        mov     fp, sp

        // Save registers
        stp     x19, x20, [sp, 16]
        mov     x19, x1
        stp     x21, x22, [sp, 32]
        stp     x23, x24, [sp, 48]
        mov     x24, x0
        
        // Open the file if from file
        cmp     x1, xzr                         // if (fromFile == true)
        b.eq    frfile                          // {open file}
        b       notfromfile                     // {do nothing}
        
        frfile: // Open file with r access
                adrp    x1, access_r
                mov     x0, x19
                add     x1, x1, :lo12:access_r
                bl      fopen                   
                mov     x22, x0                 // fp = fopen(file, "r");

        notfromfile:


        // Check if file is open successfully
        cbz     x22, .L35

        // 
        cmp     x19, 0
        mov     x2, 1600
        cset    w21, ne
        mov     w1, 0
        mov     x0, x24
        bl      memset
        ldr     w0, [x24, 1600]
        cmp     w0, 0
        b.le    .L14
.L12:
        mov     w19, 26215
        str     x25, [sp, 64]
        mov     x25, x24
        mov     w20, 0
        movk    w19, 0x6666, lsl 16
.L20:
        cbnz    w21, .L36
        ldr     w1, [x24, 1604]
        cmp     w1, 0
        bgt     .L37
.L18:
        add     w20, w20, 1
        add     x25, x25, 80
        cmp     w0, w20
        bgt     .L20
        ldr     x25, [sp, 64]
.L14:
        cbnz    w21, .L21
.L9:
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldp     fp, lr, [sp], 336
        ret
.L36:
        mov     x2, x22
        mov     w1, 255
        add     x0, sp, 80
        bl      fgets
        cbz     x0, .L38
        ldr     w0, [x24, 1604]
        cmp     w0, 0
        b.le    .L34
        add     x2, sp, 80
        mov     x1, 0
        b       .L19
.L32:
        str     w0, [x25, x1, lsl 2]
        add     x1, x1, 1
        ldr     w0, [x24, 1604]
        cmp     w0, w1
        b.le    .L34
.L19:
        ldrb    w0, [x2]
        add     x2, x2, 2
        sub     w0, w0, #48
        cmp     w0, 9
        bls     .L32
.L34:
        ldr     w0, [x24, 1600]
        b       .L18
.L37:
        mov     x23, 0
.L17:
        bl      rand
        smull   x1, w0, w19
        asr     x1, x1, 34
        sub     w1, w1, w0, asr 31
        add     w1, w1, w1, lsl 2
        sub     w1, w0, w1, lsl 1
        str     w1, [x25, x23, lsl 2]
        add     x23, x23, 1
        ldr     w0, [x24, 1604]
        cmp     w0, w23
        bgt     .L17
        ldr     w0, [x24, 1600]
        b       .L18
.L38:
        ldr     x25, [sp, 64]
.L21:
        mov     x0, x22
        bl      fclose
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldp     fp, lr, [sp], 336
        ret
.L35:
        mov     x2, 1600
        mov     w1, 0
        mov     x0, x24
        bl      memset
        ldr     w0, [x24, 1600]
        mov     w21, 0
        cmp     w0, 0
        bgt     .L12
        b       .L9
display:
        stp     fp, lr, [sp, -64]!
        mov     fp, sp
        stp     x19, x20, [sp, 16]
        mov     x20, x0
        adrp    x0, str_table_header
        add     x0, x0, :lo12:str_table_header
        bl      puts
        ldr     w0, [x20, 1600]
        cmp     w0, 0
        b.le    .L39
        stp     x21, x22, [sp, 32]
        adrp    x22, str_occ
        mov     x21, x20
        add     x22, x22, :lo12:str_occ
        str     x23, [sp, 48]
        mov     w23, 0
.L41:
        ldr     w0, [x20, 1604]
        mov     x19, 0
        cmp     w0, 0
        b.le    .L43
.L42:
        ldr     w1, [x21, x19, lsl 2]
        mov     x0, x22
        add     x19, x19, 1
        bl      printf
        ldr     w0, [x20, 1604]
        cmp     w0, w19
        bgt     .L42
.L43:
        mov     w0, 10
        bl      putchar
        ldr     w0, [x20, 1600]
        add     w23, w23, 1
        add     x21, x21, 80
        cmp     w0, w23
        bgt     .L41
        ldp     x21, x22, [sp, 32]
        ldr     x23, [sp, 48]
.L39:
        ldp     x19, x20, [sp, 16]
        ldp     fp, lr, [sp], 64
        ret
topRelevantDocs:
        sub     sp, sp, #592
        stp     fp, lr, [sp]
        mov     fp, sp
        ldr     w7, [x0, 1604]
        ldr     w8, [x0, 1600]
        sub     w15, w7, #1
        stp     x19, x20, [sp, 16]
        cmp     w15, w1
        csel    w1, w15, w1, le
        cmp     w1, 0
        csel    w13, w1, wzr, ge
        cmp     w8, w2
        csel    w20, w8, w2, le
        cmp     w20, 0
        csel    w19, w20, wzr, ge
        cmp     w8, 0
        b.le    .L51
        add     x4, x0, 16
        add     x3, sp, 112
        lsr     w12, w7, 2
        and     w14, w7, -4
        sxtw    x16, w13
        mov     w6, 0
.L56:
        sub     x1, x4, #16
        movi    d0, #0
        cmp     w7, 0
        ldr     w11, [x1, x16, lsl 2]
        b.le    .L55
        cmp     w15, 3
        bls     .L67
        cmp     w12, 1
        ldr     q0, [x4, -16]
        bls     .L53
        ldr     q1, [x4]
        cmp     w12, 2
        add     v0.4s, v0.4s, v1.4s
        b.eq     .L53
        ldr     q1, [x4, 16]
        cmp     w12, 3
        add     v0.4s, v0.4s, v1.4s
        b.eq     .L53
        ldr     q1, [x4, 32]
        cmp     w12, 4
        add     v0.4s, v0.4s, v1.4s
        b.eq     .L53
        ldr     q1, [x4, 48]
        add     v0.4s, v0.4s, v1.4s
.L53:
        addv    s0, v0.4s
        mov     w5, w14
        cmp     w14, w7
        umov    w1, v0.s[0]
        b.eq     .L54
.L52:
        sxtw    x2, w6
        add     w9, w5, 1
        cmp     w7, w9
        add     x2, x2, x2, lsl 2
        lsl     x2, x2, 2
        add     x10, x2, x5, sxtw
        ldr     w10, [x0, x10, lsl 2]
        add     w1, w1, w10
        b.le    .L54
        add     x9, x2, x9, sxtw
        add     w10, w5, 2
        cmp     w7, w10
        ldr     w9, [x0, x9, lsl 2]
        add     w1, w1, w9
        b.le    .L54
        add     x10, x2, x10, sxtw
        add     w5, w5, 3
        cmp     w7, w5
        ldr     w9, [x0, x10, lsl 2]
        add     w1, w1, w9
        b.le    .L54
        add     x5, x2, x5, sxtw
        ldr     w2, [x0, x5, lsl 2]
        add     w1, w1, w2
.L54:
        cmp     w1, 0
        movi    d0, #0
        b.le    .L55
        scvtf   d1, w11
        scvtf   d0, w1
        fdiv    d0, d1, d0
.L55:
        stp     w13, w11, [x3, 8]
        add     x4, x4, 80
        str     w6, [x3, 16]
        add     w6, w6, 1
        str     d0, [x3]
        cmp     w8, w6
        add     x3, x3, 24
        bne     .L56
        sub     w3, w8, #2
        add     x0, sp, 136
        mov     w1, 24
        mov     w9, 0
        umaddl  x3, w3, w1, x0
.L57:
        cmp     w8, 1
        add     x0, sp, 112
        add     x1, sp, 136
        b.eq     .L63
.L61:
        ldr     d1, [x0]
        ldr     d0, [x1]
        fcmpe   d1, d0
        bpl     .L59
        ldp     x6, x7, [x1]
        ldp     x4, x5, [x0]
        stp     x6, x7, [x0]
        ldr     x6, [x1, 16]
        stp     x4, x5, [sp, 88]
        ldr     x2, [x0, 16]
        str     x6, [x0, 16]
        stp     x4, x5, [x1]
        str     x2, [x1, 16]
        str     x2, [sp, 104]
.L59:
        add     x0, x0, 24
        add     x1, x1, 24
        cmp     x0, x3
        bne     .L61
.L63:
        add     w9, w9, 1
        cmp     w8, w9
        bne     .L57
.L51:
        adrp    x0, str_top_doc
        add     x0, x0, :lo12:str_top_doc
        bl      puts
        cmp     w20, 0
        b.le    .L49
        add     x20, sp, 112
        stp     x21, x22, [sp, 32]
        adrp    x22, str_hi_frq
        add     x22, x22, :lo12:str_hi_frq
        stp     x23, x24, [sp, 48]
        adrp    x24, str_doc
        adrp    x23, str_hi_occ
        add     x24, x24, :lo12:str_doc
        add     x23, x23, :lo12:str_hi_occ
        mov     x0, 4636737291354636288
        mov     w21, 0
        str     d8, [sp, 64]
        fmov    d8, x0
.L65:
        ldr     w1, [x20, 16]
        mov     x0, x24
        add     w21, w21, 1
        bl      printf
        ldr     w1, [x20, 12]
        mov     x0, x23
        bl      printf
        ldr     d0, [x20], 24
        mov     x0, x22
        fmul    d0, d0, d8
        bl      printf
        mov     w0, 10
        bl      putchar
        cmp     w19, w21
        bgt     .L65
        ldp     x21, x22, [sp, 32]
        ldp     x23, x24, [sp, 48]
        ldr     d8, [sp, 64]
.L49:
        ldp     fp, lr, [sp]
        ldp     x19, x20, [sp, 16]
        add     sp, sp, 592
        ret
.L67:
        mov     w5, 0
        mov     w1, 0
        b       .L52
main:
        sub     sp, sp, #1696
        stp     fp, lr, [sp]
        mov     fp, sp
        stp     x19, x20, [sp, 16]
        mov     x20, x1
        stp     x21, x22, [sp, 32]
        mov     w21, w0
        add     x0, sp, 80
        str     x23, [sp, 48]
        bl      time
        bl      srand
        cmp     w21, 2
        bgt     .L94
        movi    v0.2s, 0x5
        mov     x1, 0
        str     d0, [sp, 1688]
.L86:
        adrp    x23, str_search_for_index
        adrp    x19, str_input
        adrp    x22, str_ask_top_doc
        adrp    x21, str_table_header0
        adrp    x20, str_table_header1
        add     x23, x23, :lo12:str_search_for_index
        add     x19, x19, :lo12:str_input
        add     x22, x22, :lo12:str_ask_top_doc
        add     x21, x21, :lo12:str_table_header0
        add     x20, x20, :lo12:str_table_header1
        add     x0, sp, 88
        bl      initialize
        add     x0, sp, 88
        bl      display
        mov     w0, 10
        bl      putchar
.L87:
        mov     x0, x23
        bl      printf
        add     x1, sp, 72
        mov     x0, x19
        bl      __isoc99_scanf
        mov     x0, x22
        bl      printf
        add     x1, sp, 76
        mov     x0, x19
        bl      __isoc99_scanf
        mov     w0, 10
        bl      putchar
        ldp     w1, w2, [sp, 72]
        add     x0, sp, 88
        bl      topRelevantDocs
        mov     w0, 10
        bl      putchar
        mov     x0, x21
        bl      printf
        add     x1, sp, 71
        mov     x0, x20
        bl      __isoc99_scanf
        mov     w0, 10
        bl      putchar
        ldrb    w0, [sp, 71]
        cmp     w0, 121
        b.eq     .L87
        adrp    x0, str_end
        add     x0, x0, :lo12:str_end
        bl      puts
        mov     w0, 0
        ldp     fp, lr, [sp]
        ldp     x19, x20, [sp, 16]
        ldp     x21, x22, [sp, 32]
        ldr     x23, [sp, 48]
        add     sp, sp, 1696
        ret
.L94:
        ldr     x0, [x20, 8]
        mov     w2, 10
        mov     x1, 0
        bl      strtol
        mov     x19, x0
        ldr     x0, [x20, 16]
        mov     w2, 10
        mov     x1, 0
        bl      strtol
        cmp     w19, 5
        mov     w2, 5
        csel    w19, w19, w2, ge
        mov     w1, 20
        cmp     w19, w1
        csel    w19, w19, w1, le
        cmp     w0, w2
        csel    w0, w0, w2, ge
        str     w19, [sp, 1688]
        cmp     w0, w1
        csel    w0, w0, w1, le
        str     w0, [sp, 1692]
        cmp     w21, 3
        b.eq     .L88
        ldr     x1, [x20, 24]
        b       .L86
.L88:
        mov     x1, 0
        b       .L86



