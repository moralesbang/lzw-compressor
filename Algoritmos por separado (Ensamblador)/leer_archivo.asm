.data 
c:	.byte	10
output:	.space 20

.text
	la	$s0, c
	lb	$a0, 0($s0)
	la	$a1, output
	jal	travelOut
	
	li 	$v0, 4
	la	$a0, output
	syscall
	j exit

travelOut:
	addi	$sp, $sp, -16
	sw 	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$t0, 8($sp)
	sw	$ra, 12($sp)
	
	addi	$s0, $a0, 0		#Index a concatenar
	addi	$t0, $a1, 0		#direccion donde voy a concatenar del vector output
	addi	$s1, $zero, 0	#asigno un espacio
	
	sb	$s0, 0($t0)		#Guardo en output el index 
	addi	$t0, $t0, 1		#direccion + 1
	sb 	$s1, 0($t0)		#Guardo en output el espacio para separar
	addi	$v0, $t0, 1		#retorno la dirección + 1 para poder seguir derecho 
	
	lw	$ra, 12($sp)
	lw	$t0, 8($sp)
	lw	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi	$sp, $sp, 16
	jr $ra
	
exit:
	