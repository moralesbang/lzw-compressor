.text

.macro	tamano(%direccionVector)
#-------------------- Metodo de  length (vector.dir)-----------------------------------------------------
lenght:	
	addi	$sp, $sp, -12			#reserva 1 espacio
	sw   	$s2, 0($sp)			#guardo s2 en la pila
	sw   	$t0, 4($sp)			#guardo s2 en la pila
	sw   	$t1, 8($sp)			#guardo s2 en la pila
	
	la	$a0, (%direccionVector)
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
	lw   	$t1, 8($sp)			#guardo s2 en la pila
	lw   	$t0, 4($sp)			#guardo s2 en la pila
	lw   	$s2, 0($sp)			#guardo s2 en la pila	
	addi	$sp, $sp, 12			#recupero los espacios reservados
.end_macro 
#------------------- Fin Metodo Length-------------------------------------------