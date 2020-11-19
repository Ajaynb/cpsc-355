include(`foreach2.m4')
divert(`-1')
// Multiplications: multiply(destination, param2, param3, ...)
define(multiply, `
        mov     $1,     1
    foreach(`t', `$@', `
        mov     x15,    t
        mul     $1,     $1,     x15
    ')
')
divert