.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bge zero, a1, error
    bge zero, a2, error
    bge zero, a4, error
    bge zero, a5, error
    blt a2, a4, error
    j start

error:
    li a0, 38
    j exit    

start:
    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)

    add s2, zero, a0
    add s3, zero, a3
    add s4, zero, a2
    add s5, zero, a1
    add s6, zero, a5
    add s7, zero, a6
    addi t0, zero, 0
    j outer_loop_start

outer_loop_start:
    mul t2, t0, s4
    slli t2, t2, 2
    add a0, s2, t2
    addi t1, zero, 0
    j inner_loop_start

inner_loop_start:

    slli t2, t1, 2
    add a1, s3, t2
    mv a2, s4
    li a3, 1
    mv a4, s6

    #Prologue
    addi sp, sp, -12
    sw, t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)

    jal ra, dot

    # Epilogue
    lw, t0, 0(sp)
    lw t1, 4(sp)

    mul t2, t0, s6
    slli t2, t2, 2
    slli t3, t1, 2
    add t4, t2, t3
    add t2, t4, s7
    sw a0, 0(t2)
    lw a0, 8(sp)
    addi sp, sp, 12
    addi t1, t1, 1
    beq t1, s6, inner_loop_end
    j inner_loop_start


inner_loop_end:

    addi t0, t0, 1
    beq t0, s5, outer_loop_end
    j outer_loop_start


outer_loop_end:

    # Epilogue

    lw ra, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    addi sp, sp, 28

    jr ra
