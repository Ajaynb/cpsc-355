divert(`-1')
// min(destination, num1, num2)
define(min, `
    format(`
        cmp     $2,     $3
        b.lt    if_%s
        b       else_%s
if_%s:   mov    $1,     $2
        b       end_%s
else_%s: mov  $1,     $3
        b       end_%s
end_%s:
    ', eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter))
    g_count()
')

// max(destination, num1, num2)
define(max, `
    format(`
        cmp     $2,     $3
        b.gt    if_%s
        b       else_%s
if_%s:   mov    $1,     $2
        b       end_%s
else_%s: mov  $1,     $3
        b       end_%s
end_%s:
    ', eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter))
    g_count()
')
divert