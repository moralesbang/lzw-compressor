.data
str:	.asciiz "312"

.text
la $s0, str

addi $t2, $zero, 0x0A # $t2 <-- 10
addi $s2, $zero, 0	# Partial value
addi $s3, $zero, 0

loop:
	lb $t0, ($s0)
	beqz $t0, exit
	andi $t0, $t0, 0x0F	# $t0 <-- current string to int
	
	mult $s2, $t2
	mflo $s2
	add $s2, $s2, $t0
	
	addi $s0, $s0, 1
	j loop
	
exit:
	li $v0, 10	# System call for exit
	syscall