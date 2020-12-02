    
fmt1: .string "\n student.math = %d & student.science = %d \n\n"

define(student_base, x28)	
										
//Set offsets for values in struct
size = 8								//2 int values
math_size = 4
science_size = 4

math_s = 0
science_s = math_s + math_size

//Size of struct
student_size = size*2					//for two structs

//Calculate total space required in stack
alloc = -(16+student_size) & -16
dealloc = -alloc
alloc1 = -(16+size) & -16
dealloc1 = -alloc1
first_s = 16
second_s = 16 + size

base_off = 16

 //Define register aliases
fp .req x29
lr .req x30

.balign 4
.global main

main: 
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
	mov fp, sp									//Update FP to current SP
 
 //Create first struct   
	add x8, fp, first_s
	bl create
	
	add x8, fp, first_s
	bl printsub
	
//Create second struct   

	add x8, fp, second_s
	bl create
	
	add x8, fp, second_s
	bl printsub
	
exit:	

	mov x0, 0
	ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret

create:
		
	stp fp, lr, [sp, alloc1]!				//Store FP and LR on stack, and allocate space for local variables
	mov fp, sp								//Update FP to current SP
    	
	mov w9, 96						
	mov w10, 99
//Calculate student struct base address
    	
	add student_base, fp, base_off			//Calculate base address for struct
    	
//Store values onto stack
	str w9, [student_base, math_s]			//Initialize student.id
	str w10, [student_base, science_s]		//Initialize student.science

//Returning values through x8 - storing in stack space of main

	ldr w11, [student_base, math_s]
	str w11, [x8, math_s]						//Store student.id at address in x8+0
		
		
	ldr w11, [student_base, science_s]
	str w11, [x8, science_s]					//Store student.science at address in x8+4
		

	ldp fp, lr, [sp], dealloc1					//Deallocate stack memory
	ret	

printsub:
	stp fp, lr, [sp, -16]!						//Store FP and LR on stack, and allocate space for local variables
	mov fp, sp									//Update FP to current SP
    
    
	adrp x0, fmt1								//Set 1st arg (high order bits)
	add x0, x0, :lo12:fmt1						//Set 1st arg (lower 12 bits)   
	ldr x1, [x8, math_s]
	ldr x2, [x8, science_s]
	bl printf
	ldp fp, lr, [sp], 16						//Deallocate stack memory
	ret			

