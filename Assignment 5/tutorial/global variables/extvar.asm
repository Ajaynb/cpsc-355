
/* General form to declare external variables:
label: pseudo-op value1[, value2, . . .] 	*/

		.data						// This section contains programmer-initialized data			
i_var:	.word    7
j_var:	.dword    1000
k_var:	.word    0
		
 		.text						// This section contains program text (machine code) - programmer initialized
fmt:	.string "\n\t\t i = %d \n\t\t j = %ld \n\t\t k = %d \t\t \n\n"

		.balign 4
		.global main
main:  
		stp   x29, x30, [sp, -16]!
		mov   x29, sp
		
		adrp	x19, i_var					// Load address of i (high order bits)
		add		x19, x19, :lo12:i_var		// Load address of i (low order bits)
		mov 	x0, x19						// Set 1st arg for print
		ldr		w20, [x19]					// Load value of i from memory to w20

// Same steps for j	
		adrp	x19, j_var
		add		x19, x19, :lo12:j_var
		mov		x1, x19
		ldr		x21, [x19]

// Same steps for k	
		adrp	x19, k_var
		add		x19, x19, :lo12:k_var
// k = i + j		
		add		w22, w20, w21
		str		w22, [x19]						// Save value of k to memory
		mov		x2, x19

// Call printsub subroutine
		bl printsub
				
		ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret										// Return to OS
		
printsub:
		stp		x29, x30, [sp, -16]!
		mov		x29, sp

// Save arguments
		mov		x9, x0
		mov 	x10, x1
		mov 	x11, x2

// Set up args for printf
		adrp 	x0, fmt							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:fmt				// Set 1st arg (lower 12 bits)   
	    ldr 	w1, [x9]
	    ldr 	x2, [x10]
	    ldr 	w3, [x11]

	    bl printf							// Call printf
	    ldp x29, x30, [sp], 16				// Deallocate stack memory
		ret
		