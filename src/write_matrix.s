.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

      # Prologue

    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw a2, 24(sp)
    sw a3, 28(sp)
    
    mv s1, a1
    addi s2, sp, 24
    addi s3, sp, 28
    
    li a1, 1
    jal ra, fopen
    blt a0, zero, foerr
    mv s0, a0
    mv a1, s2
    li a2, 1
    li a3, 4
    jal ra, fwrite
    li a2, 1
    bne a0, a2, fwerr
    mv a0 ,s0
    mv a1, s3
    li a2, 1
    li a3, 4
    jal ra, fwrite
    li a2, 1
    bne a0, a2, fwerr
    mv a0, s0
    mv a1, s1
    lw t0, 0(s2)
    lw t1, 0(s3)
    mul a2, t1, t0
    mv s4, a2
    li a3, 4
    jal ra, fwrite
    mv a2, s4
    bne a0, a2, fwerr
    j end

foerr:
    li a0, 27
    j exit

fwerr:
    li a0, 30
    j exit

fcerr:
    li a0, 28
    j exit

    # Epilogue
end:

    mv a0, s0
    jal ra, fclose
    blt a0, zero, fcerr


    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 32

    jr ra