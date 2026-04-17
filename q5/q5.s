.data
filename: .string "input.txt"
mode: .string "rb"
yes: .string "Yes\n"
no: .string "No\n"

.text
.global main

main:
    addi sp, sp, -48
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)

    # Opening the file
    la a0, filename
    la a1, mode
    call fopen
    # now a0 contains fp
    mv s0, a0 # now so has fp
    li a1, 0
    li a2, 2
    call fseek # returns fseek(file,offset ie index, start from where) 0-> start, 1-> current, 2-> end

    mv a0, s0
    call ftell # returns the index
    mv s1, a0 # s1 has value length 

    li s2, 0 # left pointer
    addi s3, s1, -1 # right pointer

    start_loop:

        bge s2, s3, end_loop

        # Reading the left character
        mv a0, s0
        mv a1, s2
        li a2, 0
        call fseek
        # fetching left character
        mv a0, s0
        call fgetc
        mv s4, a0

        # Reading the Right character
        mv a0, s0
        mv a1, s3
        li a2, 0
        call fseek
        # fetching the left character
        mv a0, s0
        call fgetc
        mv t0, a0

        bne t0, s4, no_exit
        
        addi s2, s2, 1
        addi s3, s3, -1
        beq x0, x0, start_loop
    
    end_loop:

    la a0, yes
    call printf

    beq x0, x0, exit_main

    no_exit:

    la a0, no
    call printf

    exit_main:

    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    addi sp, sp, 48
    ret








