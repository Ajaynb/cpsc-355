//Create an array, and calculate sum of all elements

size = 10						//10 elements
v_size = size*4 					//Size of all variable of array = 10*4 = 10 bytes
i_size = 4						//Size of counter i = 4
sum_size = 4

//Define equates for variable offsets
v_s = 16							
i_s = 16 + v_size
sum_s = i_s +i_size

 //Define equates for local variable size
 var_size = v_size + i_size + sum_size
 
 //Calculate memory needed for local variable
 alloc=-(16+var_size) & -16
 dealloc=-alloc
 
 define(i_reg, w19)
 define(j_reg, w20)
 define(base, x21)
 define(sum, w25)
 //Define register aliases

fmt1: .string "v[%d]: %d\n"
fmt2: .string "Sum of array = %d \n"

.balign 4
.global main							//Make main visible

main: 
	 stp fp, lr, [sp, alloc]!			//Store FP and LR on stack, and allocate space for local variables
     mov fp, sp						//Update FP to current SP
     
     mov i_reg,0					//Initialize i to 0
     str i_reg, [fp, i_s]				//Store counter at this address
     b test1
     
top1:
		bl rand					//Call rand() function
		and j_reg, w0, 0xFF			//Mod the result with 255
		
		add base, fp, v_s			//Calculate array base address	
		ldr i_reg, [fp, i_s]			//Load current i
		str j_reg, [base, i_reg, SXTW 2]	//Store random integer into array[i], Offset = sxtw w1 with lsl by 2 
		
 	adrp x0, fmt1				//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt1			//Set 1st arg (lower 12 bits)    
        ldr w1, [fp, i_s]			//Arg 1 : i
        add base, fp, 16			//Calculate array base address
        ldr w2, [base, w1, SXTW 2]		//Arg 2: v[i]
        bl printf				//Call printf
        
        ldr i_reg, [fp, i_s]			//Get current i
        add i_reg, i_reg, 1			//Increment i
        str i_reg, [fp, i_s]			//Save updated i
		
test1:
		cmp i_reg, size			//Loop while i<size
		b.lt top1
		
        mov sum, 0
        str sum, [fp, sum_s]		
	mov i_reg, 0				//Initialize i to 0
     	str i_reg, [fp, i_s]			//Store counter at this address
     	
sum:        
        ldr i_reg, [fp, i_s]			//Get current i
	ldr w26, [base, i_reg, SXTW 2]		//Get value at index i
	ldr sum, [fp, sum_s]			//Get current sum

	add sum, sum, w26
	str sum, [fp, sum_s]
	    
  
	ldr i_reg, [fp, i_s]			//Get current i
        add i_reg, i_reg, 1			//Increment i
        str i_reg, [fp, i_s]			//Save updated i
		
testt:
		cmp i_reg, size			//Loop while i<size
		b.lt sum
		
	adrp x0, fmt2				//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt2			//Set 1st arg (lower 12 bits)    
        ldr w1, [fp, sum_s]			//Arg 1 : sum		
	bl printf    
		
		
	mov w0, 0
	ldp fp, lr, [sp], dealloc		//Deallocate stack memory
	ret					//Return to calling code in OS
	
