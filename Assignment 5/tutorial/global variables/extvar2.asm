 			.data						// This section contains programmer-initialized data			
j_var:		.word	(11 * 4) - 6		// Result stored in 4 bytes
array_init:	.byte	10, 20, 30			// 1 byte for each element

 
		.text						// This section contains program text (machine code) - programmer initialized
i_var:	.word	23					// Uses 2 bytes from RAM - cannot be overwritten

fmt:	.string "\n\t\t i = %hi \n\t\t j = %d \n\t\t array = [%d, %d, %d] \t\t \n\n"

		.balign 4
		.global main
  
main:  
		stp		x29, x30, [sp, -16]!
		mov		x29, sp
		
		adrp	x19, i_var					// Load address of i (high order bits)
		add		x19, x19, :lo12:i_var		// Load address of i (low order bits)
		mov 	x0, x19						// Set 1st arg for print
//Attempt to change value of i - fails
		mov w20, 40
		str w20, [x19]
// Same steps for j	
		adrp	x19, j_var
		add		x19, x19, :lo12:j_var
		mov		x1, x19						// Set 2nd arg for print

// Same steps for array	
		adrp	x19, array_init					// Load address of array base (high order bits)
		add		x19, x19, :lo12:array_init		// Load address of array base  (low order bits)
		mov		x2, x19							// Set 3rd arg for print

		mov 	w22, 56							// Load new value for 1st element in array
		strb 	w22, [x19]						// Store new value in array

// Call printsub subroutine
		bl printsub
				
		ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret										// Return to OS
		
printsub:
		stp   x29, x30, [sp, -16]!
		mov   x29, sp

// Save arguments
		mov 	x9, x0
		mov 	x10, x1
		mov		x11, x2

// Set up args for printf
		adrp 	x0, fmt							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:fmt				// Set 1st arg (lower 12 bits)   
	    ldrh 	w1, [x9]						// Set i as 2nd arg
	    ldr 	x2, [x10]						// Set j as 3rd arg
	    ldrb 	w3, [x11]						// Set array as 4th arg
		ldrb 	w4, [x11, 1]
		ldrb 	w5, [x11, 2]

	    bl 	printf								// Call printf
	    ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret
		