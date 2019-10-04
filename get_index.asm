.text

jal foo

add $t0, $zero, 20

jal foo


jal foo

j exit

foo:
	addi, $t0, $t0, 1
	jr $ra

exit:	li $v0, 10	# System call for exit
	syscall
