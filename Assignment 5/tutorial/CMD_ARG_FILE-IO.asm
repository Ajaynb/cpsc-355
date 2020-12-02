
//Define register aliases
fp .req x29
lr .req x30

//FOR FILE I/O
buffer_s = 16
buffer_size = 4
alloc = -(16 + buffer_size) & -16
dealloc = -alloc
AT_FDCWD = -100

//Macros for reading cmd line args
define(i_r, w19) 				// index, will be used to iterate through the array 
define(argc_r, w20) 				// argc: the number of arguments passed from command line
define(argv_r, x21)				// argv[]: an array of pointers to the arguments (represented as strings)


//Macros for reading a .bin file
define(file_r, x15)
define(fd_reg, w22)
define(nread_reg, w23)
define(buffer_base_reg, x24)


.text
fmt: 	.string "%s\n"
error_msg: 	.string "Error opening file:%s. Program aborted. "
fmt1: 		.string "Value: %d \n"

	.balign 4
	.global main

main:
	stp fp, lr, [sp, -16]!			// Save FP and LR to stack, pre-increment sp
	mov fp, sp   
	
//Load arguments passed from shell
	mov argc_r, w0 				// Move value from x0 to argv_r - immediate value
	mov argv_r, x1				// Move value from x1 to argv_r - address
	mov i_r, 1 				// initializing index variable with 1 (ignoring the index 0)
	b test

top:    
	ldr x1, [argv_r, i_r, SXTW 3]		// Set up 2nd arg 
	ldr x0, =fmt
	bl printf				// Call printf 

	add i_r, i_r, 1				// i++

test:
 	cmp i_r, argc_r
	b.lt top					// Loop while i < argc

	mov i_r, 3
	ldr x0, [argv_r, i_r, SXTW 3]
	bl READ_FILE


exit:
 	ldp fp, lr, [sp], 16			// Restore FP and LR from stack, post-increment SP
    	ret					// Return to caller


READ_FILE:
	stp fp, lr, [sp, alloc]!			// Save FP and LR to stack, pre-increment sp
	mov fp, sp   

	mov file_r, x0

	//Open the binary file
	mov w0, AT_FDCWD								// 1st arg (cwd)
	mov x1, file_r								// 2nd arg (pathname)	
	mov w2, 0								// 3rd arg (read-only)
	mov w3, 0								// 4th arg (not used)
	mov x8, 56								// openat I/O request - to open a file
	svc 0									// Call system function
	mov fd_reg, w0								// Record FD
	cmp fd_reg, 0								// Check if File Descriptor = -1 (error occured)
	b.ge open_works								// If no error branch over

	// Else print the error message
	adrp x0, error_msg							// Set 1st arg (high order bits)
 	add x0, x0, :lo12:error_msg						// Set 1st arg (lower 12 bits)
 	mov x1, file_r
	bl printf
	mov w0, -1 								// Return -1 and exit the program
	b exit_sub

open_works:
	add buffer_base_reg, x29, buffer_s					// Calculate base address

//Read the binary file
read_begin:
    	mov w0, fd_reg								// 1st arg (fd)
    	mov x1, buffer_base_reg							// 2nd arg (buffer)
	mov w2, buffer_size							// 3rd arg (n) - how many bytes to read from buffer each time
	mov x8, 63								// read I/O request
	svc 0									// Call system function


	mov nread_reg, w0							// Record number of bytes actually read
	cmp nread_reg, buffer_size						// If nread != buffersize
	b.ne end									// then read failed, so exit loop

//Print the ints
	adrp x0, fmt1								// Set 1st arg (high order bits)
    	add x0, x0, :lo12:fmt1							// Set 1st arg (lower 12 bits)
   	ldr x1, [buffer_base_reg] 						// 2nd arg (load string from buffer)

	bl printf
	b read_begin

end:
// Close the text file
	mov w0, fd_reg
	mov x8, 57
	svc 0

	mov w0, 0
exit_sub:
	ldp fp, lr, [sp], dealloc			// Restore FP and LR from stack, post-increment SP
    	ret


