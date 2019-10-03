.data
diccionario: 	.byte 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x70, 0x00 #0x00 condicion de parada#
diccionario_asc: .byte  0x72
#letra:		.asciiz "b"
#leer_archivo:	.asciiz "Example.txt"

.text

	la 	$s0, diccionario
	addi 	$a0, $s0,0
		jal 	lenght
	addi 	$a1, $v0, 0
	addi 	$a2 ,$a0, 0
	la 	$s1, diccionario_asc	
	lb	$a0, 0($s1)
		jal 	index
	addi 	$s7, $v0, 0
	j exit
	

#-------------------- Metodo de  Index-----------------------------------------------------
index:	addi	$sp, $sp, -12			#reserva 2 espacio
	sw   	$s0, 0($sp)			#guardo s0 en la pila
	sw   	$s1, 4($sp)			#guardo s1 en la pila
	sw	$s2, 8($sp)			#guardo s2 en la pila
	#Parametros (Vector, cadena)
	addi 	$s0, $a0, 0			#Cadena o letra a comparar, viene como parametro en $a0
	addi 	$s1, $a1, 0			#tamaño del vector que viene como parametro ($a1)
	addi 	$t1, $a2, 0			#Dirección base del vector ($a1)
	#--------------------------------
	addi 	$t0, $zero, 0			# Inicializa i	
	addi 	$t2, $zero, -1			# Variable a retornar (Index)
LoopIndex: 
	slt	$t3, $t0, $s1			# if (i < len(vector)) ó if($t0 < $s1)
	beq	$t3, 0, returnIndex		# Salta a return si i >= len(vector)
	lb  	$t4, 0($t1)			# Vector[i]
	beq 	$t4, $s0, setIndex		# if(vector[i] == cadena) return 
	addi 	$t0, $t0, 1			# i=i+1	
	addi 	$t1, $t1, 1			# PC (i) + 4
	j LoopIndex	
setIndex: ##Aqui solo entra si lo llama el beq
	addi 	$t2, $t0,0			# Index = i				
returnIndex:    
	add 	$v0, $zero, $t2
	lw	$s0, 0($sp)			#recupero el valor de s0
	lw	$s1, 4($sp)			#recupero el valor de s1
	lw	$s2, 8($sp)			#recupero el valor de s2
	addi	$sp, $sp, 12			#recupero los espacios reservados			
	jr $ra
#------------------- Fin Metodo Index-------------------------------------------

#-------------------- Metodo de  length-----------------------------------------------------
lenght:	
	addi	$sp, $sp, -4			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
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
	lw	$s2, 0($sp)			#recupero el valor de s2
	addi	$sp, $sp, 4			#recupero los espacios reservados
	jr	$ra
#------------------- Fin Metodo Length-------------------------------------------

	
exit:
