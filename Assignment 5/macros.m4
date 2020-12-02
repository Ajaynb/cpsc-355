divert(`-1')
define(`xcounter',`0')dnl
define(`xcount',`define(`xcounter',eval(xcounter+1))')dnl
divert

divert(`-1')
# quote(args) - convert args to single-quoted string
define(`quote', `ifelse(`$#', `0', `', ``$*'')')
# dquote(args) - convert args to quoted list of quoted strings
define(`dquote', ``$@'')
# dquote_elt(args) - convert args to list of double-quoted strings
define(`dquote_elt', `ifelse(`$#', `0', `', `$#', `1', ```$1''',
                             ```$1'',$0(shift($@))')')
divert

divert(`-1')
# foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, improved version
define(`foreach', `pushdef(`$1')_$0(`$1',
  (dquote(dquote_elt$2)), `$3')popdef(`$1')')
define(`_arg1', `$1')
define(`_foreach', `ifelse(`$2', `(`')', `',
  `define(`$1', _arg1$2)$3`'$0(`$1', (dquote(shift$2)), `$3')')')
divert

divert(`-1')
# forloop_arg(from, to, macro) - invoke MACRO(value) for
#   each value between FROM and TO, without define overhead
define(`forloop_arg', `ifelse(eval(`($1) <= ($2)'), `1',
  `_forloop(`$1', eval(`$2'), `$3(', `)')')')
# forloop(var, from, to, stmt) - refactored to share code
define(`forloop', `ifelse(eval(`($2) <= ($3)'), `1',
  `pushdef(`$1')_forloop(eval(`$2'), eval(`$3'),
    `define(`$1',', `)$4')popdef(`$1')')')
define(`_forloop',
  `$3`$1'$4`'ifelse(`$1', `$2', `',
    `$0(incr(`$1'), `$2', `$3', `$4')')')
divert

divert(`-1')
// xadd(destination, param2, param3, ...) -> destination = param2 + param3 + ...
define(xadd, `
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
// xaddAdd(variable) -> variable ++;
define(xaddAdd, `
        add     $1, $1, 1
')
// xaddEqual(variable, param2) -> variable += param2;
define(xaddEqual, `
        add     $1, $1, $2
')
divert

divert(`-1')
// xarray(destination, element_amount, element_size)
define(xarray, `
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

    ', eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter))
    xcount()
')
// xreadArray(destination, base, size, index)
define(xreadArray, `
        mov     x9,     $3
        mov     x10,    $4
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     $2                  // Calculate Offset += Base

        ldr     $1,     [x29,   x9]
')
// xwriteArray(value, base, size, index)
define(xwriteArray, `
        mov     x9,     $3
        mov     x10,    $4
        mul     x9,     x9,     x10                 // Calculate Offset = Size * Index
        add     x9,     x9,     $2                  // Calculate Offset += Base

        mov     x10,    $1
        str     x10,    [x29,   x9]
')
divert

divert(`-1')
// xmin(destination, num1, num2)
define(xmin, `
    format(`
        cmp     $2,     $3
        b.lt    if_%s
        b       else_%s
if_%s:  mov    $1,     $2
        b       end_%s
else_%s:mov  $1,     $3
        b       end_%s
end_%s:
    ', eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter))
    xcount()
')

// xmax(destination, num1, num2)
define(xmax, `
    format(`
        cmp     $2,     $3
        b.gt    if_%s
        b       else_%s
if_%s:  mov    $1,     $2
        b       end_%s
else_%s:mov  $1,     $3
        b       end_%s
end_%s:
    ', eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter), eval(xcounter))
    xcount()
')
divert

divert(`-1')
// xmul(destination, param2, param3, ...)
define(xmul, `
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

divert(`-1')
// xprint(string, param1, param2, ...) -> Just like how to use printf :)
define(xprint, `
    define(`index', eval(`0'))
    foreach(`t', `$@', `
        ifelse(index, `0', `', `format(`mov     x%s,    %s', eval(index), `t')')
        define(`index', incr(index))
    ')
        ldr     x0,     =$1
        bl      printf
')
divert

divert(`-1')
// xrandSeed()
define(xrandSeed, `
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));
')

// xrand()
define(xrand, `
        bl      rand                            // rand();
        and  	x9,     x0,     $2              // int x9 = rand() & $2;
        mov     $1,     x9                      // $1 = x9;
')
divert

divert(`-1')
// xstruct(base, attribute1, attribute2, ...)
define(xstruct, `
    define(`index', eval(`1'))
    foreach(`t', `$@', `
        ifelse(index, `1', `', `format(`
        add     x9,     $1,     t               // Add the size
        str     wzr,    [x29,   x9]             // Store value
        ')')
        define(`index', incr(index))
    ')
')
// xreadStruct(value, base, attribute)
define(xreadStruct, `
        add     x9,     $2,     $3              // Add the size
        ldr	    $1,     [x29,   x9]             // Load the value
')
// xwriteStruct(value, base, attribute)
define(xwriteStruct, `
        add     x9,     $2,     $3              // Add the size
        mov     x10,    $1
        str     x10,    [x29,   x9]             // And Adds x10 to x9
')
divert

divert(`-1')
// xalloc(size)
define(xalloc, `
    format(`

        cmp     $1,     xzr                     // Compare negative
        b.gt    if_%s                           // Not negative
        b       else_%s                         

if_%s:  sub     $1,     xzr,    $1              // Negate the size
else_%s:
        and     $1,     $1,     -16             // And -16
        add     sp,     sp,     $1              // Allocate on SP
    
    ', eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter))    
    g_count()

')
// xdealloc(size)
define(xdealloc, `
        sub     $1,     xzr,    $1              // Negate the size again to positive
        add     sp,     sp,     $1              // dealloc on SP
')
divert