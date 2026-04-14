.text
.global make_node
.global get
.global insert
.global getAtMost
.equ node_val, 0
.equ node_left, 8 # due to struct padding
.equ node_right, 16
.equ node_size, 24 

make_node:
    # saving return address and saved registers which will be used
    addi sp, sp, -16 # rounding off to nearest multiple of 16, sp+0, sp+4 unused
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0 # storing the value of the node to be created before malloc call

    li a0, node_size
    call malloc

    # malloc fail check
    beq zero, a0, done_make_node
    # now a0 is pointer to memory allocated

    # assigning value
    sw s0, node_val(a0)
    sd zero, node_left(a0)
    sd zero, node_right(a0)

    # restoring the values
    done_make_node:
    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

get:

    loop_start:

        beq a0, zero, loop_end

        lw t0, node_val(a0)

        beq a1, t0, value_match
        blt a1, t0, if_part

        # Else part 
        ld a0, node_right(a0)
        beq x0, x0, loop_start
    if_part:
        ld a0, node_left(a0)
        beq x0, x0, loop_start      
    
    value_match:
        ret # whatever is the current its in a0 already
    
    loop_end:
        mv a0, zero
        ret

insert:
    # Saving the return address
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    
    mv s0, a0 # s0 has root pointer
    mv s1, a1 # s1 has int val

    mv a0, s1 # a0 has int val
    jal make_node
    # a0 now has temp pointer

    beq s0, zero, insert_done # if root == NULL

    mv t0, s0
    mv t1, zero

    start_loop:

        beq t0, zero, exit_loop
        mv t1, t0
        lw t2, node_val(t0)
        blt s1, t2, if_true

        # else_case
        ld t0, node_right(t0)
        beq x0, x0, start_loop

        if_true:

            ld t0, node_left(t0)
            beq x0, x0, start_loop
    
    exit_loop:

        lw t2, node_val(t1)
        blt s1, t2, if2_true

        # else_case
        sd a0, node_right(t1)
        mv a0, s0
        beq x0, x0, insert_done

        if2_true:
        sd a0, node_left(t1)
        mv a0, s0
        beq x0, x0, insert_done

    insert_done:

        ld s1, 16(sp)
        ld s0, 8(sp)
        ld ra, 0(sp)
        addi sp, sp, 32
        ret


getAtMost:
    # a0 is int val, a1 is root
    mv t0, zero

    loop_start1:

        beq a1, zero, end_loop

        lw t1, node_val(a1)
        bne t1, a0, not_if
        ret

        not_if:
            blt a0, t1, if_true_getAtMost
            mv t0, a1
            ld a1, node_right(a1)
            beq x0, x0, loop_start1

            if_true_getAtMost:
            ld a1, node_left(a1)
            beq x0, x0, loop_start1

    end_loop:

    beq t0, zero, not_found
    lw t0, node_val(t0)
    mv a0, t0
    ret
    
    not_found:
    li a0, -1
    ret
            


