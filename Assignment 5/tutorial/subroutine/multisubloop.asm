//This program uses closed subroutines. 
 
fmt1: .string "%d is the cube of %d\n\n"

 //Define register aliases
fp .req x29
lr .req x30

num = 4
size = 8



alloc = -16
dealloc = - alloc

.balign 4
.global main								//Make main visible

main: 
	stp fp, lr, [sp, alloc]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp								//Update FP to current SP
    mov x28, 1

calcube:  
	mov x0, x28   
	bl cube
	add x28, x28, 1
	cmp x28, 20
	b.le calcube
	
exit:
	mov w0, 0
	ldp fp, lr, [sp], dealloc					//Deallocate stack memory
	ret											//Return to calling code in OS
	
										
cube:
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp	
//Save number
    mov x10, x0
    
//Calculate cube						
    mul x9, x10, x10
    mul x9, x9, x10
    mov x0, x9									//Set 1st arg as the cube
    mov x1, x10									//Set 2nd arg as number
    bl printsub

    ldp fp, lr, [sp], dealloc					//Deallocate stack memory
	ret											//Update FP to current SP

printsub:
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP
    
    mov x10, x0
    mov x11, x1
	adrp x0, fmt1						//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1				//Set 1st arg (lower 12 bits)   
    mov x1, x10
    mov x2, x11	
    bl printf
    ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret		
	