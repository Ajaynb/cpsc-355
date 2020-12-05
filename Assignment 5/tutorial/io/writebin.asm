
buffer_s = 16
buffer_size = 8
alloc = -(16 + buffer_size) & -16
dealloc = -alloc
AT_FDCWD = -100
upper_limit = 1000

//Define register aliases
fp .req x29
lr .req x30

//Macros
define(fd_reg, w19)
define(nwritten_reg, w20)
define(buffer_base_reg, x21)
define(i_reg, x22)


			.text
path: 			.string "output.bin"								
error_open: 	.string "Error opening file:%s. Program aborted. "
error_write: 	.string "Error writing to file. Program aborted. "


	.global main				// Make "main" visible to OS
	.balign 4					// Instructions must be word aligned
main:
 	stp fp, lr, [sp, -alloc]!		// Save FP and LR to stack, pre-increment sp
	mov fp, sp   
//Create a new binary file
	mov w0, AT_FDCWD			// 1st arg (cwd)
	adrp x1, path				// 2nd arg (pathname)
	add x1, x1, :lo12: path									
	mov w2, 01 | 0100 | 01000	// 3rd arg (write-only, create if it doesnt exist, truncate existing file)
	mov w3, 0666				// 4th arg (rw for all) - specify permission
	mov x8, 56					// openat I/O request - to open a file
	svc 0						// Call system function
	mov fd_reg, w0				// Record FD
	cmp fd_reg, 0				// Check if File Descriptor = -1 (error occured)
	b.ge open_works				// If no error branch over
	
// Else print the error message
	adrp x0, error_open					// Set 1st arg (high order bits)
    add x0, x0, :lo12:error_open		// Set 1st arg (lower 12 bits)  
 	adrp x1, path						// Set 2nd arg (high order bits)
    add x1, x1, :lo12:path				// Set 2nd arg (lower 12 bits)  
	bl printf  
	mov w0, -1 				// Return -1 and exit the program
	b exit	
	
open_works:  
	add buffer_base_reg, x29, buffer_s	// Calculate base address
	ldr i_reg, =500
	b test
//Write into the text file
top:
	str i_reg, [buffer_base_reg]			// Store value on the stack - will go to file on system call
    
    mov w0, fd_reg							// 1st arg (fd)
    mov x1, buffer_base_reg					// 2nd arg (buffer)
	mov w2, buffer_size						// 3rd arg (n) - how many bytes to read from buffer each time
	mov x8, 64								// write I/O request
	svc 0									// Call system function
	
	mov nwritten_reg, w0					// Record number of bytes actually written
	cmp nwritten_reg, buffer_size			// If nwritten = buffersize
	b.eq endif								// then write succeeded 
	adrp x0, error_write					// Set 1st arg (high order bits)
    add x0, x0, :lo12:error_write			// Set 1st arg (lower 12 bits)  
	bl printf  
	b exit
endif:
	add i_reg, i_reg, 10				// i+=10
test:
	cmp i_reg, upper_limit
	b.lt top					// Branch if i<upper limit
 
end:
// Close the text file
	mov w0, fd_reg
	mov x8, 57
	svc 0
	
	mov w0, 0
exit:
	ldp fp, lr, [sp], dealloc				//Restore FP and LR from stack, post-increment SP
    ret										//Return to caller
