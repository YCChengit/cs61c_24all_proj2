.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue

    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    mv s1, a1
    mv s2, a2
    
    li a1, 0
    jal ra, fopen
    blt a0, zero, foerr
    mv s0, a0
    mv a1, s1
    li a2, 4
    jal ra, fread
    li a2, 4
    bne a0, a2, frerr
    mv a0 ,s0
    mv a1, s2
    li a2, 4
    jal ra, fread
    li a2, 4
    bne a0, a2, frerr
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t1, t1, t2
    slli t1, t1, 2
    mv s4, t1
    mv a0, s4
    jal ra, malloc
    beq a0, zero, maerr
    mv s5, a0
    mv a0, s0
    mv a1, s5
    mv a2, s4
    jal ra, fread
    mv a2, s4
    bne a0, a2, frerr
    mv a0, s5
    j end

foerr:
    li a0, 27
    j exit

frerr:
    li a0, 29
    j exit

fcerr:
    li a0, 28
    j exit

maerr:
    li a0,26
    j, exit

    # Epilogue
end:

    mv a0, s0
    jal ra, fclose
    blt a0, zero, fcerr
    mv a0, s5

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    jr ra
