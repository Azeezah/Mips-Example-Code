.data
	numbers: .byte 1 2 3 4 5
	sum_header: .asciiz "array sum: "

.text

main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 4	#print sum_header
	la $a0, sum_header
	syscall

	la $a0, numbers	#get arr addr
	li $a1, 5	#get arr length
	addi $sp, $sp, -8	#allocate space for parameters
	sw $a0, 0($sp)		#store parameters
	sw $a1, 4($sp)
	jal sum
	lw $t0, 0($sp)
	addi $sp, $sp, 4

	li $v0, 1	#now print it
	move $a0, $t0
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


sum:		#function args: $t1 = array_addr, $t2 = array_len
	lw $a0, 0($sp)
	lw $a1, 4($sp)		
	addi $sp, $sp, 8	#deallocate space for parameters

	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	lb $s0, 0($a0)  #s0 is used to store the first number from the array
	li $t0, 1
	bne $a1, $t0, dont_return_first		#base case: return first_number if len==1
	move $v0, $s0
	j return
dont_return_first:

	addi $a0, $a0, 1	#increment addr, effectively removing first element from array
	addi $a1, $a1, -1	#decrement length accordingly
	addi $sp, $sp, -8	#allocate space for parameters
	sw $a0, 0($sp)		#store parameters
	sw $a1, 4($sp)
	jal sum
	lw $v0, 0($sp)		#retrieve the return value from the stack
	addi $sp, $sp, 4	#deallocate the space for the returned value

	add $v0, $s0, $v0	#return first number + sum of the rest
return:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	
	addi $sp, $sp, -4	#allocate space for the return value
	sw $v0, 0($sp)		#put the return value on the stack
	jr $ra

