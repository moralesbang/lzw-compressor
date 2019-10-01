.data
array:	.space 16

.text
la $s0, array
addi $t0, $zero, 0x062
sb $t0, ($s0)

lb $s1, ($s0)