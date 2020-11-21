divert(`-1')
// randomSeed()
define(randomSeed, `
        mov     x0,     0                       // 1st parameter: 0
        bl      time                            // time(0);
        bl      srand                           // srand(time(0));
')

// random()
define(random, `
        bl      rand                            // rand();
        and  	x9,     x0,     $2              // int x9 = rand() & $2;
        mov     $1,     x9                      // $1 = x9;
')
divert