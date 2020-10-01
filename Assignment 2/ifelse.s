// void main(){
// 	register int x = 1;    // ask the compiler to save the variable in a register instead of memory
// 	register int y = 2;
// 	if (x==y)
// 		printf("The compared values are the same")
// }
// else 
// {
//  printf("The compared values are not the same")
//
//} 
// 
// optimize the following implementation

		.balign 4
		.global main
main:	
		stp		x29, 	x30, 	[sp, -16]!
		mov 	x29, 	sp

		mov 	x19,  	10
		mov		x20, 	8

		cmp 	x19, 	x20
		b.ne 	endif
		//ldr 	x0, 	=output2
		//bl 		printf
		//b.ne 	endif 							// optimize 
		//b 		endif 							// branch to
true: 	ldr 	x0, 	=output1
		bl 		printf
endif:	
		
		ldp 	x29, 	x30, 	[sp], 	16
		ret
output1: .string "the compared values are the same.\n"
// output2: .string "the compared values are different. \n"