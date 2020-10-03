
        .text                                   // Read-only texts
print1: .string "Enter the number of words: "   // Message for user input
print2: .string "Words occurence: "             // Prefix text for all word occurences
print3: .string "%d "                           // Occurence of word
print4: .string "Total occurence: %d \n"        // Total occurence
print5: .string "Lowest frequency: %d \n"       // Lowest frequency
print6: .string "Highest frequency: %d \n"      // Highest frequency
linebr: .string "\n"                            // Line break
scan1:  .asciz "%d"                             // Scan for user input

        .balign 4                               // align
        .global main                            // expose main function to OS

main:                                           // main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!      // space stack pointer
        mov     x29,    sp                      // frame-pointer = stack-pointer


        // Printing user input message
        ldr     x0,     =print1                 // x0 = print1
        bl      printf                          // printf(print1)

        // Prompt for user input
        ldr     x0,     =scan1                  // x0 = scan1
        ldr     x1,     =n                      // x1 = &n
        bl      scanf                           // scanf(scan1, &n)
        ldr     x1,     =n                      // x1 = &n
        ldr     x19,    [x1]                    // int n = x1



nrangeless:                                     // r range less
        // Check the range of n. If n is less than 5.
        cmp     x19,    5                       // if (n < 5)
        b.lt    nless                           // then go to nless n = 5
        b       nrangegreat                     // else continue

nless:  mov     x19,    5                       // n = 5




nrangegreat:                                    // n range greater
        // Check the range of n. If n is greater than 20.
        cmp     x19,    20                      // if (n > 20)
        b.gt    ngreat                          // then go to ngreat n = 20
        b       randomnumbers                   // else continue

ngreat: mov     x19,    20                      // n = 20



randomnumbers:                                  // random numbers
        // Set random seed
        mov 	x0, 	0                       // x0 = 0
        bl 		time                            // time(0)
        bl 		srand                           // srand(time(0))

        // Intialize variables
        mov     x20,    0                       // int loopTimes = 0
        mov     x21,    0                       // int totalOccurence = 0

        mov     x22,    9                       // int lowestOccurence = 0
        mov     x23,    0                       // int highestOccurence = 0

        mov     x28,    0                       // int occurence = 0
        
        // Print out prefix message
        ldr     x0,     =print2                 // x0 = print2
        bl      printf                          // printf(print2)



pretest:cmp     x20,    x19                     // if (loopTimes < n)
        b.lt    loop                            // then keep looping
        b       totaloccur                      // else continue

loop:   add     x20,    x20,    1               // loopTimes ++

        // Generate a random number as current word occurence
        bl 	rand                            	// rand()

        mov     x10,    10                      // int ten = 10;
        mov  	x9, 	x0                      // int rand = x0

        udiv    x11,    x9,     x10             // int quotient = rand / 10
        mul     x12,    x11,    x10             // int product = quotient * 10
        sub     x13,    x9,     x12             // int remainder = rand - product

        mov     x28,    x13                     // occurence = remainder
        

        // Cumulate total occurence amount
        add     x21,    x28,    x21             // totalOccurence += occurence

        // Print out the current word occurence
        ldr     x0,     =print3                 // x0 = print3
        mov     x1,     x28                     // x1 = occurence
        bl      printf                          // printf(print3, occurence)

        // If current word occurence is the lowest
        cmp     x28,    x22                     // if (occurence < lowestOccurence)
        b.lt    replow                          // then replace the lowest occurence with current
        b       notlow                          // else continue

replow: mov     x22,    x28                     // lowestOccurence = occurence
notlow:

        // If current word occurence is the highest
        cmp     x28,    x23                     // if (occurence > highestOccurence)
        b.gt    rephigh                         // then replace the highest occurence with current
        b       nothigh                         // else continue

rephigh:mov     x23,    x28                     // highestOccurence = occurence
nothigh:

        // Go back to pretest
        b       pretest                         // loop, back to condition pretest



totaloccur:                                     // total occurence
        // Print out a line break
        ldr     x0,     =linebr                 // x0 = linebr
        bl      printf                          // printf(linebr)

        // Print out total word occurences
        ldr     x0,     =print4                 // x0 = print4
        mov     x1,     x21                     // x1 = totalOccurence
        bl      printf                          // printf(print4, totalOccurence)


frequency:                                      // frequency
        // Initialize variables
        mov     x24,    0                       // int lowestFrequency = 0
        mov     x25,    0                       // int highestFrequency = 0
        mov     x26,    100                     // int oneHundred = 100


        // Calculate lowest frequency
        mul     x9,     x22,    x26             // int temp = lowestOccurence * oneHundred
        sdiv    x24,    x9,    x21              // lowestFrequency = temp / totalOccurence

        // Calculate highest frequency
        mul     x9,     x23,    x26             // int temp = highestOccurence * oneHundred
        udiv    x25,    x9,    x21              // highestFrequency = temp / totalOccurence


        // Printing the lowest frequency
        ldr     x0,     =print5                 // x0 = print5
        mov     x1,     x24                     // x1 = lowestFrequency
        bl      printf                          // printf(print5, lowestFrequency)

        // Printing the highest frequency
        ldr     x0,     =print6                 // x0 = print6
        mov     x1,     x25                     // x1 = highestFrequency
        bl      printf                          // printf(print6, highestFrequency)



        // Restores state
        ldp     x29,    x30,    [sp], 16        // return stack pointer space
        ret                                     // return to OS


    .data                                       // global variables
n: 	.int 	0                                   // int n = 0

