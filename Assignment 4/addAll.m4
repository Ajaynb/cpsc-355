include(`foreach2.m4')
divert(`-1')
// addAll(destination, param2, param3, ...) -> destination = param2 + param3 + ...
define(addAll, `
    define(`index', eval(`1'))
        mov     x9,     0                       // Initialize x9 to 0
    foreach(`t', `$@', `
        ifelse(index, `1', `', `format(`
        mov     x10,    t                       // Move next number to x10
        add     x9,     x9,     x10             // And Adds x10 to x9
        ')')
        define(`index', incr(index))
    ')
        mov     $1,     x9                      // Result
')
// addAdd(variable) -> variable ++;
define(addAdd, `
        add     $1, $1, 1
')
// addEqual(variable, param2) -> variable += param2;
define(addEqual, `
        add     $1, $1, $2
')
divert