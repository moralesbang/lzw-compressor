# Laboratory 3
# Authors: Juan C. Morales & Jose D. Tello

.data 

diccionario: 	.byte 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69
diccionario_asc: .asciiz  "a","b","c","d","e"
letra:		.asciiz "b"
leer_archivo:	.asciiz "Example.txt"

.align 2
input_buffer:	.space 20000

.text 

	#Abrir archivo leido
	li $v0, 13			#Sistema llama el archivo a abrir
	la $a0, leer_archivo		#Carga el nombre del archivo
	li $a1, 0			#Indica que se va a abrir para lectura (el cero)
	syscall 			#Llamado al sistema
	move $s0, $v0			# Copia el contenido del archivo a $s0
	
	#Lectura del archivo abierto previamente
	li $v0, 14			#Llamado al sistema para lectura del archivo
	move $a0, $s0			#Copia el contenido del arhcivo en $a0
	la $a1, input_buffer		#Carga la direccion del buffer
	li $a2, 10000			#Asigna el maximo numero de caracteres a leer
	syscall				#Llamado al sistema para leer
	move $t1, $v0			#Copia de los numero de caractreres a leer
	
Main:	la $t0, diccionario_asc		#Cargo la direccion del vector que contiene el diccionario
	#esta instruccion carga la direccion del vector en $a0
	addi $a0, $t0, 0		##°°°°°°°°°°°°°°°°° Se sobreescribe %$a0, tiene implicaciones por ya haberlo usado?
	jal lenght
	addi $a3, $v0, 0		#asigno el tamaño del vector de diccionario
	
	###aqui se llama el metodo compresio, el cual contiene toda la logica 
compression:
	addi $sp, $sp, -16		#Inicio la pila para almacenar $a0,1,2,3
	sw $a0, 0($sp)			#Almaceno $a0
	sw $a1, 0($sp)			#Almaceno $a1
	sw $a2, 0($sp)			#Almaceno $a2
	sw $a3, 0($sp)			#Almaceno $a3
	
	
salto:
	j salto

	
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

	
sale:
