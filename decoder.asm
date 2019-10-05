# -- DECODER --
# Laboratory 3
# Author: Juan C. Morales

.data
dict:				.space 	65536
file_in:			.asciiz "encoded_file.txt"
file_out:			.asciiz "decoded_file.txt"
current_position:	.space	1			# Current position of encoded-file pointer 
input_buffer: 		.space 	2000000		# Read until 2 MB
gs_result:			.space	16			# For put result of get_string
ad_input_param:		.space 	16			# For space param for add_to_dict

.globl main
	
.text

# -- MAIN --
main:
	jal dict_setup
	jal lzw_decoder	
	j exit
# -- - --


# -- GLOBAL VARIABLES --
li $s7, 255		# Dictionary length
# -- - --

	
# -- DICT SETUP --
dict_setup:
	la $t0, dict
	addi $t1, $zero, 1		# Set iterator variable (i)

	loop_dict:
		slt $t2, $t1, $s7
		beqz $t2, end_ds
	
		subi $t0, $t1, 1	# j = i - 1
		sll $t3, $t1 4		# i * 16 for match with dict denifition (2^16 bytes)
		add $t3, $t3, $t1	# Resolve address
	
		sb $t0, ($t3)		# Store the value j in dict
	
		addi $t1, $t1, 1	# Increment i
	
		j loop_dict			# Looping
		
	end_ds: jr $ra
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
		
	# Close the file
	li   $v0, 16       # system call for close file
	move $a0, $s1      # file descriptor to close
	syscall
		
	j $ra
# -- - --


# -- OPEN FILE FOR READING --

# Inputs:
# $a0 -> Address where the filename is allowed
# Outuputs:
# $v0 -> File descriptor of file read

open_file_for_reading:
	# Open (for reading) a file
	li $v0, 13		# System call for open file
	li $a1, 0		# Open for reading (flag = 0)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s0, $v0	# Copy file descriptor
      
	# Read from previously opened file
	li $v0, 14				# System call for reading from file
	move $a0, $s0			# File descriptor
	la $a1, input_buffer	# Address of input buffer
	li $a2, 1024		   	# Maximum number of characters to read ( ***To Update*** )
	syscall					# Read from file
	move $t1, $v0			# Copy number of characters read

	# Return file descriptor
	move $v0, $s0	# Returning file descriptor
	
	jr $ra

# -- - --


# -- CLOSE FILE --

# Inputs:
# $a0 -> File descriptor of file to close
close_file:
	li $v0, 16       # system call for close file
	syscall            # close file
	jr $ra
		
# -- - --


# -- GET INDEX --
# Inputs:
# $a0 -> File address
# Outpus:
# $v0 -> Next index

jal open_file_for_reading	# Open encoded file
move $a0, $v0

get_index:
	la $s0, current_position	# Load current_position address
	lb $s3, ($s0)				# Load byte allowed in current_position
	
	la $s1, input_buffer		# Load input_buffer adress
	li $s2, 32	#space
	li $v0, 0	#result
	li $t2, 0	#c
	
	li $t7, 0x0A

	loop_gi:
		beq $t2, $s2, end_gi
		
		add $t0, $s0, $s3 # i + current_position
		lb $t0, ($t0)
		
		beqz $t0, eof_case # is c != null
		andi $t3, $t2, 0x0F #k (Parse c to int)
		
		mult $v0 $t7
		mflo $v0
		add $v0, $v0, $t3
		
		addi $s3, $s3, 1
	
	jal close_file	# Close encoded file
	
	end_gi:
		sb $s3, ($s0)
		jr $ra
		
	eof_case: jr $ra
# -- - --


# -- MOVE DATA --

# Inputs:
# $a0 -> Origin address
# $a1 -> Destination address

# Assumitions:
# - Both arrays received as params has a size of 16 bytes (For generalize, size can be pass as param)

move_data:
	li $t0, 0
	li $t1, 17
	
	loop_md:
		slt $t2, $t0, $t1
		beqz $t2, end_md
		sll $t3, $t0, 4
		add $t3, $t3, $a0
		add $t4, $t3, $a0
		
		lb $t5, ($t4)
		sb $t5, ($t4)
		
		addi $t0, $t0, 1
		j loop_md
		
	end_md: jr $ra
# -- - --


# -- GET STRING --

# Inputs:
# $a0 -> Index of string to get 

get_string:
	la $s0, dict	# dict's address
	li $t0, 0		#i
	li $t1, 4097

	slt $t2, $t0, $t1
	beqz $t2, out_of_range
	sll $t3, $t0, 4
	add $a0, $t3, $s0

	la $a1, gs_result
	jal move_data

	la $v0, gs_result	# Return the string getted address
	jr $ra

	out_of_range: 
		li $v0, 0
		jr $ra

# -- - --


# -- INDEX IN DICT? --

# Inputs:
# $a0 -> Index to check
# Outputs:
# $a1 -> 1 for true and 0 for false

index_in_dict:
	bge $a0, $s7, failureCase
	successCase:
		li $v0, 1
		jr $ra

	failureCase:
		li $v0, 0
		jr $ra
# -- - --


# -- ADD TO DICT --
# Inputs:
# $a0 -> address of string to add (16 bytes)

add_to_dict:
	# Update dict length
	addi $s7, $s7, 1
	
	# Inserting
	la $s0, dict
	sll $t0, $s7, 4
	
	add $a1, $t0, $s0
	jal move_data	# Values of $a0 is derived from params
	
# -- - --


# -- LZW DECODER | CORE --

lzw_decoder:
	la $a0, input_buffer
	jal read_index
	move $s0, $v0		# Index read from encoded_file | c
	
	move $a0, $s0
	jal get_string
	move $s1, $v0		# Address fo getted string | w
	
	# output
	
	li $t0, 0
	loop_dec:
		beq $s0, $t0, eof_case
		jal read_index
		move $s2, $v0		# c'
	
		move $a0, $s2
		jal index_in_dict
		move $s3, $v0
	
		beqz $s3, not_in_dict
		move $a0, $s3
		jal get_string
		move $s1, $v0
		
		# add to dict
	
		not_in_dict:
			# code
			
		# output(w)
		
		move $s1, $s2		# c = c'
		


# -- - --