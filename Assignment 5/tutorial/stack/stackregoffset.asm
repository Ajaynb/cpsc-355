//Using stack to store local variables, using 64 bit register offset


sfmt: .string "x>y, x = %d, y = %d  \n"               //Define string format for printf
fmt: .string "x<y, x = %d, y = %d  \n"               //Define string format for printf


//Define register aliases
fp .req x29
lr .req x30

//Define m4 macros
define(x_reg, x19)
define(y_reg, x20)

//Define main function
.global main            					//Make "main" visible to OS
.balign 4               					//Instructions must be word aligned

main:
 	    stp fp, lr, [sp, -32]!      		//Save FP and LR to stack, pre-increment sp by 32 bytes
	    mov fp, sp    
    	mov y_reg, 20						//Y = 20
	    mov x_reg, 30		   	    		//X = 30
		mov x23, 566
	    mov x22, 8							//Set offset to 8 bytes
	    
	    str x_reg, [fp]						//Store the value inside x_reg at the address stored inside fp         
		str y_reg, [fp, x22]		        //Store y_reg at current address with offset -8 bytes, [fp-8]
		add x22, x22, 8					// [fp-16]
		str x23, [fp, x22] 
		
		cmp x_reg, y_reg					//Compare the values inside x_reg and y_reg
		b.le lesser							//Branch to lesser if x<y, else continue
greater:
        adrp x0, sfmt           		    //Set 1st arg (high order bits)
        add x0, x0, :lo12:sfmt  		    //Set 1st arg (lower 12 bits)
    
        b exit								//Branch to exit

lesser:
		adrp x0, fmt               			//Set 1st arg (high order bits)
        add x0, x0, :lo12:fmt       		//Set 1st arg (lower 12 bits)
      
exit:	
		ldr x1, [fp]		      			//Load x1 with value stored at fp	  
        ldr x2, [fp, x22]					//Use offset of -8 bytes and Load x2 with value stored at fp-8
        bl printf					 		//Call printf
	    mov w0, 0                      		//Set up return value of 0 from main
   	    ldp fp, lr, [sp], 16           		//Restore FP and LR from stack, post-increment SP
        ret                            		//Return to caller
