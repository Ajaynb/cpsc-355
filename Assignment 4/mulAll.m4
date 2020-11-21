include(`foreach2.m4')
divert(`-1')
// multiply(destination, param2, param3, ...)
define(mulAll, `
    define(`index', eval(`1'))
        mov     x9,     1                       // Initialize x9 to 1
    foreach(`t', `$@', `
        ifelse(index, `1', `', `format(`
        mov     x10,    t                       // Move next multiplier to x10
        mul     x9,     x9,     x10             // And multiplies x10 to x9
        ')')
        define(`index', incr(index))
    ')
        mov     $1,     x9                      // Result
')
divert