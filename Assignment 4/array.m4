divert(`-1')
// array(destination, base, size, index)
define(readArray, `
        mov     x9,     xzr
        mul     x9,     $3,     $4                  // calculate offset = size * index
        add     x9,     x9,     $2                  // calculate offset += base

        sub     x9,     xzr,    x9                  // Negate offset

        ldr     $1,     [x29,   x9]
')
// writeArray(value, base, size, index)
define(writeArray, `
        mov     x9,     $3
        mov     x10,    $4
        mul     x9,     x9,     x10                 // calculate offset = size * index
        add     x9,     x9,     $2                  // calculate offset += base

        sub     x9,     xzr,    x9                  // Negate offset

        str     $1,     [x29,   x9]
')
divert