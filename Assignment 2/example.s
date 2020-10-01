// File: example.s
// Author: Konstantinos Liosis
// Date: January 27, 2019
//
// Description:
// This is an example of basic arithmetic operations in assembly
// and of calling the printf function to print a result

//Define the format of the string you'll use to output the result
str:	.string "The sum of %d and %d is %d\n"

	.balign	4			// Instructions must be word aligned
	.global main			// Make "main" visible to the OS and start the execution

main:	stp 	x29, x30, [sp, -16]!	// Save FP and LR to stack
	mov 	x29, sp			// Update FP to the current SP
	
	mov		x19, 15		// Assign the value 15 to register 19
	mov		x20, 340	// Assign the value 340 to register 19
	
	// Prepare the arguments for printf in correct order
arg:	//adrp 	x0, str			// Set high-order bits of the 1st argument (format string)
	//add 	x0, x0, :lo12:str	// Set 1st argument (12 lower-order bits)
	ldr	x0, =str		// one-liner
	mov	x1, x19			// 2nd argument
	mov 	x2, x20			// 3rd argument
	add 	x3, x19, x20		// Assign the sum of register 19 and 340 to register 1 (integer argument)

print:	bl	printf			// Call printf() function

	ldp 	x29, x30, [sp], 16	// Restore FP and LR from stack
	ret				// Return to caller (OS)
