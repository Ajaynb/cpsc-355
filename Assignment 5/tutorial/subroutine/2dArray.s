output: 	.string "arr[%d][%d] = %d "
newline: 	.string "\n"

i_r 		.req x19
j_r 		.req x20
fact_r 		.req x21
offset_r	.req x22
base_r 		.req x23
temp_r 		.req x24
alloc_r 	.req x25
// save both i and fact(i) into the stack, 2x10 array

// 					  <--sp
// 		 	|_fact_10_|
// 			|__i_10___|
// 			.  		 .
//			.   	 .
// 			|__i_3___|
// 			|_fact_2_|
// 			|__i_2___|
//  		|_fact_1_|
//        	|__i_1___|<--fp
// 			| fp |lr |

		.balign 4
		.global main

main:
		stp 	x29, 		x30, 	[sp, -16]!
		mov 	x29, 		sp

		mov		i_r, 		1
		mov		fact_r, 	1

		// calculate alloc: 	2 row, 10 column
		mov 	alloc_r, 	-(2*10*8)&-16
		// allocate the required space for the 2D array
		add 	sp,			sp, 	alloc_r

loop:
		mul 	fact_r, 	fact_r, 	i_r 				
		lsl 	offset_r, 	i_r, 4
		sub	 	offset_r, 	xzr, 		offset_r 
		str 	fact_r, 	[x29, offset_r] 				// store fact(i)
		add		offset_r,  	offset_r, 	8
		str 	i_r, 		[x29, offset_r] 				// store i

		add		i_r, 		i_r, 		1
		cmp		i_r, 		10 									
		b.le	loop

		mov 	i_r, 		0
		mov 	j_r, 		0
		mov 	base_r, 	-8
		mov 	offset_r, 	0
print:
		ldr		x0, 		=output
		mov 	x1, 		i_r
		mov		x2, 		j_r
		lsl 	temp_r,		i_r,  		4
		add  	temp_r,  	temp_r, 	j_r, lsl 3 			
		sub		offset_r, 	base_r, 	temp_r	 			// offset = base + i*2*8bytes + j*8bytes 	
		ldr		x3,			[x29, offset_r] 			// print a[i][j], offset+8*i*j
		bl 		printf
		//add		offset_r, 	offset_r,  -8
		add 	j_r, 		j_r,	1
		cmp 	j_r, 		2
		b.lt 	print
		ldr 	x0, 		=newline
		bl 		printf
		mov 	j_r, 		0
		add		i_r, 		i_r, 	1
		cmp 	i_r, 		10
		b.lt	print

// 		deallocate the 2d array
		sub 	alloc_r, 	xzr, 	alloc_r
		add		sp, 		sp, 	alloc_r

		ldp		x29, 	x30, 	[sp], 	16
		ret

// 