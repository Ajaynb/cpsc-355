buffer_s = 16
buffer_size = 8
alloc = -(16 + buffer_size) & -16
dealloc = -alloc
AT_FDCWD = -100

//Define register aliases
fp .req x29
lr .req x30

//Macros
define(fd_reg, w19)
define(nread_reg, w20)
define(buffer_base_reg, x21)

			.text
path: 		.string "output.bin"
error_msg: 	.string "Error opening file:%s. Program aborted. "
fmt1: 		.string "long int %ld \n"

	.global main								// Make "main" visible to OS
	.balign 4									// Instructions must be word aligned
main:
 	stp fp, lr, [sp, alloc]!					// Save FP and LR to stack, pre-increment sp
	mov fp, sp
//Open the binary file
	mov w0, AT_FDCWD							// 1st arg (cwd)
	adrp x1, path								// 2nd arg (pathname)
	add x1, x1, :lo12: path
	mov w2, 0									// 3rd arg (read-only)
	mov w3, 0									// 4th arg (not used)
	mov x8, 56									// openat I/O request - to open a file
	svc 0												// Call system function
	mov fd_reg, w0										// Record FD
	cmp fd_reg, 0										// Check if File Descriptor = -1 (error occured)
	b.ge open_works										// If no error branch over

// Else print the error message
	adrp x0, error_msg						// Set 1st arg (high order bits)
 	add x0, x0, :lo12:error_msg				// Set 1st arg (lower 12 bits)
 	adrp x1, path							// Set 2nd arg (high order bits)
  	add x1, x1, :lo12:path					// Set 2nd arg (lower 12 bits)
	bl printf
	mov w0, -1 								// Return -1 and exit the program
	b exit

open_works:
	add buffer_base_reg, x29, buffer_s		// Calculate base address
//Read the binary file
top:
    mov w0, fd_reg							// 1st arg (fd)
    mov x1, buffer_base_reg					// 2nd arg (buffer)
	mov w2, buffer_size						// 3rd arg (n) - how many bytes to read from buffer each time
	mov x8, 63								// read I/O request
	svc 0									// Call system function

	mov nread_reg, w0						// Record number of bytes actually read
	cmp nread_reg, buffer_size				// If nread != buffersize
	b.ne end								// then read failed, so exit loop
//Print the long ints
	adrp x0, fmt1							// Set 1st arg (high order bits)
    add x0, x0, :lo12:fmt1					// Set 1st arg (lower 12 bits)
    ldr x1, [buffer_base_reg] 				// 2nd arg (load string from buffer)

	bl printf
	b top
end:
// Close the text file
	mov w0, fd_reg
	mov x8, 57
	svc 0

	mov w0, 0
exit:
	ldp fp, lr, [sp], dealloc				//Restore FP and LR from stack, post-increment SP
    ret														//Return to caller
