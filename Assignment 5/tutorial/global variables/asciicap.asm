		.data							// This section contains programmer-initialized data			
max:	.word	90

		.bss							//This section contains uninitialized space allocated with the .skip pseudo-op
array_uninit:	 .skip	26 * 1			// char array = 26 bytes
c_var:     .skip	1					// char = 1 byte
h_var:     .skip	2					// short int = 2 bytes
 
		.text
fmt:	.string "%c\n"

		.balign 4
		.global main

main:  
		stp		x29, x30, [sp, -16]!
		mov		x29, sp

		adrp	x19, max					// Load address of i (high order bits)
		add		x19, x19, :lo12:max			// Load address of i (low order bits)

		ldr		w20, [x19]					// Load value of max from memory to w20
		
		
// Same steps for array	
		adrp	x19, array_uninit
		add		x19, x19, :lo12:array_uninit
		mov 	x23, 0
		mov 	w22, 'A'
		b test

loop:
		strb 	w22, [x19, x23]
		add 	w22, w22, 1						//Calculate dec value ofnext letter 
		
		adrp 	x0, fmt							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:fmt				// Set 1st arg (lower 12 bits)   
	    ldrb 	w1, [x19, x23]
	    bl printf							    // Call printf
		
		add 	x23, x23, 1						//Increment counter

test:
		cmp 	w22, 'Z'
		b.le 	loop
        adrp	x19, c_var					    // Load address of i (high order bits)
		add		x19, x19, :lo12:c_var			// Load address of i (low order bits)
        mov w22, 'M'                            // Load value to be stored at c_var
		strb 	w22, [x19]

		adrp 	x0, fmt							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:fmt				// Set 1st arg (lower 12 bits)   
	    ldrb 	w1, [x19]
	    bl printf	
		ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret										// Return to OS
		
