.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    addi t0, a0, -5
    bne t0, zero, argerr

    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Read pretrained m0
    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s3, a0
    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s4, a0
    mv a1, s3
    mv a2, s4
    lw t0, 4(s1)
    addi a0, t0, 0
    jal ra, read_matrix
    mv s5, a0

    # Read pretrained m1

    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s6, a0
    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s7, a0
    mv a1, s6
    mv a2, s7
    lw t0, 8(s1)
    addi a0, t0, 0
    jal ra, read_matrix
    mv s8, a0

    # Read input matrix

    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s9, a0
    li a0, 4
    jal ra, malloc
    beq a0, zero, maerr
    mv s10, a0
    mv a1, s9
    mv a2, s10
    lw t0, 12(s1)
    addi a0, t0, 0
    jal ra, read_matrix
    mv s11, a0

    # Compute h = matmul(m0, input)

    lw t0, 0(s3)
    lw t1, 0(s10)
    mul t0, t0, t1
    addi sp, sp -4
    sw t0, 0(sp)
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    beq a0, zero, maerr
    mv a6, a0
    addi sp, sp ,-4
    sw a0, 0(sp)

    mv a0, s5
    lw a1, 0(s3)
    lw a2, 0(s4)
    mv a3, s11
    lw a4, 0(s9)
    lw a5, 0(s10)

    jal ra, matmul

    # Compute h = relu(h)
    lw a0, 0(sp)
    lw a1, 4(sp)
    jal ra, relu

    # Compute o = matmul(m1, h)

    lw t0, 0(s6)
    lw t1, 0(s10)
    mul t0, t0, t1
    addi sp, sp, -4
    sw t0,  0(sp)
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    beq a0, zero, maerr
    mv a6, a0
    addi sp, sp, -4
    sw a0, 0(sp)

    mv a0, s8
    lw a1, 0(s6)
    lw a2, 0(s7)
    lw a3, 8(sp)
    lw a4, 0(s3)
    lw a5, 0(s10)

    jal ra, matmul

    # Write output matrix o

    lw a2, 0(s6)
    lw a3, 0(s10)
    lw a1, 0(sp)
    lw a0, 16(s1)

    jal ra, write_matrix

    # Compute and return argmax(o)

    lw a0, 0(sp)
    lw a1, 4(sp)

    jal ra, argmax
    mv s0, a0

    # If enabled, print argmax(o) and newline

    bne s2, zero, end
    jal ra, print_int
    li a0 '\n'
    jal ra, print_char

end:
    
    mv a0, s3
    jal ra, free
    mv a0, s4
    jal ra, free
    mv a0, s5
    jal ra, free
    mv a0, s6
    jal ra, free
    mv a0, s7
    jal ra, free
    mv a0, s8
    jal ra, free
    mv a0, s9
    jal ra, free
    mv a0, s10
    jal ra, free
    mv a0, s11
    jal ra, free
    lw a0, 0(sp)
    jal ra, free
    addi sp, sp, 8
    lw a0, 0(sp)
    jal ra, free
    addi sp, sp, 8
    
    mv a0, s0

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    jr ra

maerr:
    li a0, 26
    j exit

argerr:
    li a0, 31
    j exit