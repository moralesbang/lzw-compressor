.data
str1:	.asciiz "foo"
str2: 	.asciiz "bar"

.text
main:
	la $s1, str1
	la $s2, str2
	
	lb $t1, ($s1)
	lb $t2, ($s2)
