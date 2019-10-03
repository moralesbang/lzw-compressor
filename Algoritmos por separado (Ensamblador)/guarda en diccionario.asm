.data 
diccionario:	.byte	'g','h',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,'g','s','a',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
c: 		.byte 	'z','a','b','k',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.text
	la 	$s0, diccionario
	la 	$s1, c
	addi 	$a0, $s0, 0		#asigno al parametro el diccionario
	addi 	$a1, $s1, 0		#asigno al parametro el vector C	
	jal 	storeInDic
	lb 	$t4, 16($s0)
	j exit

#----------------------------------- StoreInDic:	(Diccionario.dir, Aux.dir) ------------------------------------
storeInDic:
	addi	$sp, $sp, -36			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s2 en la pila
	sw   	$t0, 16($sp)			#guardo s2 en la pila
	sw   	$t1, 20($sp)			#guardo s2 en la pila
	sw   	$t2, 24($sp)			#guardo s2 en la pila
	sw   	$t3, 28($sp)			#guardo s2 en la pila
	sw	$t4, 32($sp)
	sw	$ra, 36($sp)
	
	addi	$s0, $a0, 0			#almaceno la direccion del diccionario
	addi	$s1, $a1, 0			#almaceno la direccion del auxiliar
	addi	$a0, $s1, 0			# preparo el parametro para lenght de auxiliar
	jal lenght
	addi	$t0, $v0, 0			#Tamaño del vector aux
	addi 	$t1, $s0, 0			#i = 0
	lb	$t2, 0($t1)			#diccionario[0] 
	whileStoreInDic:
		beqz	$t2, exitWhileStoreInDic # while(diccinario[i]!= null)
		addi	$t1, $t1, 16		#i = i +16
		lb	$t2, 0($t1)		#diccionario[i] 
		j whileStoreInDic
	exitWhileStoreInDic:
	addi	$t2, $zero, 0			# J = 0
	whileStoreInEmpty: 
		slt	$t3, $t2, $t0		#If(j<len(aux))
		slti	$t4, $t2, 15		#if(j<15)
		and	$t4, $t4, $t3		
		beq	$t4, 0, exitWhileStoreInEmpty
		add	$t4, $t2, $s1		# variable a recorrer aux
		lb 	$t3, 0($t4)		# aux[i]
		sb	$t3, 0($t1)		# diccionario[i] = aux[i]
		addi	$t1, $t1, 1		#i = i +1
		addi	$t2, $t2, 1
		j whileStoreInEmpty
	exitWhileStoreInEmpty:	
	
	
	lw	$ra, 36($sp)
	lw	$t4, 32($sp)	
	lw   	$t3, 28($sp)			#guardo s2 en la pila
	lw   	$t2, 24($sp)			#guardo s2 en la pila
	lw   	$t1, 20($sp)			#guardo s2 en la pila
	lw	$t0, 16($sp)			#guardo ra em la pila
	lw   	$s3, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 40			#recupero los espacios reservados
	jr	$ra

#----------------------------------- End StoreInDic------------------------------------
#-----------------------------------storeInC: (Diccionario.dir, C.dir) -----------------------------------------	
storeInC:
	addi	$sp, $sp, -36			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s2 en la pila
	sw   	$t0, 16($sp)			#guardo s2 en la pila
	sw   	$t1, 20($sp)			#guardo s2 en la pila
	sw   	$t2, 24($sp)			#guardo s2 en la pila
	sw   	$t3, 28($sp)			#guardo s2 en la pila
	sw	$ra, 32($sp)
	
	
	addi 	$s0, $a0, 0			#Direcciï¿½n del diccionario[i]
	jal	lenght
	addi	$s1, $v0, 0			#tamaï¿½o del diccionario[i]
	addi 	$s2, $a1, 0			#direccion del vector C
	addi 	$a0, $s2, 0			
	jal 	clearC
	addi	$t0, $zero, 0			# i=0
	whileStoreInC:
		slt 	$t1, $t0, $s1		# if(i<len(diccionario))
		slti 	$t2, $t0, 14		# if(i<14)
		and 	$t2, $t1,$t2
		beq 	$t2, 0, exitWhileStoreInC
		add	$t1, $t0, $s0		# reasigno $t1 con la variable para recorrer diccionario
		lb	$t2, 0($t1)		# diccionario[i]
		add	$t1, $t0, $s2		# reasigno $t1 con la variable para recorrer C
		sb	$t2, 0($t1)		# C[i] = diccionario[i]
		addi	$t0, $t0, 1		# i= i+1
		j whileStoreInC
	exitWhileStoreInC:
	
	lw	$ra, 32($sp)	
	lw   	$t3, 28($sp)			#guardo s2 en la pila
	lw   	$t2, 24($sp)			#guardo s2 en la pila
	lw   	$t1, 20($sp)			#guardo s2 en la pila
	lw	$t0, 16($sp)			#guardo ra em la pila
	lw   	$s3, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 36			#recupero los espacios reservados
	jr	$ra
	
#----------------------------------- Fin StoreInC -----------------------------------------	
#-------------------- Metodo de  length (vector.dir)-----------------------------------------------------
lenght:	
	addi	$sp, $sp, -16			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
	sw   	$t0, 4($sp)			#guardo s2 en la pila
	sw   	$t1, 8($sp)			#guardo s2 en la pila
	sw	$ra, 12($sp)
	
	addi 	$t0, $a0, 0			#Direcciï¿½n inicial del vector ($a0)
	addi 	$t1, $zero, 0			#Contador de tamaï¿½o
LoopLen:   
	lb  	$s2,0($t0)			# Vector[i] 
	beqz 	$s2, outLoopLen			
	addi 	$t0,$t0, 1			# i=i+1
	addi 	$t1, $t1, 1			# Contador = contador +1
	j LoopLen					
outLoopLen:    
	addi 	$v0, $t1, 0
	lw	$ra, 12($sp)
	lw   	$t1, 8($sp)			#guardo s2 en la pila
	lw   	$t0, 4($sp)			#guardo s2 en la pila
	lw   	$s2, 0($sp)			#guardo s2 en la pila	
	addi	$sp, $sp, 16			#recupero los espacios reservados
	jr	$ra
#------------------- Fin Metodo Length-------------------------------------------
#------------------------------------------------  clearC -------------------------------------------------------		
clearC:
	addi	$sp, $sp, -24			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$t0, 12($sp)			#guardo s2 en la pila
	sw   	$t1, 16($sp)			#guardo s2 en la pila
	sw	$ra, 20($sp)
	
	addi	$s0, $a0, 0			#asigno el vector a inicializar
	jal 	lenght
	addi	$s1, $v0, 0			#asigno el tamaï¿½o del vector C
	addi	$t0, $t0, 0			# i= 0
	addi	$s2, $zero, 0x00		# valor que sera almacenado
	whileClearC:
		slti	$t1, $t0, 15		# if(i<15) 
		beq  	$t1, 0, exitWhileC
		add 	$t1, $t0, $s0		# reasigno $t1 y le llevo la variable que itera	
		sb	$s2, 0($t1)		# C[i]= null
		addi 	$t0, $t0, 1		# i+1
						
	exitWhileC:	
	lw	$ra, 20($sp)
	lw   	$t1, 16($sp)			#guardo s2 en la pila
	lw   	$t0, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 24			#recupero los espacios reservados
	jr $ra
#------------------------------------------------ END CLEARC -------------------------------------------------------
exit: