.data

n: .word 9
arr: .word 9, 5, 1, 6, 7, 1, 12, 1, 3
size: .word 4
z: .word 0

.text

.globl main
    main:

    lw $t1, z  # i
    lw $s1, n     # n
    lw $s2, size  # 4
    addi $t2, $t2, -1
    la $s0, arr
    addi $t2, $s1, -1 # n-1
    loop1: beq $t2, $t1, exit1
            lw $t3, z #  j=0
            sub $t4, $t2, $t1 # n-1-i
            loop2: beq $t3, $t4, exit2 # j==n-i-1
                    mul $t9, $t3, $s2 
                    add $t8, $s0, $t9 # arr+j
                    lw $t0, ($t8) # a[j]
                    addi $t8, $t8, 4
                    lw $t9, ($t8) # a[j+1]
                    ble $t0, $t9, else
                    sw $t0, ($t8)
                    addi $t8, $t8, -4
                    sw $t9, ($t8)
                    else: addi $t3, $t3, 1
                    j loop2
            exit2: addi $t1, $t1, 1
            j loop1
    exit1: 

    lw $t1, z
    loop3: beq $t1, $s1, exit3
    mul $t2, $t1, $s2
    add $t2, $s0, $t2
    lw $t3, ($t2)

    li $v0, 1
    move $a0, $t3
    syscall

    li $a0, 32
    li $v0, 11  
    syscall


    addi $t1, $t1, 1
    j loop3
    exit3:

li $v0, 10 
syscall 
.end main
       

            
