divert(`-1')
// array(destination, base, size, index)
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