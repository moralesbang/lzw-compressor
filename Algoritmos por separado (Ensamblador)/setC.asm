.data
c: 		.byte 	'l','c','k','a',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
cx: 		.byte 	'g','a','f',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.text
	
main:

	la	$a0, c
	lb	$s2, 3($a0)
	la	$a1, cx
	jal	setC
	lb	$s3, 3($a0)
	lb	$s4, 2($a1)
	j exit
	
#------------------------------------------------  clearC -------------------------------------------------------		
clearC:
	addi	$sp, $sp, -32			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$t0, 12($sp)			#guardo s2 en la pila
	sw   	$t1, 16($sp)			#guardo s2 en la pila
	sw   	$t2, 20($sp)			#guardo s2 en la pila
	sw   	$t3, 24($sp)			#guardo s2 en la pila
	sw   	$ra, 28($sp)			#guardo s2 en la pila

	addi	$s0, $a0, 0			#asigno el vector a inicializar
	jal 	lenght
	addi	$s1, $v0, 0			#asigno el tamaño del vector C
	addi	$t0, $t0, 0			# i= 0
	addi	$s2, $zero, 0x00		# valor que sera almacenado
	whileClearC:
		slti	$t1, $t0, 14		# if(i<14) 
		beq  	$t1, 0, exitWhileC
		add 	$t1, $t0, $s0		# reasigno $t1 y le llevo la variable que itera	
		sb	$s2, 0($t1)		# C[i]= null
		addi 	$t0, $t0, 1		# i+1
						
	exitWhileC:	
	lw	$ra, 28($sp)	
	lw   	$t3, 24($sp)			#guardo s2 en la pila
	lw   	$t2, 20($sp)			#guardo s2 en la pila
	lw   	$t1, 16($sp)			#guardo s2 en la pila
	lw   	$t0, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 32			#recupero los espacios reservados
	jr $ra
#------------------------------------------------ END CLEARC -------------------------------------------------------	

#------------------------------------------------ SetC ------------------------------------------------------
setC:	
	addi	$sp, $sp, -32			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$t0, 12($sp)			#guardo s2 en la pila
	sw   	$t1, 16($sp)			#guardo s2 en la pila
	sw   	$t2, 20($sp)			#guardo s2 en la pila
	sw   	$t3, 24($sp)			#guardo s2 en la pila
	sw   	$ra, 28($sp)			#guardo s2 en la pila
	
	jal	clearC
	addi	$s0, $a0, 0		#Cargo la dirección de C
	addi	$s1, $a1, 0		#Cargo la dirección de palabra a saignar
	addi	$a0, $s1, 0		#Cargo la dirección del valor a asignar y reasigno $a0 para llamar a lenght
	jal 	lenght
	addi 	$s2, $v0, 0		# len(vector) tamaño del vector a asignar
	addi 	$t0, $t0, 0		# i = 0
	whileWordToSet:
		slt	$t1, $t0, $s2		# if(i<len(diccionario)
		slti	$t2, $t0, 14		# if(i < 15)
		and 	$t3, $t1, $t2		
		beq	$t3, 0, exitWhileWordToSet
		add 	$t1, $t0, $s1		# variable con la que recorre palabra y reciclo variable t1
		lb	$t2, 0($t1)		# cargo palabra[0] y reciclo t2
		add	$t3, $t0, $s0		# variable con la que recorre C y reciclo variable t3
		sb	$t2, 0($t3)		# C[i] = palabra[i]
		addi 	$t0, $t0, 1		# i = i+1
		j whileWordToSet
		
	exitWhileWordToSet:
	
	lw	$ra, 28($sp)	
	lw   	$t3, 24($sp)			#guardo s2 en la pila
	lw   	$t2, 20($sp)			#guardo s2 en la pila
	lw   	$t1, 16($sp)			#guardo s2 en la pila
	lw   	$t0, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 32			#recupero los espacios reservados
	jr $ra
#------------------------------------------------ END SetC ------------------------------------------------------		
#-------------------- Metodo de  length-----------------------------------------------------
lenght:	
	addi	$sp, $sp, -44			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s2 en la pila
	sw   	$s4, 16($sp)			#guardo s2 en la pila
	sw   	$t0, 20($sp)			#guardo s2 en la pila
	sw   	$t1, 24($sp)			#guardo s2 en la pila
	sw   	$t2, 28($sp)			#guardo s2 en la pila
	sw   	$t3, 32($sp)			#guardo s2 en la pila
	sw   	$t4, 36($sp)			#guardo s2 en la pila
	sw   	$t5, 40($sp)			#guardo s2 en la pila
	
	
	addi 	$t0, $a0, 0			#Dirección inicial del vector ($a0)
	addi 	$t1, $zero, 0			#Contador de tamaño
LoopLen:   
	lb  	$s2,0($t0)			# Vector[i] #########################Cambiar lw por lb y disminuir a 1 la suma de i
	beqz 	$s2, outLoopLen			###################Aqui como se compara para salir????? por ahora lo estoy comparando con zero
	addi 	$t0,$t0, 1			# i=i+1
	addi 	$t1, $t1, 1			# Contador = contador +1
	j LoopLen					
outLoopLen:    
	addi 	$v0, $t1, 0
	lw   	$t5, 40($sp)			#guardo s2 en la pila
	lw   	$t4, 36($sp)			#guardo s2 en la pila
	lw   	$t3, 32($sp)			#guardo s2 en la pila
	lw   	$t2, 28($sp)			#guardo s2 en la pila
	lw   	$t1, 24($sp)			#guardo s2 en la pila
	lw   	$t0, 20($sp)			#guardo s2 en la pila
	lw   	$s4, 16($sp)			#guardo s2 en la pila
	lw   	$s3, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	
	addi	$sp, $sp, 44			#recupero los espacios reservados
	jr	$ra
#------------------- Fin Metodo Length-------------------------------------------
exit: