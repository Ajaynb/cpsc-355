divert(`-1')
// print(string, param1, param2, ...) -> Just like how to use printf :)
define(print, `
    define(`index', eval(`0'))
    foreach(`t', `$@', `
        ifelse(index, `0', `', `format(`mov     x%s,    %s', eval(index), `t')')
        define(`index', incr(index))
    ')
        ldr     x0,     =$1
        bl      printf
')
divert