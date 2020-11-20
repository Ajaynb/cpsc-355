include(`mulAll.m4')
divert(`-1')
// Defining Open Routine Functions: alloc(destination, param1, param2, ...)
define(alloc, `
        mulAll($@)                            // Multiply all parameters to get a final size
        sub     $1,     xzr,    $1              // Negate the size
        and     $1,     $1,     -16             // And -16
        add     sp,     sp,     $1              // Allocate on SP
')
// Defining Open Routine Functions: dealloc(size)
define(dealloc, `
        sub     $1,     xzr,    $1              // Negate the size again to positive
        add     sp,     sp,     $1              // Deallocate on SP
')
divert