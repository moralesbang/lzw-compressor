.data 

diccionario:	.space 2000

.text
 #-------------------------------------- Dict initialize----------------------------------------------
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)
	sw	$ra, 20($sp)

	la 	$s0, diccionario
	addi	$t0, $s0, 0		# i con el que recorro Diccionario
	addi 	$t1, $zero, 255		#punto de parada de ascci
	addi 	$t2, $zero, 1		# j =0
	loop_dict:
  		slt 	$t3, $t2, $t1
  		beqz 	$t3, continue
  		sb 	$t2, ($t0)		#guardo el asscii en la posiccion direccion.dir por j
  		addi 	$t2, $t2, 1
  		addi	$t0, $t0, 16
  		j loop_dict
 	continue:
 	
 	lw	$ra, 20($sp)
 	lw 	$t3, 16($sp)
 	lw	$t2, 12($sp)
 	lw	$t1, 8($sp)
 	lw	$t0, 4($sp)
 	lw	$s0, 0($sp)
 	
 	addi	$sp, $sp, 20
 	jr 	$ra
 #-------------------------------------- End Dict initialize ----------------------------------------------