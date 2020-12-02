 //Program to create nested structures.
    
fmt1: .string "\n ID: %d\n"
fmt2: .string "\n Marks: \n\t\t Physics= %d \n\t\t Math = %d \n\t\t Chemistry = %d\n"
fmt3: .string "\n Tuition fee: $%d per month\n\n"

										
//Student struct
marks_size = 8*3									//Phy, Math, Chem (8*3 = 24 bytes)
base_size = 8*2										//ID + Tuition fee = 16 bytes

//Set the offsets for values in struct
student_s = 16

id_s = 0
marks_s = 8								
tuitionfee_s = 32				

//Marks nested struct
physics_s = 0
math_s =  8
chemistry_s = 16

student_size = student_s + base_size + marks_size

//Calculate total space required in stack
alloc = -(16+student_size) & -16
dealloc = -alloc

 //Define register aliases
fp .req x29
lr .req x30

	.balign 4
	.global main
main: 
	stp fp, lr, [sp, alloc]!						//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp										//Update FP to current SP
    
    add x8, fp, student_s							//Calculate base address in this subroutine
	bl create										//Call create
	
	bl printstudent									//Call printstudent
	
exit:	

	mov x0, 0											//Return 0
	ldp fp, lr, [sp], dealloc							//Deallocate stack memory
	ret

create:
		
		stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    	mov fp, sp									//Update FP to current SP
    	
    	ldr x9, =3097646							//MOV can load any 16 bit number only (max 65536)
    		
//Store values onto stack
    	str x9, [fp, student_s + id_s]						//Store student.id on to stack
	
		mov x9, 98
		str x9, [fp, student_s + marks_s + physics_s]		//Store student.marks.physics on to stack
		
		mov x10, 99
		str x10, [fp, student_s + marks_s + math_s]			//Store student.marks.math on to stack

		mov x11, 97
		str x11, [fp, student_s + marks_s + chemistry_s]	//Store student.marks.chemistry on to stack

		mov x12, 1000
		str x12, [fp , student_s + tuitionfee_s]			//Store student.tuitionfee on to stack

//Returning values indirectly to main through x8

		ldr x9, [fp, student_s + id_s]						//Copy student.id 
		str x9, [x8, id_s]			
    	

		ldr x9, [fp, student_s + marks_s + physics_s]		//Copy student.marks.physics
		str x9, [x8, marks_s + physics_s]
		
		ldr x10, [fp, student_s + marks_s + math_s]			//Copy student.marks.math
		str x10, [x8, marks_s + math_s]

		ldr x11, [fp, student_s + marks_s + chemistry_s]	//Copy student.marks.chemistry
		str x11, [x8, marks_s + chemistry_s]

		ldr x11, [fp , student_s + tuitionfee_s]			//Copy student.tuitionfee
		str x11, [x8 , tuitionfee_s]

		ldp fp, lr, [sp], dealloc							//Deallocate stack memory
		ret	

printstudent:
	stp fp, lr, [sp, -16]!										//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp													//Update FP to current SP
    mov x19, x8

//Print student.id	
	adrp x0, fmt1											//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1									//Set 1st arg (lower 12 bits)   
    ldr x1, [x19, id_s]
    bl printf
    
//Print student.marks	
	adrp x0, fmt2											//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt2									//Set 1st arg (lower 12 bits)   
    ldr x1, [x19, marks_s + physics_s]
    ldr x2, [x19, marks_s + math_s]
    ldr x3, [x19, marks_s + chemistry_s]
    bl printf
    
//Print student.tuitionfee	
	adrp x0, fmt3											//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt3									//Set 1st arg (lower 12 bits)   
    ldr x1, [x19, tuitionfee_s]
    bl printf	
	
    
    ldp fp, lr, [sp], 16				//Deallocate stack memory
    ret									//Return to main
    