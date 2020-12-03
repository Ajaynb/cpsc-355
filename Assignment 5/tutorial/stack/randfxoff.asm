//This program uses rand function and stores all local variables on stack. 

size = 20							//50 elements
v_size = size*4 					//Size of all variable of array = 50*4 = 200 bytes
i_size = 4							//Size of counter i = 4
j_size = 4							//Size of counter j = 4
temp_size = 4						//Size of temp variable = 4

//Define equates for variable offsets
v_s = 16							
i_s = 16 + v_size
j_s = i_s + i_size
temp_s = j_s + j_size
 
 //Define equates for local variable size
 var_size = v_size + i_size + j_size + temp_size
 
 //Calculate memory needed for local variable
 alloc=-(16+var_size) & -16					//Makes sure the result is always a multiple of 16
 dealloc=-alloc
 
define(i_reg, w19)
define(base, x21)
define(j_reg, w20)
define(y_reg, w23)
define(x_reg, w24)
define(k_reg, w22)

 //Define register aliases
fp .req x29
lr .req x30

fmt1: .string "v[%d]: %d\n"
fmt2: .string "New Array: \n"

.balign 4
.global main							//Make main visible

main: 
	 stp fp, lr, [sp, alloc]!			//Store FP and LR on stack, and allocate space for local variables
     mov fp, sp							//Update FP to current SP
     
     mov i_reg, 0						//Initialize i to 0
     str i_reg, [fp, i_s]				//Store counter at this address
     b test1
     
top1:
		bl rand								//Call rand() function
		and j_reg, w0, 0xFF					//Mod the result with 256
		
		add base, fp, v_s					//Calculate array base address	
		ldr i_reg, [fp, i_s]				//Load current i
		str j_reg, [base, i_reg, SXTW 2]	//Store random integer into array[i]
//Print random values		
 		adrp x0, fmt1						//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt1				//Set 1st arg (lower 12 bits)    
        ldr w1, [fp, i_s]					//Arg 1 : i
        ldr w2, [base, w1, SXTW 2]			//Arg 2: array[i]
        bl printf							//Call printf
//Update i        
        ldr i_reg, [fp, i_s]			//Get current i
        add i_reg, i_reg, 1				//Increment i
        str i_reg, [fp, i_s]			//Save updated i

test1:
		cmp i_reg, size					//Loop while i<size
		b.lt top1

//Outer Loop		
		mov i_reg, 0					//Set i to 0
		str i_reg, [fp, i_s]			//Update i
	

top_outer:
        
        mov j_reg, 0						//Set j = 0
        str j_reg, [fp, j_s]				//Store current j

top_inner:									//Top of inner loop
		cmp j_reg, size						//Exit of inner loop if
		b.ge end_inner						//j>=size 
		add k_reg, j_reg, 1					//Calculate j+1
		ldr y_reg, [base, j_reg, SXTW 2]	//Get array[j]
		ldr x_reg, [base, k_reg, SXTW 2]	//Get current array[j+1]
		
//Modify values		
		add x_reg, x_reg, 10					//Exit inner loop if 
		add y_reg, y_reg, 10					//Exit inner loop if 
			
		str y_reg, [base, k_reg, SXTW 2]	 //Store new values but swap places
		str x_reg, [base, j_reg, SXTW 2]
		
	//Bottom of inner loop
test_j:
		ldr j_reg, [fp, j_s]				//Get current j
		add j_reg, j_reg, 1					//Increment j
		str j_reg, [fp, j_s]				//Save updated j
		b top_inner							//Branch to top of inner loop
		
end_inner:

//Bottom of outer loop
		ldr i_reg, [fp, i_s]					//Get current i
		add i_reg, i_reg, 1						//Increment i
		str i_reg, [fp, i_s]					//Save updated i

test_outer:		
		cmp i_reg, size							//Loop while i<size
		b.lt top_outer
		
		adrp x0, fmt2						//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt2				//Set 1st arg (lower 12 bits)   
        bl printf							//Call printf
		
//Loop for Print
mov i_reg, 0							//Initialize i to 0
str i_reg, [fp, i_s]
b test2
		
top2:

		adrp x0, fmt1					//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt1			//Set 1st arg (lower 12 bits)    
        ldr w1, [fp, i_s]				//Arg 1:i
        ldr w2, [base, w1, SXTW 2]		//Arg 2:array[i]
        bl printf						//Call printf 
        
        ldr i_reg, [fp, i_s]			//Get current i
        add i_reg, i_reg, 1				//Increment i
        str i_reg, [fp, i_s]			// Save updated i
        
test2:
		cmp i_reg, size					//Loop while i<size
		b.lt top2
		
		mov w0, 0
		ldp fp, lr, [sp], dealloc		//Deallocate stack memory
		ret								//Return to calling code in OS
	
	