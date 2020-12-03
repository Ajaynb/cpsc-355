//Using stack to store local variables using pre-increment


sfmt: .string "x>y, x = %d, y = %d  \n"		//Define string format for printf
fmt: .string "x<y, x = %d, y = %d  \n"		//Define string format for printf


//Define register aliases
fp .req x29
lr .req x30

//Define m4 macros
define(x_reg, w19)
define(y_reg, w20)

//Define main function
.global main									//Make "main" visible to OS
.balign 4										//Instructions must be word aligned

main:
	stp fp, lr, [sp, -16]!						//Save FP and LR to stack, pre-increment sp, allocate 16 bytes
	mov fp, sp
	mov y_reg, 200								//Y = 200
	mov x_reg, 80								//X = 80

	str y_reg,[fp]								//Store the value inside y_reg at the address stored inside fp, pre increment fp, allocate 4 bytes
	str x_reg, [fp, -4]!						//Store x_reg at current address in fp and preincrement, allocate 4 bytes
		
	cmp x_reg, y_reg							//Compare the values inside x_reg and y_reg
	b.le lesser									//Branch to lesser if x<y, else continue
greater:
	adrp x0, sfmt								//Set 1st arg (high order bits)
	add x0, x0, :lo12:sfmt						//Set 1st arg (lower 12 bits)

	b exit										//Branch to exit

lesser:
	adrp x0, fmt								//Set 1st arg (high order bits)
	add x0, x0, :lo12:fmt						//Set 1st arg (lower 12 bits)

exit:

	ldr w1, [fp]								//Pre-increment fp by 4 and Load x1 with value stored at fp
	ldr w2, [fp, 4]!							//Pre-increment fp by 4 and Load x2 with value stored at fp
	bl printf									//Call printf
	mov w0, 0									//Set up return value of 0 from main
	ldp fp, lr, [sp], 16						//Restore FP and LR from stack, post-increment SP
	ret											//Return to caller
