.data 
diccionario:	.byte 'a',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,'b',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,'c',0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
c: 		.byte 	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
x:		.byte	'i',0x00
.text
	la 	$s0, diccionario
	la 	$s1, c
	la	$s2, x
	addi	$a0, $s0, 0	
	jal 	lenghtDic		
	addi 	$s5, $v0, 0		#retorna el tamaño de diccionario	
	addi 	$a0, $s0, 0		#asigno al parametro el diccionario
	addi 	$a1, $s1, 0		#asigno al parametro el vector C
	addi 	$a2, $s5, 0		#asigno el tamaño de diccionario
	
	jal 	getIndex
	add 	$t3, $v1, $s0
	lb 	$t4, 32($s0)
	j exit
	
	
#----------------------------------- GETINDEX CHARACTER (dicc.dir, aux.dir, len(diccionario)) ------------------------------------
getIndex:
	addi	$sp, $sp, -68			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s0 en la pila
	sw   	$s1, 4($sp)			#guardo s1 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s3 en la pila	
	sw   	$s4, 16($sp)			#guardo s4 en la pila	
	sw   	$s5, 20($sp)			#guardo s5 en la pila
	sw	$t0, 24($sp)			#guardo t0 en la pila
	sw	$t1, 28($sp)
	sw	$t2, 32($sp)
	sw	$t3, 36($sp)
	sw	$t4, 40($sp)
	sw	$t5, 44($sp)
	sw	$t6, 48($sp)
	sw	$t7, 52($sp)
	sw	$t8, 56($sp)
	sw	$t9, 60($sp)
	sw	$ra, 64($sp)
	
	
	addi 	$v1, $zero, -1  		# return -1, que indica que no lo encontrï¿½
	addi	$s0, $a0, 0			#Cargo direcciï¿½n del diccionario
	addi	$s1, $a1, 0			#Cargo direcciï¿½n del vector CX
	addi	$t0, $zero, 0			# i=0
	add	$s5, $t0, $s0			# llevo posicion del vector
	addi	$s2, $a2, 0 			# $a0 contiene el tamaï¿½o total del diccionario
	whileLeghtDict:	
		slt	$t1, $t0, $s2		# if(i< len(diccionario)) ï¿½ if($t0 < $t1)
		beq	$t1, 0, exitWhileIndex	
		sll	$s5, $t0, 4		# i*16
		add	$s5, $s5, $s0		# i + direccion del vector diccionario
		lb	$t1, 0($s5)		# reuso de $t1 y cargo diccionario[i]
		lb	$t2, 0($s1)		# vector CX[0]
		bne 	$t1, $t2, exitWhileCX	#if (lectraC == letraDicc)
		addi 	$a0, $s5, 0		# Parametro con la direccion de diccionario[i]
		jal lenght
		addi	$t3, $v0, 0		# asigno el tamaï¿½o del diccionario[0] ï¿½ len(diccionario[i])
		addi 	$a0, $s1, 0		# Parametro con la direccion de diccionario[i]
		jal lenght
		addi	$t4, $v0, 0		# asigno el tamaï¿½o del diccionario[0] ï¿½ len(diccionario[i])
		bne	$t3, $t4, exitWhileCX	#if (tamaï¿½oCX == tamaï¿½oDiccionarioPosi)
		addi	$t5, $zero, 0		# j = 0
		whileLenghtCX:
			slt	$t6, $t5, $t3		# if(j< tamaï¿½oCX)) ï¿½ if($t5 < $t3)
			slti	$t7, $t5, 14		# if(j<14) para evitar que lea el siguiente espacio
			and	$t7, $t7, $t6		
			beq	$t7, 0, exitWhileCX	
			add	$t7, $t5, $s5		#aux = j +i
			add	$t8, $s1, $t5		#aux2 = j + direccion CX
			lb	$s3, 0($t7)		#diccionario[i][j]
			lb	$s4, 0($t8)		#vectorCX[j]
			beq	$s3, $s4, addJ		#if(CX[i] != diccionario[i][j])
			addi	$t9, $zero, 0		#Bandera = False
			j exitWhileCX
		addJ:
			addi	$t5, $t5, 1		# j = j+1
			addi	$t9, $zero, 1		#Bandera = True
			j whileLenghtCX						
		exitWhileCX:
			bne 	$t9, 1, breakWhile	#if(bandera == true)
			addi 	$v1, $t0, 0  		# return direccion i del diccionario
			j exitWhileIndex
		breakWhile:
		addi 	$t0, $t0, 1			#i = i + 16
		j whileLeghtDict
	exitWhileIndex:
	
	
	lw	$ra, 64($sp)
	lw	$t9, 60($sp)
	lw	$t8, 56($sp)
	lw	$t7, 52($sp)
	lw	$t6, 48($sp)
	lw	$t5, 44($sp)
	lw	$t4, 40($sp)
	lw	$t3, 36($sp)
	lw	$t2, 32($sp)
	lw	$t1, 28($sp)
	lw	$t0, 24($sp)			#guardo t0 en la pila
	lw   	$s5, 20($sp)			#guardo s5 en la pila
	lw   	$s4, 16($sp)			#guardo s4 en la pila	
	lw   	$s3, 12($sp)			#guardo s3 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s1 en la pila
	lw   	$s0, 0($sp)			#guardo s0 en la pila	
	addi	$sp, $sp, 68			#reserva 1 espacio
	jr	$ra
	
#----------------------------------- END GETINDEX CHARACTER ------------------------------------	
#-----------------------------------Concatena -----------------------------------------	
concatenate:
	addi	$sp, $sp, -36			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s2 en la pila
	sw   	$s1, 4($sp)			#guardo s2 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s2 en la pila
	sw   	$t0, 16($sp)			#guardo s2 en la pila
	sw   	$t1, 20($sp)			#guardo s2 en la pila
	sw   	$t2, 24($sp)			#guardo s2 en la pila
	sw   	$t3, 28($sp)			#guardo s2 en la pila
	sw	$ra, 32($sp)			#guardo ra em la pila
	
	addi 	$s0, $a0, 0			#tamaño de C
	addi 	$s1, $a1, 0			#Dirección del vector C
	addi 	$s2, $a2, 0			#Dirección del vector x
	
	add 	$t1, $s0, $s1			#Tamaño de C+1
	lb	$t2, 0($s2)			# X[0], ya que siempre carga siempre solo 1 valor
	sb	$t2, 0($t1)			#C[i] = X[0] o C[0] en la ultima posicion le asigno X[0]
	addi 	$t1, $t1, 1			#Tamaño de C+1
	addi	$t3, $zero, 0x00		#Creterio de parada 
	sb 	$t3, 0($t1)			#Asigno en la ultima posicion el nuevo criterio de parada
	
	sw   	$t0, 16($sp)			#guardo s2 en la pila
	
	lw   	$ra, 32($sp)			#guardo s2 en la pila
	lw   	$t3, 28($sp)			#guardo s2 en la pila
	lw   	$t2, 24($sp)			#guardo s2 en la pila
	lw   	$t1, 20($sp)			#guardo s2 en la pila
	lw	$t0, 16($sp)			#guardo ra em la pila
	lw   	$s3, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	addi	$sp, $sp, 20			#recupero los espacios reservados
	jr	$ra
	
#----------------------------------- Fin Concatena -----------------------------------------	


	
#-------------------- Metodo de  lengthDic (vector.dir)-----------------------------------------------------
lenghtDic:	
	addi	$sp, $sp, -16			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
	sw   	$t0, 4($sp)			#guardo s2 en la pila
	sw   	$t1, 8($sp)			#guardo s2 en la pila
	sw	$ra, 12($sp)
	
	
	addi 	$t0, $a0, 0			#Dirección inicial del vector ($a0)
	addi 	$t1, $zero, 0			#Contador de tamaño
LoopLenDic:   
	lb  	$s2,0($t0)			# Vector[i] #########################Cambiar lw por lb y disminuir a 1 la suma de i
	beqz 	$s2, outLoopLen			###################Aqui como se compara para salir????? por ahora lo estoy comparando con zero
	addi 	$t0,$t0, 16			# i=i+1
	addi 	$t1, $t1, 1			# Contador = contador +1
	j LoopLenDic					
outLoopLenDic:    
	addi 	$v0, $t1, 0
	lw	$ra, 12($sp)
	lw   	$t1, 8($sp)			#guardo s2 en la pila
	lw   	$t0, 4($sp)			#guardo s2 en la pila
	lw   	$s2, 0($sp)			#guardo s2 en la pila	
	addi	$sp, $sp, 16			#recupero los espacios reservados
	jr	$ra
#------------------- Fin Metodo LengthDic-------------------------------------------

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

exit:
	
	
	
