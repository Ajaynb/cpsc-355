 //Return pointers from subroutines
 
fmt1: .string "%d <--> %d \n\n"

 //Define register aliases
fp .req x29
lr .req x30
a_size=4
b_size=4
alloc = -(16 + a_size + b_size) & -16
dealloc = - alloc
x_off = 16
y_off = 20

base_s = 16
alloc2 = -(16 + 16) & -16
dealloc2 = -alloc2
.balign 4
.global main									//Make main visible
print:
	stp fp, lr, [sp, alloc2]!					//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP
    str x19, [fp, base_s]						//Save callee-saved registers
	str x20, [fp, base_s+8]
 
//Save values of addresses for local operations
    mov x19, x0
    mov x20, x1
//Print
	adrp x0, fmt1								//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1						//Set 1st arg (lower 12 bits)   
   	ldr w1, [x19]
    ldr w2, [x20]
    
//Store values back to return to main
    bl printf
    
//Set return values
    mov x0, x19
    mov x1, x20
    
    ldr x19, [fp, base_s]						//Restore callee-saved registers
	ldr x20, [fp, base_s+8]

    ldp fp, lr, [sp], dealloc2					//Deallocate stack memory
	ret											//Return to calling code in OS

swap:
	stp fp, lr, [sp, -16]!						//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp									//Update FP to current SP

//Some operation
	ldr w9, [x0]
	ldr w10, [x1]
	//Swap
    str w9, [x1]
    str w10, [x0]	
    
    ldp fp, lr, [sp], 16					//Deallocate stack memory
	ret										//Return to calling code in OS

main: 
	stp fp, lr, [sp, alloc]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp								//Update FP to current SP
    
	mov w9, 20
	add x0, fp, x_off
	
	mov w10, 40
	add x1, fp, y_off
	
	bl print								//Print before swap
	
	add x0, fp, x_off

//Call swap subroutine	
	bl swap								//Call product subroutine

	add x0, fp, x_off
	add x1, fp, y_off

//Call print subroutine	
	bl print								//Print after swap

		
exit:
	mov w0, 0
	ldp fp, lr, [sp], dealloc				//Deallocate stack memory
	ret										//Return to calling code in OS
	
	