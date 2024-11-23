.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s1 0(sp)
    sw s2 4(sp)


    addi s1, zero, 0
    addi s2, a0, 0
    addi t0, zero, 0
    blt zero, a1, loop_start
    li a0, 36
    j exit 

loop_start:
    add a0, s2, t0
    lw t1, 0(a0)
    blt zero, t1, loop_continue
    sw zero, 0(a0)
    addi t0, t0, 4
    addi s1, s1, 1 
    beq s1, a1, loop_end
    j loop_start

loop_continue:
    addi t0, t0, 4
    addi s1, s1, 1
    beq s1, a1, loop_end
    j loop_start


loop_end:


    # Epilogue
    lw s1, 0(sp)
    lw s2 4(sp)
    addi sp, sp, 8

    jr ra
