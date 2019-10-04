# -- DECODER --
# Laboratory 3
# Author: Juan C. Morales

.data
#dict_length:		.byte 	128
dict:				.space 	65536
file_in:			.asciiz "encoded_file.txt"
file_out:			.asciiz "decoded_file.txt"
input_buffer: 		.space 	10240
joined: 			.space 	128
to_output:			.space	128
to_output_length:	.space	4
current_string:		.space	16		# verified

.globl main
	
.text

# -- MAIN --
main:
jal open_files
jal lzw_decoder	
j exit
# -- - --
	
# -- DICT SETUP --
dict_setup:
	la $t0, dict
	addi $t1, $zero, 1		# Set iterator variable (i)
	addi $s0, $zero, 257

	loop_dict:
		slt $t2, $t1, $s0
		beqz $t2, lzw_decoder
	
		sll $t3, $t1 4		# i * 16 for match with dict denifition (2^16 bytes)
		add $t3, $t3, $t1	# Resolve address
	
		sb $t1, ($t3)		# Store the value for dict
	
		addi $t1, $t1, 1	# Increment i
	
		j loop_dict			# Looping
# -- - --


# -- OPENING FILE --
open_files:
	open_encoded_file:
		# Open (for reading) a file
		li $v0, 13			# System call for open file
		la $a0, file_in		# Input file name
		li $a1, 0			# Open for reading (flag = 0)
		li $a2, 0			# Mode is ignored
		syscall				# Open a file (file descriptor returned in $v0)
		move $s0, $v0		# Copy file descriptor
	
	open_decoded_file:

# -- - --

# -- OUTPUT --
# Inputs:
# $a0 -> Direction of output_data
# $a1 -> Number of caracaters to print

output:
	# Copying args
	move $t0, $a0
	move $t1, $a1

	# Open (for writing) a file that does not exist
	li $v0, 13			# System call for open file
	la $a0, file_out	# Output file name
	li $a1, 9			# Open for writing and appending (flag = 9)
	li $a2, 0			# Mode is ignored
	syscall				# Open a file (file descriptor returned in $v0)
	move $s1, $v0		# Copy file descriptor
		
	# Append a sentence to the output file file
	li $v0, 15			# System call for write to a file
	move $a0, $s1		# Restore file descriptor (open for writing)
	move $a1, $t0		# Address of buffer from which to write
	move $a2, $t1			# Number of characters to write
	syscall
		
	# Close the files
	li   $v0, 16       # system call for close file
	move $a0, $s1      # file descriptor to close
	syscall
		
	j $ra
# -- - --


# -- LZW DECODER | CORE --

lzw_decoder:

# -- - --

lzw_decoder:

# -- RESERVED VARIABLES --
la $s7, input_buffer		# Current pointer position of encoded_file.txt
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
	
	jal get_string_address
	move $a3, $v0
	
	jal output
	
	



	
# => Return next index in encoded_file.txt
read_index:
	addi $v0, $zero, 0		# partial result
	addi $t2, $zero, 0x0A	# $t2 <-- 10
	addi $t3, $zero, 0x020 	# $t2 <-- SPACE
	
	loop_ri:
		lb $t0, ($s7)		# load character in $t0
		beqz $t0, eof		# Did find END OF LINE?
		beq $t0, $t3, end	# Did find SPACE?
		
		andi $v0, $t0, 0x0F
		mflo
				
		addi $s7, $s7, 1
		j loop_ri
		
	end: 
		addi $s7, $s7, 1
		jr $ra
		
	eof:
		addi $v0, $zero, -1
		jr $ra

get_string_address:
	sll $t0, $a0, 8
	add $v0, $s7, $t0
	jr $ra




# -> Output address is passed in $a3	
output:
	open_file_for_writting:
		# Open (for writing) a file that does not exist
		li $v0, 13			# System call for open file
		la $a0, file_out	# Output file name
		li $a1, 9			# Open for writing and appending (flag = 9)
		li $a2, 0			# Mode is ignored
		syscall				# Open a file (file descriptor returned in $v0)
		move $s1, $v0		# Copy file descriptor
		
	add_content:
		# Append a sentence to the output file file
		li $v0, 15			# System call for write to a file
		move $a0, $s1		# Restore file descriptor (open for writing)
		move $a1, $a3		# Address of buffer from which to write
		li $a2, 1			# Number of characters to write | To define dynamic length, we can do that in get_index
		syscall

close_file:
	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file
	

exit:
	close_files:
		# Close the files
  		li   $v0, 16       # system call for close file
		move $a0, $s0      # file descriptor to close
		syscall            # close file
	
	exit_program:
		li $v0, 10			# System call for exit
		syscall