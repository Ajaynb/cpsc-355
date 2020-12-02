//This program uses inline subroutines. 
 
fmt1: .string "%d is the product of %d and %d\n\n"

 //Define register aliases
fp .req x29
lr .req x30

alloc = -16
dealloc = - alloc

.balign 4
.global main							//Make main visible

main: 
	stp fp, lr, [sp, alloc]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp							//Update FP to current SP
     
	mov x0, 99
	mov x1, 4
	bl product
exit:
	mov w0, 0
	ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS
	
	
product:
	stp fp, lr, [sp, alloc]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp								//Update FP to current SP
	mov x9, x0
	mov x10, x1
    mul x11, x10, x9
	
	print:
		adrp x0, fmt1						//Set 1st arg (high order bits)
    	add x0, x0, :lo12:fmt1				//Set 1st arg (lower 12 bits)   
    	mov x1, x11
    	mov x2, x10
    	mov x3, x9
    	
    	bl printf
   
    ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS
	

