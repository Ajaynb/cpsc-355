fmt:  .string "1 + 2 + ... + 98 + 99 = %d\n"

define(x_reg, w19)
define(i_reg, w20)


size = 4+4								// 4 bytes for each integer
alloc = -(16 + size) & -16				
dealloc = -alloc

 //Define register aliases
fp .req x29
lr .req x30
                .balign 4
                .global main

main:
                stp  fp, lr, [sp, alloc]!  // Save FP and LR to the stack, alloc 8 bytes for i and sum
                mov  fp, sp                          // Update FP to the stack addr

                mov x_reg, 0							//Initialize x
                mov i_reg, 1							//Initialize counter i

                str x_reg, [fp, 16]					//Update value of x in stack
                str i_reg, [fp, 20]					//Update value of counter in stack

                b loop_test
              						
loop:
                ldr x_reg, [fp, 16]					//Load the value of x from stack

                add x_reg, x_reg, i_reg
                str x_reg, [fp, 16]					//Update value of x in stack

                add i_reg, i_reg, 1
                str i_reg, [fp, 20]					//Update value of counter in stack
                
loop_test:
                ldr i_reg, [fp, 20]					//Load the value of i from stack

                cmp i_reg, 100	
                b.lt loop

loop_exit:

                ldr x0, =fmt
                ldr w1, [fp, 16]
                bl printf

                mov w0, 0
                ldp fp, lr, [sp], dealloc
                ret
                
                
                