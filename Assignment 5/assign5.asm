
.balign 4
.global main


fp_log:
        .zero   8
randomNum:
        stp     x29, x30, [sp, -48]!
        mov     x29, sp
        str     w0, [sp, 28]
        str     w1, [sp, 24]
        ldr     w1, [sp, 28]
        ldr     w0, [sp, 24]
        cmp     w1, w0
        bne     .L2
        ldr     w0, [sp, 28]
        b       .L3
.L2:
        ldr     w1, [sp, 28]
        ldr     w0, [sp, 24]
        cmp     w1, w0
        ble     .L4
        ldr     w0, [sp, 28]
        b       .L5
.L4:
        ldr     w0, [sp, 24]
.L5:
        str     w0, [sp, 44]
        ldr     w1, [sp, 28]
        ldr     w0, [sp, 24]
        cmp     w1, w0
        bge     .L6
        ldr     w0, [sp, 28]
        b       .L7
.L6:
        ldr     w0, [sp, 24]
.L7:
        str     w0, [sp, 40]
        bl      rand
        mov     w1, w0
        ldr     w2, [sp, 44]
        ldr     w0, [sp, 40]
        sub     w0, w2, w0
        add     w0, w0, 1
        sdiv    w2, w1, w0
        mul     w0, w2, w0
        sub     w1, w1, w0
        ldr     w0, [sp, 40]
        add     w0, w1, w0
.L3:
        ldp     x29, x30, [sp], 48
        ret
.LC0:
        .string "w"
.LC1:
        .string "assign1.log"
logToFile:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp
        adrp    x0, .LC0
        add     x1, x0, :lo12:.LC0
        adrp    x0, .LC1
        add     x0, x0, :lo12:.LC1
        bl      fopen
        mov     x1, x0
        adrp    x0, fp_log
        add     x0, x0, :lo12:fp_log
        str     x1, [x0]
        nop
        ldp     x29, x30, [sp], 16
        ret
logOffFile:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp
        adrp    x0, fp_log
        add     x0, x0, :lo12:fp_log
        ldr     x0, [x0]
        bl      fclose
        nop
        ldp     x29, x30, [sp], 16
        ret
.LC2:
        .string "r"
initialize:
        stp     x29, x30, [sp, -336]!
        mov     x29, sp
        str     x0, [sp, 24]
        str     x1, [sp, 16]
        ldr     x0, [sp, 16]
        cmp     x0, 0
        cset    w0, ne
        strb    w0, [sp, 335]
        ldrb    w0, [sp, 335]
        cmp     w0, 0
        beq     .L11
        adrp    x0, .LC2
        add     x1, x0, :lo12:.LC2
        ldr     x0, [sp, 16]
        bl      fopen
        str     x0, [sp, 320]
.L11:
        ldr     x0, [sp, 320]
        cmp     x0, 0
        bne     .L12
        strb    wzr, [sp, 335]
.L12:
        str     wzr, [sp, 316]
.L16:
        ldr     w0, [sp, 316]
        cmp     w0, 19
        bgt     .L13
        str     wzr, [sp, 312]
.L15:
        ldr     w0, [sp, 312]
        cmp     w0, 19
        bgt     .L14
        ldr     x2, [sp, 24]
        ldrsw   x3, [sp, 312]
        ldrsw   x1, [sp, 316]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x3
        str     wzr, [x2, x0, lsl 2]
        ldr     w0, [sp, 312]
        add     w0, w0, 1
        str     w0, [sp, 312]
        b       .L15
.L14:
        ldr     w0, [sp, 316]
        add     w0, w0, 1
        str     w0, [sp, 316]
        b       .L16
.L13:
        str     wzr, [sp, 308]
.L25:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        ldr     w1, [sp, 308]
        cmp     w1, w0
        bge     .L17
        ldrb    w0, [sp, 335]
        cmp     w0, 0
        beq     .L18
        add     x0, sp, 40
        ldr     x2, [sp, 320]
        mov     w1, 255
        bl      fgets
        cmp     x0, 0
        bne     .L18
        mov     w0, 1
        b       .L19
.L18:
        mov     w0, 0
.L19:
        cmp     w0, 0
        bne     .L27
        str     wzr, [sp, 304]
.L24:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1604]
        ldr     w1, [sp, 304]
        cmp     w1, w0
        bge     .L21
        ldrb    w0, [sp, 335]
        cmp     w0, 0
        beq     .L22
        ldr     w0, [sp, 304]
        lsl     w0, w0, 1
        sxtw    x0, w0
        add     x1, sp, 40
        ldrb    w0, [x1, x0]
        str     w0, [sp, 300]
        ldr     w0, [sp, 300]
        cmp     w0, 47
        ble     .L21
        ldr     w0, [sp, 300]
        cmp     w0, 57
        bgt     .L21
        ldr     w0, [sp, 300]
        sub     w3, w0, #48
        ldr     x2, [sp, 24]
        ldrsw   x4, [sp, 304]
        ldrsw   x1, [sp, 308]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x4
        str     w3, [x2, x0, lsl 2]
        b       .L23
.L22:
        mov     w1, 9
        mov     w0, 0
        bl      randomNum
        str     w0, [sp, 296]
        ldr     x2, [sp, 24]
        ldrsw   x3, [sp, 304]
        ldrsw   x1, [sp, 308]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x3
        ldr     w1, [sp, 296]
        str     w1, [x2, x0, lsl 2]
.L23:
        ldr     w0, [sp, 304]
        add     w0, w0, 1
        str     w0, [sp, 304]
        b       .L24
.L21:
        ldr     w0, [sp, 308]
        add     w0, w0, 1
        str     w0, [sp, 308]
        b       .L25
.L27:
        nop
.L17:
        ldrb    w0, [sp, 335]
        cmp     w0, 0
        beq     .L28
        ldr     x0, [sp, 320]
        bl      fclose
.L28:
        nop
        ldp     x29, x30, [sp], 336
        ret
.LC3:
        .string "===== Table ====="
.LC4:
        .string " %d "
display:
        stp     x29, x30, [sp, -48]!
        mov     x29, sp
        str     x0, [sp, 24]
        adrp    x0, .LC3
        add     x0, x0, :lo12:.LC3
        bl      puts
        str     wzr, [sp, 44]
.L33:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        ldr     w1, [sp, 44]
        cmp     w1, w0
        bge     .L34
        str     wzr, [sp, 40]
.L32:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1604]
        ldr     w1, [sp, 40]
        cmp     w1, w0
        bge     .L31
        ldr     x2, [sp, 24]
        ldrsw   x3, [sp, 40]
        ldrsw   x1, [sp, 44]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x3
        ldr     w0, [x2, x0, lsl 2]
        mov     w1, w0
        adrp    x0, .LC4
        add     x0, x0, :lo12:.LC4
        bl      printf
        ldr     w0, [sp, 40]
        add     w0, w0, 1
        str     w0, [sp, 40]
        b       .L32
.L31:
        mov     w0, 10
        bl      putchar
        ldr     w0, [sp, 44]
        add     w0, w0, 1
        str     w0, [sp, 44]
        b       .L33
.L34:
        nop
        ldp     x29, x30, [sp], 48
        ret
.LC5:
        .string "The top documents are: "
.LC6:
        .string "Document %02d: "
.LC7:
        .string "Occurence of %d and "
.LC8:
        .string "Frequency of %.1f%% "
topRelevantDocs:
        sub     sp, sp, #592
        stp     x29, x30, [sp]
        mov     x29, sp
        str     x0, [sp, 24]
        str     w1, [sp, 20]
        str     w2, [sp, 16]
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1604]
        sub     w0, w0, #1
        ldr     w2, [sp, 20]
        ldr     w1, [sp, 20]
        cmp     w2, w0
        csel    w0, w1, w0, le
        str     w0, [sp, 20]
        ldr     w1, [sp, 20]
        ldr     w0, [sp, 20]
        mov     w2, 0
        cmp     w1, 0
        csel    w0, w0, w2, ge
        str     w0, [sp, 20]
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        ldr     w1, [sp, 16]
        cmp     w1, w0
        blt     .L36
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        b       .L37
.L36:
        ldr     w0, [sp, 16]
.L37:
        str     w0, [sp, 16]
        ldr     w1, [sp, 16]
        ldr     w0, [sp, 16]
        mov     w2, 0
        cmp     w1, 0
        csel    w0, w0, w2, ge
        str     w0, [sp, 16]
        str     wzr, [sp, 588]
.L43:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        ldr     w1, [sp, 588]
        cmp     w1, w0
        bge     .L38
        str     wzr, [sp, 584]
        str     wzr, [sp, 580]
.L40:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1604]
        ldr     w1, [sp, 580]
        cmp     w1, w0
        bge     .L39
        ldr     x2, [sp, 24]
        ldrsw   x3, [sp, 580]
        ldrsw   x1, [sp, 588]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x3
        ldr     w0, [x2, x0, lsl 2]
        ldr     w1, [sp, 584]
        add     w0, w1, w0
        str     w0, [sp, 584]
        ldr     w0, [sp, 580]
        add     w0, w0, 1
        str     w0, [sp, 580]
        b       .L40
.L39:
        ldr     w0, [sp, 588]
        str     w0, [sp, 80]
        ldr     w0, [sp, 20]
        str     w0, [sp, 72]
        ldr     x2, [sp, 24]
        ldrsw   x3, [sp, 20]
        ldrsw   x1, [sp, 588]
        mov     x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x1
        lsl     x0, x0, 2
        add     x0, x0, x3
        ldr     w0, [x2, x0, lsl 2]
        str     w0, [sp, 76]
        ldr     w0, [sp, 584]
        cmp     w0, 0
        ble     .L41
        ldr     w0, [sp, 76]
        scvtf   d1, w0
        ldr     w0, [sp, 584]
        scvtf   d0, w0
        fdiv    d0, d1, d0
        b       .L42
.L41:
        movi    d0, #0
.L42:
        str     d0, [sp, 64]
        ldrsw   x1, [sp, 588]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        add     x2, x1, x0
        add     x3, sp, 64
        ldp     x0, x1, [x3]
        stp     x0, x1, [x2]
        ldr     x0, [x3, 16]
        str     x0, [x2, 16]
        ldr     w0, [sp, 588]
        add     w0, w0, 1
        str     w0, [sp, 588]
        b       .L43
.L38:
        str     wzr, [sp, 576]
.L49:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        ldr     w1, [sp, 576]
        cmp     w1, w0
        bge     .L44
        str     wzr, [sp, 572]
.L48:
        ldr     x0, [sp, 24]
        ldr     w0, [x0, 1600]
        sub     w0, w0, #1
        ldr     w1, [sp, 572]
        cmp     w1, w0
        bge     .L45
        ldrsw   x1, [sp, 572]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        ldr     d1, [x1, x0]
        ldr     w0, [sp, 572]
        add     w0, w0, 1
        sxtw    x1, w0
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        ldr     d0, [x1, x0]
        fcmpe   d1, d0
        bpl     .L46
        ldrsw   x1, [sp, 572]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        add     x2, sp, 40
        add     x3, x1, x0
        ldp     x0, x1, [x3]
        stp     x0, x1, [x2]
        ldr     x0, [x3, 16]
        str     x0, [x2, 16]
        ldr     w0, [sp, 572]
        add     w2, w0, 1
        ldrsw   x0, [sp, 572]
        mov     x1, x0
        lsl     x1, x1, 1
        add     x1, x1, x0
        lsl     x0, x1, 3
        mov     x1, x0
        add     x4, sp, 88
        sxtw    x2, w2
        mov     x0, x2
        lsl     x0, x0, 1
        add     x0, x0, x2
        lsl     x0, x0, 3
        add     x3, sp, 88
        add     x2, x4, x1
        add     x3, x3, x0
        ldp     x0, x1, [x3]
        stp     x0, x1, [x2]
        ldr     x0, [x3, 16]
        str     x0, [x2, 16]
        ldr     w0, [sp, 572]
        add     w0, w0, 1
        sxtw    x1, w0
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        add     x2, x1, x0
        add     x3, sp, 40
        ldp     x0, x1, [x3]
        stp     x0, x1, [x2]
        ldr     x0, [x3, 16]
        str     x0, [x2, 16]
.L46:
        ldr     w0, [sp, 572]
        add     w0, w0, 1
        str     w0, [sp, 572]
        b       .L48
.L45:
        ldr     w0, [sp, 576]
        add     w0, w0, 1
        str     w0, [sp, 576]
        b       .L49
.L44:
        adrp    x0, .LC5
        add     x0, x0, :lo12:.LC5
        bl      puts
        str     wzr, [sp, 568]
.L51:
        ldr     w1, [sp, 568]
        ldr     w0, [sp, 16]
        cmp     w1, w0
        bge     .L53
        ldrsw   x1, [sp, 568]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 104
        ldr     w0, [x1, x0]
        mov     w1, w0
        adrp    x0, .LC6
        add     x0, x0, :lo12:.LC6
        bl      printf
        ldrsw   x1, [sp, 568]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 100
        ldr     w0, [x1, x0]
        mov     w1, w0
        adrp    x0, .LC7
        add     x0, x0, :lo12:.LC7
        bl      printf
        ldrsw   x1, [sp, 568]
        mov     x0, x1
        lsl     x0, x0, 1
        add     x0, x0, x1
        lsl     x0, x0, 3
        add     x1, sp, 88
        ldr     d0, [x1, x0]
        mov     x0, 4636737291354636288
        fmov    d1, x0
        fmul    d0, d0, d1
        adrp    x0, .LC8
        add     x0, x0, :lo12:.LC8
        bl      printf
        mov     w0, 10
        bl      putchar
        ldr     w0, [sp, 568]
        add     w0, w0, 1
        str     w0, [sp, 568]
        b       .L51
.L53:
        nop
        ldp     x29, x30, [sp]
        add     sp, sp, 592
        ret
.LC9:
        .string "What is the index of the word you are searching for? "
.LC10:
        .string " %d"
.LC11:
        .string "How many top documents you want to retrieve? "
.LC12:
        .string "Do you want to search again? (y/n) "
.LC13:
        .string " %c"
.LC14:
        .string "Ended."
main:
        sub     sp, sp, #1680
        stp     x29, x30, [sp]
        mov     x29, sp
        str     w0, [sp, 28]
        str     x1, [sp, 16]
        add     x0, sp, 1664
        bl      time
        bl      srand
        //bl      logToFile
        ldr     w0, [sp, 28]
        cmp     w0, 2
        ble     .L55
        ldr     x0, [sp, 16]
        add     x0, x0, 8
        ldr     x0, [x0]
        bl      atoi
        str     w0, [sp, 1676]
        ldr     x0, [sp, 16]
        add     x0, x0, 16
        ldr     x0, [x0]
        bl      atoi
        str     w0, [sp, 1672]
        ldr     w0, [sp, 1676]
        cmp     w0, 4
        ble     .L56
        ldr     w0, [sp, 1676]
        cmp     w0, 19
        bgt     .L57
        mov     w0, 1
        b       .L59
.L57:
        mov     w0, 0
        b       .L59
.L56:
        mov     w0, 1
.L59:
        cmp     w0, 0
        beq     .L60
        ldr     w2, [sp, 1676]
        ldr     w1, [sp, 1676]
        mov     w0, 5
        cmp     w2, 5
        csel    w0, w1, w0, ge
        b       .L61
.L60:
        mov     w0, 20
.L61:
        str     w0, [sp, 1676]
        ldr     w0, [sp, 1672]
        cmp     w0, 4
        ble     .L62
        ldr     w0, [sp, 1672]
        cmp     w0, 19
        bgt     .L63
        mov     w0, 1
        b       .L65
.L63:
        mov     w0, 0
        b       .L65
.L62:
        mov     w0, 1
.L65:
        cmp     w0, 0
        beq     .L66
        ldr     w2, [sp, 1672]
        ldr     w1, [sp, 1672]
        mov     w0, 5
        cmp     w2, 5
        csel    w0, w1, w0, ge
        b       .L67
.L66:
        mov     w0, 20
.L67:
        str     w0, [sp, 1672]
        b       .L68
.L55:
        mov     w0, 5
        str     w0, [sp, 1672]
        ldr     w0, [sp, 1672]
        str     w0, [sp, 1676]
.L68:
        ldr     w0, [sp, 1676]
        str     w0, [sp, 1656]
        ldr     w0, [sp, 1672]
        str     w0, [sp, 1660]
        ldr     w0, [sp, 28]
        cmp     w0, 3
        ble     .L69
        ldr     x0, [sp, 16]
        ldr     x0, [x0, 24]
        b       .L70
.L69:
        mov     x0, 0
.L70:
        add     x2, sp, 56
        mov     x1, x0
        mov     x0, x2
        bl      initialize
        add     x0, sp, 56
        bl      display
        mov     w0, 10
        bl      putchar
.L72:
        adrp    x0, .LC9
        add     x0, x0, :lo12:.LC9
        bl      printf
        add     x0, sp, 48
        mov     x1, x0
        adrp    x0, .LC10
        add     x0, x0, :lo12:.LC10
        bl      scanf
        adrp    x0, .LC11
        add     x0, x0, :lo12:.LC11
        bl      printf
        add     x0, sp, 44
        mov     x1, x0
        adrp    x0, .LC10
        add     x0, x0, :lo12:.LC10
        bl      scanf
        mov     w0, 10
        bl      putchar
        ldr     w1, [sp, 48]
        ldr     w2, [sp, 44]
        add     x0, sp, 56
        bl      topRelevantDocs
        mov     w0, 10
        bl      putchar
        adrp    x0, .LC12
        add     x0, x0, :lo12:.LC12
        bl      printf
        add     x0, sp, 55
        mov     x1, x0
        adrp    x0, .LC13
        add     x0, x0, :lo12:.LC13
        bl      scanf
        mov     w0, 10
        bl      putchar
        ldrb    w0, [sp, 55]
        cmp     w0, 121
        bne     .L71
        b       .L72
.L71:
        adrp    x0, .LC14
        add     x0, x0, :lo12:.LC14
        bl      puts
        bl      logOffFile
        mov     w0, 0
        ldp     x29, x30, [sp]
        add     sp, sp, 1680
        ret