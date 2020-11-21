divert(`-1')
// array(destination, element_amount, element_size)
define(array, `
    format(`
        mov     x9,     0                           // Loop Counter
loop_%s:
        cmp     x9,     $2
        b.eq    loop_end_%s

        mov     x10,    $3
        mul     x10,    x10,    x9                  // Calculate Offset

        str 	xzr,    [fp,    x10]                // Initialize with 0

        add     x9,     x9,     1                   // Increment
        b       loop_%s

loop_end_%s:

    ', eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter))
    g_count()
')
// readArray(destination, base, size, index)
define(readArray, `
        mov     x9,     $3
        mov     x10,    $4
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     $2                  // Calculate Offset += Base

        ldr     $1,     [x29,   x9]
')
// writeArray(value, base, size, index)
define(writeArray, `
        mov     x9,     $3
        mov     x10,    $4
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     $2                  // Calculate Offset += Base

        mov     x10,    $1
        str     x10,    [x29,   x9]
')
divert