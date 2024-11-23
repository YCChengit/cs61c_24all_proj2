.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue

    addi sp, sp, -4
    sw s1, 0(sp)

    addi s1, a0, 0
    lw t0, 0(s1)
    addi a0, zero, 0
    addi t1 zero, 1
    blt zero, a1, loop_start
    li a0, 36
    j exit 

loop_start:
    beq t1, a1, loop_end
    addi s1, s1, 4
    lw t2, 0(s1)
    bge t0, t2, loop_continue
    add t0, t2,zero
    add a0, t1,zero
    addi t1, t1, 1
    j loop_start

loop_continue:
    addi t1, t1, 1
    j loop_start

loop_end:
    # Epilogue
    lw s1, 0(sp)
    addi sp, sp, 4

    jr ra
