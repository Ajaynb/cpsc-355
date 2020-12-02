//This program uses inline subroutines. 
 
fmt1: .string "%d is the product of %d and %d\n\n"
fmt2: .string "%d is the square of %d\n\n"
fmt3: .string "\n%d is the number  from inline subroutine\n"


define(prod, `mul $3, $2, $1
	mov x28, 23
	adrp x0, fmt3						//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt3				//Set 1st arg (lower 12 bits)   
    mov x1, x28
    bl printf')
    
define(square, `mul $2, $1, $1')

 //Define register aliases
fp .req x29
lr .req x30


.balign 4
.global main							//Make main visible

main: 
	stp fp, lr, [sp, -16]!				//Store FP and LR on stack, and allocate space for local variables
    mov fp, sp							//Update FP to current SP
     
	mov x19, 8
	mov x20, 3
 	prod(x19, x20, x21)
product:
	adrp x0, fmt1						//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1				//Set 1st arg (lower 12 bits)   
    mov x1, x21
    mov x2, x20
    mov x3, x19
    bl printf
    
sqr:    
    square(x19, x20)
    adrp x0, fmt2						//Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt2				//Set 1st arg (lower 12 bits)   
    mov x1, x20
    mov x2, x19
    bl printf
exit:
	mov w0, 0
	ldp fp, lr, [sp], 16			//Deallocate stack memory
	ret								//Return to calling code in OS
	
	