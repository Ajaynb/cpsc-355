# Assembly x64 Cheat Sheet

## Menu

 - [Registers](#Registers)
 - [Basic Program Structure](#Basic-Program-Structure)
 - [Addition and Subtraction](#Addition-and-Subtraction)
   - [Add](#Add)
   - [Divide](#Divide)
 - [Multiplications](#Multiplications)
    - [Multiply](#Multiply)
    - [Multiply-add](#Multiply-add)
    - [Multiply-subtract](#Multiply-subtract)
    - [Multiply-negate](#Multiply-negate)
 - [Divisions](#Divisions)
    - [Signed-divide](#Signed-divide)
    - [Unsigned-divide](#Unsigned-divide)
 - [Printing](#Printing)
 - [Scanning](#Scanning)
 - [Branching and Linking](#Branching-and-Linking)
 - [Condition and Compare](#Condition-and-Compare)
    - [Flags](#Flags)
    - [Conditions](#Conditions)
    - [If](#If)
    - [If-else](#If-else)
 - [Loops](#Loops)
    - [Do-while](#Do-while)
    - [While](#While)
    - [For](#For)



## Registers

Register|Description
--|--
`x0`-`x7`|Arguments & Return values
`x8`|Indirect result
`x9`-`x15`|Temporary
`x16`, `x17`|Intra-procedure-call temporary
`x18`|Platform
`x19`-`x28`|Callee-saved
`x29`|Frame pointer (FP)
`x30`|Link register (LR)
`xzr`|Zero, 0
`sp`|Stack-pointer (SP) (64-bit)
`pc`|Program Counter (PC) (64-bit)


## Basic Program Structure
```
        // Expose main function to OS
        .global main

main:   
        // Saves state
        stp     x29,    x30,    [sp, -16]!
        mov     x29,    sp

        // Code
        ...

        // Restores state
        ldp     x29,    x30,    [sp],   16
        ret
```

## Addition and Subtraction

### Add
Form: `add destination source source`  

Eg: `add x19 x20 x21`  
Eq: `x19 = x20 + x21`

Eg: `add x19 x20 10`  
Eq: `x19 = x20 + 10`  

Note: accepts immediate value

### Divide
Form: `sub destination source source`  

Eg: `sub x19 x20 x21`  
Eq: `x19 = x20 - x21`  

Eg: `sub x19 x20 10`  
Eq: `x19 = x20 - 10`  

Note: accepts immediate value

## Multiplications

### Multiply
Form: `mul destionation source source`  

Eg: `mul x19 x20 x21`  
Eq: `x19 = x20 * x21`  

### Multiply-add
Form: `madd destination source source source`  

Eg: `madd x19 x20 x21 x22`  
Eq: `x19 = (x20 * x21) + x22`  

### Multiply-subtract
Form: `msub destination source source source`  

Eg: `msub x19 x20 x21 x22`  
Eq: `x19 = (x20 * x21) - x22`  

### Multiply-negate
Form: `mneg destination source source`  

Eg: `mneg x19 x20 x21`  
Eq: `x19 = -(x20 * x21)`


## Divisions
Note: integer division, discard remainders

### Signed-divide
Form: `sdiv destination source source`  

Eg: `sdiv x19 x20 x21`  
Eq: `x19 = x20 / x21`  

### Unsigned-divide
Form: `udiv destination source source`  

Eg: `udiv x19 x20 x21`  
Eq: `x19 = x20 / x21`  



## Printing

C:
```
int x = 42;
printf("Meaning of life = %d\n", x);
```

Assembly:
```
output: .string "Meaning of life = %d\n"
        .balign 4
        .global main

main:
        mov     x0,     42
        ldr     x0,     =output
        bl      printf
```


## Scanning
C:
```
int n;
scanf("%d", &n);
```

Assembly:
```
input:  .string "%d"
        .balign 4
        .global main

main:
        ldr     x0,     =input
        ldr     x1,     =n
        bl      scanf
        ldr     x14,    =n
```



## Branching and Linking
Form: `bl function`  
Eg: `bl printf`


## Condition and Compare

### Flags
Flag Code|Description
--|--
Z|true if result is **z**ero
N|true if result is **n**egative
V|true if result o**v**erflows
C|true if result generates a **c**arry out

### Conditions

Condition Code|Description|C Equivalent|Flag
--|--|--|--
`eq`|equal|`==`|`Z == 1`
`ne`|not equal|`!=`|`Z == 0`
`gt`|greater than|`>`|`Z == 0 && N == V`
`ge`|greater than or equal|`>=`|`N == V`
`lt`|less than|`<`|`N != V`
`le`|less than or equal|`<=`|`!(Z == 0 && N == V)`


### If

C:
```
if (a > b) {
    c = a + b;
    d = c + 5;
}
```
Assembly:
```
define(a_r, x19)
define(b_r, x20)
define(c_r, x21)
define(d_r, x22)

        ...

        cmp     a_r,    b_r // test
        b.le    next        // logical complement

        add     c_r,    a_r,    b_r // body
        add     d_r,    c_r,    5

next:   statement after if-construct
```

### If-else

C:
```
if (a > b) {
    c = a + b;
    d = c + 5;
} else {
    c = a - b;
    d = c - 5;
}
```
Assembly:
```
define(a_r, x19)
define(b_r, x20)
define(c_r, x21)
define(d_r, x22)

        cmp     a_r,    b_r
        b.le    else

        add     c_r,    a_r,    b_r
        add     d_r,    c_r,    5

        b       next 

else:   sub     c_r,    a_r,   b_r
        sub     d_r,    c_r,   5

next:   statement after if-else construct
```


## Loops

### Do-while

C:
```
long int x;
x = 1;

do {
    // loop body

    x++;
} while (x <= 10);
```
Assembly:
```
define(x_r, x19)
        mov  x_r, 1

top:    // statements forming loop body

        add     x_r,    x_r,    1
        cmp     x_r,    10
        b.le    top
```

### While
C:
```
long int x;
x = 0;
while (x < 10) {
    // loop body

    x++;
}
```
Assembly:
```
define(x_r, x19)
        mov     x_r,    0

test:   cmp     x_r,    10
        b.ge    done

        // statements forming body of loop

        add     x_r,    x_r,    1
        b test

done:   // statement following loop
```


### For

C:
```
for (i = 10; i < 20; i++)
    x += i;
```
```
i = 10;
while (i < 20) {
    x += i;
    i ++;
}
```
Assembly:
```
define(i_r, x19)
define(x_r, x20)

        mov     i_r,    10          // init
        b       test

top:    add     x_r,    x_r,    i_r // loop body
        add     i_r,    i_r,    1   // increment

test:   cmp     i_r,    20          // test
        b.lt    top
```
