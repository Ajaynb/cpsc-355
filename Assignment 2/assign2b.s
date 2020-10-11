








        .text                                                       // Read-only texts
prtnwd: .string "Enter the number of words: "                       // Message for user input on the number of words
prtocc: .string "Words occurence: "                                 // Prefix text for all word occurences
prtnum: .string "%d "                                               // Occurence of word
prtsum: .string "Total occurence: %d \n"                            // Total occurence
prtlow: .string "Lowest frequency: %d\% \n"                         // Lowest frequency
prthig: .string "Highest frequency: %d\% \n"                        // Highest frequency
linebr: .string "\n"                                                // Line break
scnocc: .asciz "%d"                                                 // Scan for user input

        .balign 4                                                   // align
        .global main                                                // expose main function to OS

main:                                                               // main function
        // Saves state
        stp     x29,    x30,    [sp, -16]!                          // space stack pointer
        mov     x29,    sp                                          // frame-pointer = stack-pointer;


        // Printing user input message
        ldr     x0,     =prtnwd                                     // 1st parameter: prtnwd, the string
        bl      printf                                              // printf(prtnwd);

        // Ask for user input on the number of words
        ldr     x0,     =scnocc                                     // 1st parameter: scnocc, the formatted string
        ldr     x1,     =n                                          // 2nd parameter: &n, the data to store for user input
        bl      scanf                                               // scanf(scnocc, &n);
        ldr     x1,     =n                                          // 2nd parameter: &n
        ldr     x19,    [x1]                                        // int n = x1;



nrangeless:                                                         // r range less
        // Check the range of n. If n is less than 5, then set the number of word to 5.
        cmp     x19,    5                                           // if (n < 5);
        b.lt    nless                                               // then go to: nless n = 5;
        b       nrangegreat                                         // else continue;

nless:  mov     x19,    5                                           // n = 5;



nrangegreat:                                                        // n range greater
        // Check the range of n. If n is greater than 20, then set the number of word to 20.
        cmp     x19,    20                                          // if (n > 20);
        b.gt    ngreat                                              // then go to: ngreat n = 20;
        b       randomnumbers                                       // else continue;

ngreat: mov     x19,    20                                          // n = 20;



randomnumbers:                                                      // random numbers
        // Set random seed
        mov 	x0, 	0                                           // 1st parameter: 0
        bl 		time                                                // time(0);
        bl 		srand                                               // srand(time(0)); set random seed to current timestamp

        // Intialize variables
        mov     x20,        0                               // int loopTimes = 0; initialize the times of loop
        mov     x21,   0                               // int totalOccurence = 0; initialize the total occurence

        mov     x22,  9                               // int lowestOccurence = 0; initialize the lowest occurence
        mov     x23, 0                               // int highestOccurence = 0; initialize the highest occurence

        mov     x28,        0                               // int occurence = 0; initialize current occurence
        
        // Print out prefix message, to remind user the following printouts are word occurences
        ldr     x0,     =prtocc                                     // 1st parameter: prtocc
        bl      printf                                              // printf(prtocc);


        b       postest                                             // Go to loop condition



loop:   add     x20, x20, 1                         // loopTimes ++;

        // Generate a random number as current word occurence
        bl 	rand                                                    // rand(); get a random number as current word occurence

        mov     x10,    10                                          // int ten = 10; a constant for multiplication
        mov  	x9, 	x0                                          // int rand = x0; get the random number

        // Calculate and range the random number to 0-9
        udiv    x11,    x9,     x10                                 // int quotient = rand / 10; calculate the quotient after 10x
        mul     x12,    x11,    x10                                 // int product = quotient * 10; calculate the product for remainder
        sub     x13,    x9,     x12                                 // int remainder = rand - product; calculate the remainder as the ranged random number

        mov     x28, x13                                    // occurence = remainder; assign the remainder as current occurence
        

        // Cumulate total occurence amount
        add     x21, x28, x21     // totalOccurence += occurence; cumulate the current occurence to total occurence by addition

        // Print out the current word occurence
        ldr     x0,     =prtnum                                     // 1st parameter: prtnum
        mov     x1,     x28                                 // 2nd parameter: occurence
        bl      printf                                              // printf(prtnum, occurence); print out the current occurence of the word

        // If current word occurence is the lowest
        cmp     x28,  x22                     // if (occurence < lowestOccurence);
        b.lt    replow                                              // then replace the lowest occurence with current;
        b       notlow                                              // else continue;

replow: mov     x22, x28                      // lowestOccurence = occurence; assign the current occurence as the lowest occurence
notlow:

        // If current word occurence is the highest
        cmp     x28,        x23              // if (occurence > highestOccurence);
        b.gt    rephigh                                             // then replace the highest occurence with current;
        b       nothigh                                             // else continue;

rephigh:mov     x23, x28                     // highestOccurence = occurence; assign the current occurence as the highest occurence
nothigh:



postest:cmp     x20, x19                                    // if (loopTimes < n); loop condition
        b.lt    loop                                                // then keep looping;
        b       totaloccur                                          // else continue;


totaloccur:                                                         // total occurence
        // Print a line break
        ldr     x0,     =linebr                                     // 1st parameter: linebr
        bl      printf                                              // printf(linebr);

        // Print total word occurences
        ldr     x0,     =prtsum                                     // 1st parameter: prtsum, the formatted string
        mov     x1,     x21                            // 2nd parameter: totalOccurence, the number to replace
        bl      printf                                              // printf(prtsum, totalOccurence);


frequency:                                                          // frequency
        // Initialize variables
        mov     x24,  0                               // int lowestFrequency = 0; initialize the lowest frequency
        mov     x25, 0                               // int highestFrequency = 0; initialize the highest frequency
        mov     x26,    100                                         // int oneHundred = 100; a constant for multiplication


        // Calculate lowest frequency
        mul     x9, x22, x26                          // int temp = lowestOccurence * oneHundred; calculate the product of the lowest occurence after 100x
        sdiv    x24, x9, x21             // lowestFrequency = temp / totalOccurence; calculate the lowest frequency

        // Calculate highest frequency
        mul     x9, x23, x26                         // int temp = highestOccurence * oneHundred; calculate the product of the highest occurence after 100x
        udiv    x25, x9, x21            // highestFrequency = temp / totalOccurence; calculate the highest frequency


        // Printing the lowest frequency
        ldr     x0,     =prtlow                                     // 1st parameter: prtlow, the formatted string
        mov     x1,     x24                           // 2nd parameter: lowestFrequency, the lowest frequency variable
        bl      printf                                              // printf(prtlow, lowestFrequency); print the lowest frequency

        // Printing the highest frequency
        ldr     x0,     =prthig                                     // 1st parameter: prthig, the formatted string
        mov     x1,     x25                          // 2nd parameter: highestFrequency, the highest frequency variable
        bl      printf                                              // printf(prthig, highestFrequency); print the highest frequency



        // Restores state
        ldp     x29,    x30,    [sp], 16                            // return stack pointer space
        ret                                                         // return to OS


        .data                                                       // global variables
n: 	    .int 	0                                                   // int n = 0

