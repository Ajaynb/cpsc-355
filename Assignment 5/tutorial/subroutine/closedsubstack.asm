 
fmt1: .string "%d is the product of %d and %d\n\n"
fmt2: .string "New values: %d; %d; %d\n\n"

 //Define register aliases
fp .req x29
lr .req x30
size = 8


define(offset, w28)
define(base, x23)

pralloc = -(16+16) & -16
prdealloc = -pralloc

alloc = -16
dealloc = - alloc

.balign 4
.global main									//Make main visible

main: 
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP
     
	mov w19, 20
	mov w20, 40
	mov w0, w19									//Set the 1st argument
	mov w1, w20									//Set the 2nd argument
	bl product									// Call product
	mov w21, w0								//Save the passed argument
print2:
		adrp x0, fmt2						//Set 1st arg (high order bits)
    	add x0, x0, :lo12:fmt2				//Set 1st arg (lower 12 bits)   
    	mov w1, w19
    	mov w2, w20
    	mov w3, w21	
    	bl printf

exit:
	mov w0, 0
	ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS
	
product:
	stp fp, lr, [sp, pralloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP
    str x19, [fp, 16]
	str x20, [fp, 16 + size]
	
    mov w19, w0
    mov w20, w1

	mov w3, w19								//Set arg for print
	mov w2, w20								//Set arg for print

//Some operation

	mul w19, w19, w20	
	
print:
	adrp x0, fmt1						//Set 1st arg (high order bits)
	add x0, x0, :lo12:fmt1				//Set 1st arg (lower 12 bits)   
    mov w1, w19
	bl printf
    
    
    //Restore values of registers from previous function
	mov w0, w19								//Set product as an return value

	ldr x19, [fp, 16]
	ldr x20, [fp, 16+ size]    
	
    ldp fp, lr, [sp], prdealloc				//Deallocate stack memory
	ret										//Return to calling code in OS

	
