outfmt:	.string "Random number %d: %d its double: %d \n"   
//printf("Random number %d: %d its double: %d \n", i, r_i, 2*ri)




		.balign 4
		.global main

main:	
		stp 	x29, 	x30, 	[sp, -16]!
		mov		x29, 	sp

		mov 	x19,		1
		b pretest
		mov 	x0, 	0
		bl 		time
		bl 		srand

loop: 
		
		bl 		rand 
		and  	x2, 	x0, 0xFF 			// Returned value is saved in x0, and 0xFF limits it between 0-255, save the new value in x2 .    0 - 10    and  x2, x0, 0x0A
		ldr 	x0, 	=outfmt
		mov	 	x1, 	x19
		add		x3, 	x2, 	x2  		// Save the double in x3
		bl 		printf
		add 	x19, 	x19, 	1

pretest:
		cmp 	x19,		10
		b.le 	loop

		ldp 	x29, 	x30, 	[sp], 	16
		ret