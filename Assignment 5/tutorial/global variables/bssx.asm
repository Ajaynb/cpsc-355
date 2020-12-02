		.data							// This section contains programmer-initialized data			
i_var:	.hword	0

		.bss							//This section contains uninitialized space allocated with the .skip pseudo-op
array_uninit:	 .skip	3 * 4			// int array = 12 bytes
 
		.text							// This section contains program text (machine code) - programmer initialized
fmt:	.string "\n\t\t Number of elements = %hi \n\t\t array = [%d, %d, %d]\t\t \n \n"

	.balign 4
	.global main

main:  
		stp		x29, x30, [sp, -16]!
		mov		x29, sp
		
		mov 	w20, 3						// Set value for i
		adrp	x19, i_var					// Load address of i (high order bits)
		add		x19, x19, :lo12:i_var		// Load address of i (low order bits)
		mov 	x0, x19						// Set 1st argument for print
		strh	w20, [x19]					// Store value of i from w20 to memory
			
// Same steps for array	
		adrp	x19, array_uninit
		add		x19, x19, :lo12:array_uninit
		mov		x1, x19						// Set 2nd argument for printf

// Set elements of the array
		mov 	w22, 65						
		str 	w22, [x19]
		add 	w22, w22, 1					
		str 	w22, [x19, 4]
		add 	w22, w22, 1					
		str 	w22, [x19, 8]
		
// Call printsub subroutine
		bl 	printsub
				
		ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret										// Return to OS
		
printsub:
		stp   x29, x30, [sp, -16]!
		mov   x29, sp

// Save address arguments locally
		mov 	x9, x0
		mov 	x10, x1

// Set up args for printf
		adrp 	x0, fmt							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:fmt				// Set 1st arg (lower 12 bits)   
	    ldrh 	w1, [x9]
	    ldr 	w2, [x10]
		ldr 	w3, [x10, 4]
		ldr 	w4, [x10, 8]

	    bl printf							// Call printf
	    ldp x29, x30, [sp], 16				// Deallocate stack memory
		ret
