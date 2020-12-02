//Using characters and strings in assembly using .byte, .ascii, .asciz or .string
		
// This section contains program text
		.text		
strg:	.byte	'h', 'e', 'l', 'l', 'o', 'w' ,'o' ,'r' ,'l' ,'d' ,'!'	//Missing null character

//Strings are null terminated
new: 	.ascii 			" \n %c %c %c %c %c \n"												
		.byte 0								//Adds null character

//Or use .asciz or .string		
newstr:		.asciz 		"Hello World!!!\n\n"


		.balign 4
		.global main

main:  
		stp		x29, x30, [sp, -16]!
		mov		x29, sp

  
		adrp 	x0, newstr						// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:newstr			// Set 1st arg (lower 12 bits)   
	    bl printf	
	    
		
		adrp 	x0, strg						// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:strg				// Set 1st arg (lower 12 bits)   
	    bl printf								// Call printf
		 
		adrp 	x0, new							// Set 1st arg (high order bits)
	    add 	x0, x0, :lo12:new				// Set 1st arg (lower 12 bits) 
	    mov w1, 'a'   
	    mov w2, 'p'   
	    mov w3, 'p'   
	    mov w4, 'l'   
	    mov w5, 'e'   
	    bl printf
	  
		ldp 	x29, x30, [sp], 16				// Deallocate stack memory
		ret										// Return to OS
		
