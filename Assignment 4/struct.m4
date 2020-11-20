divert(`-1')
// Defining Open Routine Functions: alloc(destination, param1, param2, ...)
define(struct, `
    define(`index', eval(`1'))
    foreach(`t', `$@', `
        ifelse(index, `1', `', `format(`
        add     x9,     $1,     t               // Add the size
        str     wzr,    [x29,   x9]             // And Adds x10 to x9
        ')')
        define(`index', incr(index))
    ')
')
// Defining Open Routine Functions: dealloc(size)
define(readStruct, `
        add     x9,     $2,     $3              // Add the size
        ldr		$1,     [x29,   x9]             // Load the value
')
// Defining Open Routine Functions: dealloc(size)
define(writeStruct, `
        add     x9,     $2,     $3              // Add the size
        mov     x10,    $1
        str     x10,    [x29,   x9]             // And Adds x10 to x9
')
divert