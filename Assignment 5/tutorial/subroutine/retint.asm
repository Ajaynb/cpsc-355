 
fmt1: .string "%d is the result \n\n"

 //Define register aliases
fp .req x29
lr .req x30

alloc = -16
dealloc = - alloc

.balign 4
.global main									//Make main visible
print:
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP
    
    mov w9, w0
	adrp x0, fmt1								//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1						//Set 1st arg (lower 12 bits)   
    mov w1, w9
    	
    bl printf
    ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS

product:
	stp fp, lr, [sp, alloc]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP

//Some operation
	mov w9, w0
	mov w10, w1 
	
	mul w11, w9, w10	
    
    //Restore values of registers from previous function
    
	mov w0, w11
	
    ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS

main: 
	stp fp, lr, [sp, alloc]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp								//Update FP to current SP
    
	mov w0, 20
	mov w1, 40
//For Product subroutine	
	bl product								//Call product subroutine

//Save returned value
	mov w19, w0								//Save returned value

//For first call of print subroutine	
	mov w0, w19								//Pass w0 to print subroutine
	bl print

//Some other operation	
	add w19, w19, 200

//For second call of print subroutine	
	mov w0, w19								//Pass w0 to print subroutine
	bl print
		
exit:
	mov w0, 0
	ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS
	
	