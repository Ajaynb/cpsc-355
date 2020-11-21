divert(`-1')
// alloc(size)
define(alloc, `
        format(`
cmp     $1,     xzr                             // Compare negative
        b.gt    if_%s                           // Not negative
        b       else_%s                         

if_%s:   sub     $1,     xzr,    $1              // Negate the size
else_%s:
        ', eval(g_counter), eval(g_counter), eval(g_counter), eval(g_counter))
        and     $1,     $1,     -16             // And -16
        add     sp,     sp,     $1              // Allocate on SP

        g_count()

')
// dealloc(size)
define(dealloc, `
        sub     $1,     xzr,    $1              // Negate the size again to positive
        add     sp,     sp,     $1              // Deallocate on SP
')
divert