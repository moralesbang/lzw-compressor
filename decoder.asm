# -- DECODER --
# Laboratory 3
# Author: Juan C. Morales

.data
#dict_length:		.byte 	128
dict:				.space 	65536
file_in:			.asciiz "encoded_file.txt"
file_out:			.asciiz "decoded_file.txt"
input_buffer: 		.space 	1024
joined: 			.space 	128
to_output:			.space	128
to_output_length:	.space	4
#current_index:		.space	16		# verified
	
.text

# -- RESERVED VARIABLES --
la $t0, input_buffer
move $s7, $t0			# Current pointer address of encoded_file.txt
# -- - --


open_file_for_reading:
	# Open (for reading) a file
	li $v0, 13		# System call for open file
	la $a0, file_in		# Input file name
	li $a1, 0		# Open for reading (flag = 0)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s0, $v0		# Copy file descriptor
	
read_file:
	# Read from previously opened file
	li $v0, 14				# System call for reading from file
	move $a0, $s0			# File descriptor
	la $a1, input_buffer	# Address of input buffer
	li $a2, 1024			# Maximum number of characters to read
	syscall					# Read from file
	move $t1, $v0			# Copy number of characters read <-- To have in coun !



# -- DECODING --
decoder:
	jal read_index
	move $a0, $v0
	
	jal get_string
	move $t0, $v0
	
	



	
# => Return next index in encoded_file.txt
read_index:
	addi $v0, $zero, 0		# partial result
	addi $t2, $zero, 0x0A	# $t2 <-- 10
	addi $t3, $zero, 0x020 	# $t2 <-- SPACE
	
	loop_ri:
		lb $t0, ($s7)		# load character in $t0
		beqz $t0, eof		# Did find END OF LINE?
		beq $t0, $t3, end	# Did find SPACE?
		
		andi $t0, $t0, 0x0F
		
		sll $v0, $v0, 4
		or $v0, $v0, $t0
		
		addi $s7, $s7, 1
		j loop_ri
		
	end: 
		addi $s7, $s7, 1
		jr $ra
		
	eof:
		addi $v0, $zero, -1
		jr $ra

# -- GETTIN STRING --
# -> Takes dict index in $a0
get_string:
	la $t1, dict
	la $t2, w
	sll $t0, $a0, 8
	add $t0, $t1, $t0
	
	addi $t3, $zero, 0		# $t3 <-- counter
	addi $t4, $zero, 0x010	# $t4 <-- 16
	
	loop_gs:
		slt $t5, $t3, $t4
		beqz $t5, end_gs
		add $t1, $t1, $t3
		add $t2, $t2, $t3
	
		lb $t5, ($t1)
		sb $t5, ($t2)
	
		addi $t3, $t3, 1
		j loop_gs
		
	end_gs:
		jr $ra
	

	

close_file:
	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file
	

exit:	li $v0, 10	# System call for exit
	syscall
