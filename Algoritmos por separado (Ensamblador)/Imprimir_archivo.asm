.data	
	diccionario:	.byte		'a','b''c'
	diccionario2:	.asciiz	"def"
.text

	li	$v0, 4
	la	$a0, diccionario2
	syscall