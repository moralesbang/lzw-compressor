.data	
diccionario:	.space 65536
archivo:	.asciiz  "abcabca"
c:	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
aux:	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

.text
main:
	jal	dictInitialize
	la	$a0, diccionario 
	la	$a1, archivo
	jal compression
	lb	$t8, 64($s1)
	lb	$t9, 65($s1)
	#li $v0, 1 		# código de imprimir cadena
	#addi $a0, $t9,0		# dirección de la cadena
	#syscall
	j exit
#---------------------Metodo de Compresi�n (dicc.dir, file.dir)-----------------------------------------------
compression: 
	addi	$sp, $sp, -44			#reserva 1 espacio
	sw   	$s0, 0($sp)			#guardo s0 en la pila
	sw   	$s1, 4($sp)			#guardo s1 en la pila
	sw   	$s2, 8($sp)			#guardo s2 en la pila
	sw   	$s3, 12($sp)			#guardo s3 en la pila
	sw	$t0, 16($sp)			#guardo t0 en la pila
	sw	$t1, 20($sp)			#guardo t0 en la pila
	sw	$t2, 24($sp)			#guardo t0 en la pila
	sw	$t3, 28($sp)			#guardo t0 en la pila
	sw	$t4, 32($sp)			#guardo t0 en la pila
	sw	$t5, 36($sp)
	sw	$ra, 40($sp)
	
	la	$s0, c				#Cargo direccion del vector C
	addi	$s1, $a0, 0			#Cargo direccion inicial del diccionario $a0 = direccion diccionario
	addi 	$s2, $a1, 0			#Cargo direccion inicial del archivo $a1 = direccion archivo
	la	$s3, aux			#cargo direccion del vector aux
	addi	$t0, $zero, 0			# i = 0
	lb	$t1, 0($s2)			# file[0]
	sb	$t1, ($s0)			#Almacenamos en la primera psocicion de C file[0]
	addi	$t0, $t0, 1			# i = i+1
	whileCNull:
		beq	$t1, $zero, ExitWhileCNull  ##------------------------------- $zero es la representaci�n de null?-------
		add	$t2, $s2, $t0		#i = i+ file.direccion
		lb	$t3, 0($t2)		# X = file[i]
		
		addi	$a0, $s0, 0		#parametro para concatenar en C (C.dir)
		addi 	$a1, $t3, 0		#parametro para concatenar en C (Xval)
		addi	$a2, $s3, 0		#parametro para concatenar en C (aux.dir)
		jal 	concatenate		
		addi	$a0, $s1, 0		#parametro para lenght de diccionario
		jal 	lenghtDic
		addi	$a2, $v0, 0		# parametro de tama�o del diccionario
		addi	$a0, $s1, 0		# parametro de direccion del diccionario
		addi 	$a1, $s3, 0		# paramtro de direccion de aux
		jal 	getIndex
		
		addi	$t4, $v1, 0		# el index 
		whileCPrimeDontHaveMinus:
			beq	$t4, -1, exitWhileCPrime 
			sll 	$t5, $t4, 4		#Posicion index * 16
			add	$a0, $s1, $t5		#Asigno parametro diccionario para stroreInC method
			addi	$a1, $s0, 0		#Asigno parametro vector C para stroreInC method
			jal storeInC
			
			addi 	$t0, $t0, 1		#i = i+1
			add	$t2, $s2, $t0		#i = i+ file.direccion
			lb	$t3, 0($t2)		# x = file[i]
			addi	$a0, $s0, 0		#parametro para concatenar en C (C.dir)
			addi 	$a1, $t3, 0		#parametro para concatenar en C (Xval)
			addi	$a2, $s3, 0		#parametro para concatenar en C (aux.dir)
			jal 	concatenate
			addi	$a0, $s1, 0		#parametro para lenght de diccionario
			jal 	lenghtDic
			addi	$a2, $v0, 0		# parametro de tama�o del diccionario
			addi	$a0, $s1, 0		# parametro de direccion del diccionario
			addi 	$a1, $s3, 0		# paramtro de direccion de aux
			jal 	getIndex
			addi	$t4, $v1, 0		# el index en i
			j whileCPrimeDontHaveMinus
		exitWhileCPrime:
				
		
		#Imprimo indice-----------------------
		addi	$a0, $s1, 0		#parametro para lenght de diccionario
		jal 	lenghtDic
		addi	$a2, $v0, 0		# parametro de tama�o del diccionario
		addi	$a0, $s1, 0		# parametro de direccion del diccionario
		addi 	$a1, $s0, 0		# paramtro de direccion de c
		jal 	getIndex
		addi	$t4, $v1, 0		# el index en i
		
		li	$v0, 1
		addi 	$a0, $t4,0		# dirección de la cadena
		syscall
		
		
		#----------------------------------------
		addi	$a0, $s1, 0		#Parametro de diccionario para metodo StoreInDic
		addi	$a1, $s3, 0		#Parametro de aux para metodo StoreInDic
		jal	storeInDic 
		addi	$a0, $s0, 0		#limpio el vector de C para poder guardar
		jal 	clearC
		
		sb 	$t3, 0($s0)		#C = X
		addi 	$t0, $t0, 1		#i = i+1
		lb	$t1, 0($s0)	
		j whileCNull	
	ExitWhileCNull:
	
	
	lw	$ra, 40($sp)
	lw	$t5, 36($sp)
	lw   	$t4, 32($sp)			#guardo s2 en la pila
	lw   	$t3, 28($sp)			#guardo s2 en la pila
	lw   	$t2, 24($sp)			#guardo s2 en la pila
	lw   	$t1, 20($sp)			#guardo s2 en la pila
	lw   	$t0, 16($sp)			#guardo s2 en la pila
	lw   	$s3, 12($sp)			#guardo s2 en la pila
	lw   	$s2, 8($sp)			#guardo s2 en la pila
	lw   	$s1, 4($sp)			#guardo s2 en la pila
	lw   	$s0, 0($sp)			#guardo s2 en la pila
	
	addi	$sp, $sp, 44
	jr $ra




 #-------------------------------------- Dict initialize----------------------------------------------
dictInitialize:
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
#----------------------------------- StoreInDic:(Diccionario.dir, Aux.dir) ------------------------------------
storeInDic:
	addi	$sp, $sp, -40			#reserva 1 espacio
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
	addi	$t0, $v0, 0			#Tama�o del vector aux
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
	
	
	addi 	$s0, $a0, 0			#Direcci�n del diccionario[i]
	jal	lenght
	addi	$s1, $v0, 0			#tama�o del diccionario[i]
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
#-----------------------------------Concatena: (C.dir, Xval, aux.dir) -----------------------------------------	
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
	sw	$ra, 32($sp)
	
	
	addi 	$s0, $a0, 0			#Direcci�n del vector C
	jal	lenght
	addi	$s1, $v0, 0			#tama�o del vector C
	addi 	$s2, $a1, 0			#valor de x
	addi	$s3, $a2, 0			#direccion del vector aux
	addi 	$a0, $s3, 0			#Limpio el vector aux
	jal 	clearC
	addi	$t0, $zero, 0			# i=0
	whileConcatenate:
		slt 	$t1, $t0, $s1		# if(i<lenC)
		slti 	$t2, $t0, 14		# if(i<14)
		and 	$t2, $t1,$t2
		beq 	$t2, 0, exitWhileConcatenate
		add	$t1, $t0, $s0		# reasigno $t1 con la variable para recorrer C
		lb	$t2, 0($t1)		# C[i]
		add	$t1, $t0, $s3		# reasigno $t1 con la variable para recorrer Aux
		sb	$t2, 0($t1)		# Aux[i] = C[i]
		addi	$t0, $t0, 1		# i= i+1
		j whileConcatenate
	exitWhileConcatenate:
	add 	$t1, $t0, $s3			# Aux[last-1]
	sb 	$s2, 0($t1)			#Aux[last-1] = x
	addi 	$t1, $t1, 1			# last+1
	addi	$t3, $zero, 0x00		#Condicion de parada de aux	
	sb 	$t3, 0($t1)			# aux[last] = null	
		
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
	
#----------------------------------- Fin Concatena -----------------------------------------	
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
	
	
	addi 	$v1, $zero, -1  		# return -1, que indica que no lo encontr�
	addi	$s0, $a0, 0			#Cargo direcci�n del diccionario
	addi	$s1, $a1, 0			#Cargo direcci�n del vector CX
	addi	$t0, $zero, 0			# i=0
	add	$s5, $t0, $s0			# llevo posicion del vector
	addi	$s2, $a2, 0 			# $a0 contiene el tama�o total del diccionario
	whileLeghtDict:	
		slt	$t1, $t0, $s2		# if(i< len(diccionario)) � if($t0 < $t1)
		beq	$t1, 0, exitWhileIndex	
		sll	$s5, $t0, 4		# i*16
		add	$s5, $s5, $s0		# i + direccion del vector diccionario
		lb	$t1, 0($s5)		# reuso de $t1 y cargo diccionario[i]
		lb	$t2, 0($s1)		# vector CX[0]
		bne 	$t1, $t2, exitWhileCX	#if (lectraC == letraDicc)
		addi 	$a0, $s5, 0		# Parametro con la direccion de diccionario[i]
		jal lenght
		addi	$t3, $v0, 0		# asigno el tama�o del diccionario[0] � len(diccionario[i])
		addi 	$a0, $s1, 0		# Parametro con la direccion de diccionario[i]
		jal lenght
		addi	$t4, $v0, 0		# asigno el tama�o del diccionario[0] � len(diccionario[i])
		bne	$t3, $t4, exitWhileCX	#if (tama�oCX == tama�oDiccionarioPosi)
		addi	$t5, $zero, 0		# j = 0
		whileLenghtCX:
			slt	$t6, $t5, $t3		# if(j< tama�oCX)) � if($t5 < $t3)
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
#-------------------- Metodo de  length (vector.dir)-----------------------------------------------------
lenght:	
	addi	$sp, $sp, -16			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
	sw   	$t0, 4($sp)			#guardo s2 en la pila
	sw   	$t1, 8($sp)			#guardo s2 en la pila
	sw	$ra, 12($sp)
	
	addi 	$t0, $a0, 0			#Direcci�n inicial del vector ($a0)
	addi 	$t1, $zero, 0			#Contador de tama�o
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
	addi	$s1, $v0, 0			#asigno el tama�o del vector C
	addi	$t0, $zero, 0			# i= 0
	addi	$s2, $zero, 0x00		# valor que sera almacenado
	whileClearC:
		slti	$t1, $t0, 15		# if(i<15) 
		beq  	$t1, 0, exitWhileC
		add 	$t1, $t0, $s0		# reasigno $t1 y le llevo la variable que itera	
		sb	$s2, 0($t1)		# C[i]= null
		addi 	$t0, $t0, 1		# i+1
		j whileClearC
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
#-------------------- Metodo de  lengthDic (diccionario.dir)-----------------------------------------------------
lenghtDic:	
	addi	$sp, $sp, -16			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
	sw   	$t0, 4($sp)			#guardo s2 en la pila
	sw   	$t1, 8($sp)			#guardo s2 en la pila
	sw	$ra, 12($sp)
	
	
	addi 	$t0, $a0, 0			#Direcci�n inicial del vector ($a0)
	addi 	$t1, $zero, 0			#Contador de tama�o
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
exit:
