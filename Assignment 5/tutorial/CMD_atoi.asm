
//Define register aliases
fp .req x29
lr .req x30


//Macros
define(i_r, w19) 				// index, will be used to iterate through the array 
define(argc_r, w20) 				// argc: the number of arguments passed from command line
define(argv_r, x21)				// argv[]: an array of pointers to the arguments (represented as strings)

.text
fmt: 	.string "%s\n"
fmt_atoi: .string "The result is: %d \n"

	.balign 4
	.global main

main:
	stp fp, lr, [sp, -16]!			// Save FP and LR to stack, pre-increment sp
	mov fp, sp   
	
//Load arguments passed from shell
	mov argc_r, w0 				// Move value from x0 to argv_r - immediate value
	mov argv_r, x1				// Move value from x1 to argv_r - address
	mov i_r, 1 				// initializing index variable with 1 (ignoring the index 0)
	b test

top:    
	ldr x1, [argv_r, i_r, SXTW 3]		// Set up 2nd arg 
	ldr x0, =fmt
	bl printf				// Call printf 

	add i_r, i_r, 1				// i++

test:
 	cmp i_r, argc_r
	b.lt top				// Loop while i < argc

	
// ATOI example

	//Reading cmd arg at index=1, and casting it to integer
	mov i_r, 1
	ldr x0, [argv_r, i_r,SXTW 3]
	bl atoi
	mov w24, w0

	//Reading cmd arg at index=2, and casting it to integer
	mov i_r, 2
	ldr x0, [argv_r, i_r,SXTW 3]	
	bl atoi
	mov w25, w0

	add w25, w24, w25
	mov w1, w25
	ldr x0, =fmt_atoi
	bl printf


exit:
 	ldp fp, lr, [sp], 16			// Restore FP and LR from stack, post-increment SP
    	ret					// Return to caller
