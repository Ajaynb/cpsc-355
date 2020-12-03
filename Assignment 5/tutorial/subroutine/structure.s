		// Equates for struct1
		i1_s = 0
		j1_s = 4
		struct1_size = 8

		// Equates for struct2
		i2_s = 0
		j2_s = 8
		struct2_size = 16

		// Equates for nested struct
		i3_s = 0
		struct1_s = 4
		struct2_s = 12
		nested_struct_size = 28

		// function: init
		alloc = -(16 + nested_struct_size) & -16
		dealloc = -alloc
		n_s = 16

//struct struct1{
//	int i_1;
//	int j_1;
//};
//struct struct2{
//	long int i_2;
//	long int j_2;
//};
//struct nested_struct{
//	int i_3;
//	struct struct1 s_1;
//	struct struct2 s_2;
//};

fmtprint:	.string	"i_3 = %d, i_1 = %d, j_1 = %d, i_2 = %d, j_2 = %d\n "
			.balign 4
	
// main: create two nested structure n1 and n2		
		alloc = -(16 + nested_struct_size*2) & -16
		dealloc = -alloc
		n1_s = 16
		n2_s = n1_s + nested_struct_size
		.global main
main: 	stp		x29, x30, [sp, alloc]!
		mov		x29, sp
		// initialize n1 and n2
		add		x8, x29, n1_s
initstruct: 	
		// initialize the nested struct
		str wzr, [x29, n_s + i3_s]
		str wzr, [x29, n_s + struct1_s + i1_s]
		str wzr, [x29, n_s + struct1_s + j1_s]
		str xzr, [x29, n_s + struct2_s + i2_s]
		str xzr, [x29, n_s + struct2_s + j2_s]
		
		// print n1 and n2
printstruct1:
		// use x0 to temporarily store the base address
		add 	x0, x29, n_s
		//call printf
		ldr		w1, [x0, i3_s]
		ldr		w2, [x0, struct1_s + i1_s]
		ldr		w3, [x0, struct1_s + j1_s]
		ldr		x4, [x0, struct2_s + i2_s]
		ldr		x5, [x0, struct2_s + j2_s]
		ldr 	x0, =fmtprint
		
		bl printf
modifystruct:
		// use w9 to temporarily store modified value
		//modify i_3
		add 	x0, x29, n_s
		ldr		w9, [x0, i3_s]
		mov		w9, 1
		str 	w9, [x0, i3_s]
		//struct1
		ldr		w9, [x0, struct1_s + i1_s]
		mov		w9, 2
		str 	w9, [x0, struct1_s + i1_s]
		ldr		w9, [x0, struct1_s + j1_s]
		mov		w9, 3
		str 	w9, [x0, struct1_s + j1_s]
		//struct2
		ldr		x9, [x0, struct2_s + i2_s]
		mov		x9, 4
		str 	x9, [x0, struct2_s + i2_s]
		ldr		x9, [x0, struct2_s + j2_s]
		mov		x9, 5
		str 	x9, [x0, struct2_s + j2_s]

printstruct2:
		// print 
		add 	x0, x29, n_s
		ldr		w1, [x0, i3_s]
		ldr		w2, [x0, struct1_s + i1_s]
		ldr		w3, [x0, struct1_s + j1_s]
		ldr		x4, [x0, struct2_s + i2_s]
		ldr		x5, [x0, struct2_s + j2_s]
		ldr 	x0, =fmtprint
		
		bl printf

		// return
		ldp		x29, x30, [sp], dealloc
		ret
