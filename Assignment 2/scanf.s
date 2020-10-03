//int varX;

//void main(){
//	scanf("%d", &varX);
//	printf("You have entered %d\n", varX);
//}

		.text 	// Code section. Read only 
prnfmt1: .string "Enter an integer:"
prnfmt2: .string "you have entered: %d\n"
scnfmt:  .asciz "%d"

		  		// Using macros

		.balign 	4
		.global 	main
main: 	
		stp 	x29, 	x30, 	[sp, -16]!
		mov		x29, 	sp

		ldr 	x0, 	=prnfmt1
		bl 		printf

		ldr 	x0, 	=scnfmt
		ldr 	x1, 	=varX
		bl 		scanf 

		ldr 	x1, 	=varX  				// Load register x1 with the address of variable varX
		ldr 	x19, 	[x1]    			// Load the content of varX in register x19

		ldr 	x0, 	=prnfmt2
		mov 	x1, 	x19
		bl 		printf

		ldp 	x29, 	x30, 	[sp], 16
		ret

		//data section contains initialized global variables
		.data   		
varX: 	.int 	0
