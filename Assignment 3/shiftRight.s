enter_r 	.req x20

infmt: 		.string "%d"
outfmt0: 	.string "Enter your 4 bits binary number:"
outfmt1: 	.string "%d >> 1 is %04d \n"

			.balign 4
			.global main

main: 		
			stp 	x29, 	x30, 	[sp, -16]!
			mov 	x29, 	sp

			ldr 	x0, 	=outfmt0
			bl 		printf

			ldr 	x0, 	=infmt
			ldr 	x1, 	=etrnumber
			bl 		scanf

			ldr 	x19, 	=etrnumber
			ldr 	enter_r, [x19]
			mov	 	x21, 	10
			udiv 	x22, 	enter_r,	x21

			ldr 	x0, 	=outfmt1
			mov		x1, 	enter_r
			mov 	x2, 	x22
			bl 		printf

			ldp 	x29, 	x30, 	[sp], 16
			ret

			.data
etrnumber:	.dword 	0		
