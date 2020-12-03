output: 	.string "arr[%d][%d] = %d "
newline: 	.string "\n"

i_r 		.req x19
j_r 		.req x20
fact_r 		.req x21
offset_r	.req x22
base_r 		.req x23
temp_r 		.req x24
alloc_r 	.req x25


alloc = -(2*10*8+16)&-16
dealloc = -alloc


		.balign 4
		.global main

main:
		stp 	x29, 		x30, 	[sp, alloc]!
		mov 	x29, 		sp

		mov		i_r, 		1
		mov		fact_r, 	1

		add 	base_r, 	x29, 	16
		mov 	offset_r, 	0

loop:
		mul 	fact_r, 	fact_r, 	i_r 				
		str 	i_r, 		[base_r, offset_r] 				// store fact(i)
		add		offset_r,  	offset_r, 	8
		str 	fact_r, 	[base_r, offset_r] 				// store i
		add		offset_r,  	offset_r, 	8
		add		i_r, 		i_r, 		1
		cmp		i_r, 		10 									
		b.le	loop

// Pass argument, printArray(int *Array, int i, int j)
		mov 	x0, 	base_r
		bl 		printArray


		ldp		x29, 	x30, 	[sp], 	dealloc
		ret

/*print:
		ldr		x0, 		=output
		mov 	x1, 		i_r
		mov		x2, 		j_r
		lsl 	temp_r,		i_r,  		4
		add  	temp_r,  	temp_r, 	j_r, lsl 3 			//
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

*/


// printArray(int *Array, int i, int j)
// 		sub 	x0, 	x29, 	base_r
printArray:
		stp 	x29, 	x30, 	[sp, -(16+8*5)&-16]!
		mov	 	x29, 	sp
		stp 	i_r, 	j_r,  	[x29, 16]
		stp 	temp_r, offset_r, [x29, 32]
		str 	base_r,  [x29, 48]

		mov 	i_r, 		0
		mov 	j_r, 		0

		mov 	temp_r, 	0
		mov 	offset_r, 	0

		mov 	base_r, 	x0
top:

		ldr		x0, 		=output
		mov 	x1, 		i_r
		mov		x2, 		j_r
		lsl 	temp_r,		i_r,  		4
		add  	temp_r,  	temp_r, 	j_r, lsl 3 			//
		mov		offset_r, 	temp_r	 						// offset = base + i*2*8bytes + j*8bytes 	
		ldr		x3,			[base_r, 	offset_r] 			// print a[i][j], offset+8*i*j
		bl 		printf
		add 	j_r, 		j_r,	1
		cmp 	j_r, 		2
		b.lt 	top
		ldr 	x0, 		=newline
		bl 		printf
		mov 	j_r, 		0
		add		i_r, 		i_r, 	1
		cmp 	i_r, 		10
		b.lt	top

// 		restore callee-saved registers
		ldp 	i_r, 	j_r, 	[x29, 16]
		ldp		temp_r, offset_r, [x29, 32]
		ldr 	base_r,  [x29, 48]

		ldp 	x29, 	x30,	[sp], 64
		ret

