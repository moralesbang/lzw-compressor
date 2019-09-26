# Laboratory 3
# Authors: Juan C. Morales & Jose D. Tello

.data
file_in:	.asciiz "encoded.bin"
file_out:	.asciiz "decoded_file.txt"
input_buffer: 	.space 1024

.globl lzw_decoder
	
.text
lzw_decoder:
	# Open (for reading) a file
	li $v0, 13		# System call for open file
	la $a0, file_in		# Input file name
	li $a1, 0		# Open for reading (flag = 0)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s0, $v0		# Copy file descriptor

	# Read from previously opened file
	li $v0, 14		# System call for reading from file
	move $a0, $s0		# File descriptor
	la $a1, input_buffer	# Address of input buffer
	li $a2, 2000		# Maximum number of characters to read
	syscall			# Read from file
	move $t1, $v0		# Copy number of characters read
	
	# Decoding
	la	$s0, input_buffer
	Loop: 	lb 	$t2, 0($s0)
		beqz 	$t2, Exit 

		# Printing File Content
		li  	$v0, 1		# system Call for PRINT STRING
		move  	$a0, $t2   	# buffer contains the values
		syscall             	# print int
		
		addi 	$s0, $s0, 1
		j 	Loop
	

#read_index:
	
#read_byte:

# Close the files
li   $v0, 16       # system call for close file
move $a0, $s0      # file descriptor to close
syscall            # close file
	

Exit:	li $v0, 10	# System call for exit
	syscall
