
/*
*	Author: Kanisqhk
*	Description: 1)Using floats, 	2) passing address from main to a subroutine
*
*	FADD D0, D1, D2	Addition
*	FMUL D0, D1, D2	Multiplication
*	FDIV D0, D1, D2	Divison
*	FABS D0, D1	Absolute Value
*	FNEG D0, D1	Flip the sign bit
*	FCVT D0, S8	SINGLE to DOUBLE
*	FCVTNS X1, D8	DOUBLE to LONG INT
*	SCVTF D0, W8	INT to FLOAT
*	FCMP D0, D1	Compare
*/


//Define register aliases
fp .req x29
lr .req x30
	
alloc = -(16+8) & -16
dealloc = -(alloc)
	
.data
init_m: .double 5.5

		
.text
fmt: 	.string "result = %f \n"

	.balign 4
	.global main
main:
	stp fp, lr, [sp, alloc]!					//Save FP and LR to stack, pre-increment sp
	mov fp, sp   

begin:
	adrp x19, init_m						// Load address of global var
	add x19, x19, :lo12: init_m
	ldr d0, [x19]						// Load value of global var
	
	add x20, fp, 16						// Calculating base address for float value
	str d0, [x20]						// storing float value on stack


	mov x0, x20						// X0 will be used as a parameter to be passed in the subroutine
	bl SUB_FLOAT

exit:	
	mov w0,0
 	ldp fp, lr, [sp], dealloc					//Restore FP and LR from stack, post-increment SP
	ret							//Return to caller




// Below is an example of sub-routine

SUB_FLOAT:
	stp fp, lr, [sp, -16]!					//Save FP and LR to stack, pre-increment sp
	mov fp, sp   

	mov x15, x0						// Reading the input arg from main
	ldr d0, [x15]						// Loading float value on stack
	ldr x0, =fmt						// Set 1st arg (high order bits)
	bl printf


 	ldp fp, lr, [sp], 16					//Restore FP and LR from stack, post-increment SP
	ret							//Return to caller
