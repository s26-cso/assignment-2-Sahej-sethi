.data
fmt: .string "%d "

.text
.global main

main:
    addi sp, sp, -64
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)
    sd s5, 48(sp)
    sd s6, 56(sp)

    mv s6, a0 # number of arguments
    addi s4, s6, -1 # s4 = n

    mv s0, a1 # s0 = argv array

    slli a0, s4, 2 # a0 = 4*n
    call malloc

    # now a0 has an integer array of size n
    mv s1, a0 # s1 = int array

    # iterating argv ie s0
        li s5, 1 # skip ./a.out 

        loop_start:
            bge s5, s6, loop_exit

            slli t3, s5, 3 # t3 = 8*s5
            add t3, s0, t3
            ld a0, 0(t3) # a0 = argv[i]

            call atoi

            addi t3, s5, -1
            slli t4, t3, 2
            add t4, s1, t4
            sw a0, 0(t4)

            addi s5, s5, +1
            beq x0, x0, loop_start

        loop_exit:

    

   slli a0, s4, 2
   call malloc

   mv s2, a0 # s1 now has stack

   slli a0, s4, 2
   call malloc

   mv s3, a0 # s3 now has ans array

   li t0, -1 # top

    #Assigning all elements of ans to -1
   li t2, 0
   start_loop:
    bge t2, s4, exit_loop

    slli t3, t2, 2
    add t3, s3, t3
    li t4, -1
    sw t4, 0(t3)

    addi t2, t2, 1
    beq x0,x0, start_loop

   exit_loop:

   addi t2, s4, -1

   s_loop:

        blt t2, x0, e_loop 

        li t3, -1
        ss_loop:

            beq t0, t3, ee_loop

            # finding a[i]
            slli t4, t2, 2
            add t4, s1, t4
            lw t4, 0(t4)
            # finding st[top]
            slli t5, t0, 2
            add t5, s2, t5
            lw t5, 0(t5)
            #finding a[st[top]]
            slli t6, t5, 2
            add t6, s1, t6
            lw t6, 0(t6)

            blt t4, t6, ee_loop

            # inside loop
            addi t0, t0, -1
            beq x0, x0, ss_loop

        ee_loop:

        beq t0, t3, if_skip

        # finding ans[i]
        slli t4, t2, 2
        add t4, s3, t4

        # finding st[top]
        slli t5, t0, 2
        add t5, s2, t5
        lw t5, 0(t5)

        sw t5, 0(t4)

        if_skip:
        addi t0, t0, +1
        slli t5, t0, 2
        add t5, s2, t5
        sw t2, 0(t5)

        addi t2, t2, -1
        beq x0, x0, s_loop
    
    e_loop:

    # printing the op
    li s5, 0
    print_loop:

        bge s5, s4, end_print

        # finding ans[i]
        slli t1, s5, 2
        add t1, s3, t1
        lw a1, 0(t1)
        
        la a0, fmt
        call printf

        addi s5, s5, 1
        beq x0, x0, print_loop
    
    end_print:

    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 64

    ret















