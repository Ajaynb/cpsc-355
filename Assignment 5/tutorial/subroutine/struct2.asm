//Program to create two structs of type student.
 
fmt1: .string "\n student.id = %ld \n student.science = %ld \n student.math = %ld\n\n"

define(id_reg, x9)	
define(science_reg, x10)	
define(math_reg, x11)	
define(student_base, x12)									

//Base offset = fp+lr
base_off = 16

//Size of struct
size=8
student_size = size*3

total_students = student_size*2

student_s = 0								//struct base offset

first_s = 16							//First struct offset

second_s = first_s + student_size		//Second struct offset

//Set offsets for variables in struct
id_s = 0
science_s = id_s + 8
math_s = science_s + 8 

//Calculate total space required in stack
alloc = -(16+total_students) & -16
dealloc = -alloc

alloc2 = -(16+student_size) & -16
dealloc2 = -alloc2
 
alloc3 = -(16+8) & -16
dealloc3 = -alloc3
 
//Define register aliases
fp .req x29
lr .req x30

		.balign 4
		.global main
main: 
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
	mov fp, sp									//Update FP to current SP
    
	add x8, fp, first_s
	bl create
	add x8, fp, second_s
	bl create
	
	mov x8, fp
	bl printsub
	
exit:	
	mov w0, 0
	ldp fp, lr, [sp], dealloc					//Deallocate stack memory
	ret

//Subroutine to initialize struct

create:
		stp fp, lr, [sp, alloc2]!					//Store FP and LR on stack, and allocate space for local variables
    	mov fp, sp									//Update FP to current SP

//Student #1 struct  	
    	ldr id_reg, =3097646						//MOV can load any 16 bit number only (max 65536)
    	ldr science_reg, =99
    	ldr math_reg, =97    	
//Store values onto stack
		
		add student_base, fp, 16
		str id_reg, [student_base, id_s]					//Initialize student.id
    	str science_reg, [student_base, science_s]		//Initialize student.science
    	str math_reg, [student_base, math_s]				//Initialize student.math

//Return first struct to main indirectly through x8
		ldr x10, [student_base, id_s]
		str x10, [x8, id_s]							//Store student.id at address in x8+0
		
		ldr x10, [student_base, science_s]
		str x10, [x8, science_s]						//Store student.science at address in x8+8
		
		ldr x10, [student_base, student_s + math_s]
		str x10, [x8,  math_s]						//Store student.science at address in x8+16

		
		ldp fp, lr, [sp], dealloc2									//Deallocate stack memory
		ret															//Return control to main

printsub:
	stp fp, lr, [sp, alloc3]!						//Store FP and LR on stack, and allocate space for local variables
	mov fp, sp									//Update FP to current SP
	str x19, [fp, 16]							//Save x19 for main
	
	mov x19, x8
	adrp x0, fmt1								//Set 1st arg (high order bits)
	add x0, x0, :lo12:fmt1						//Set 1st arg (lower 12 bits)   
	ldr x1, [x19, student_s + first_s + id_s]
	ldr x2, [x19, student_s + first_s + science_s]
	ldr x3, [x19, student_s + first_s + math_s]
	bl printf

print2nd:
	adrp x0, fmt1								//Set 1st arg (high order bits)
	add x0, x0, :lo12:fmt1						//Set 1st arg (lower 12 bits)   
	ldr x1, [x19, student_s + second_s + id_s]
	ldr x2, [x19, student_s + second_s + science_s]
	ldr x3, [x19, student_s + second_s + math_s]
printfcall:
	bl printf
	
	ldr x19, [fp, 16]					// restore x19 for main

	ldp fp, lr, [sp], dealloc3						//Deallocate stack memory
	ret											//Return control to main
	