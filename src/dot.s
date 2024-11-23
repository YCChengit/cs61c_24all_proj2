.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    bge x0, a2, end1 
    bge  x0, a3, end2 
    bge  x0, a4, end2 
    addi t0, x0, 0
    addi t3, x0, 4
    mul a3, a3, t3
    mul a4, a4, t3
    addi t3, x0, 0
    j loop_start

end1:
    li a0, 36
    j exit 

end2:
    li a0, 37
    j exit


loop_start:
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t1, t1, t2
    add t0, t0, t1
    addi t3, t3, 1
    beq t3, a2, loop_end
    add a0, a0, a3
    add a1, a1, a4
    j loop_start


loop_end:


    # Epilogue
    add a0, t0, x0

    jr ra
