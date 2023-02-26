#################################################################
# CDA3100 - Assignment 1			       		#
#						       		#
# The following code is provided by the professor.     		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

	.data
	.align 0

	# Define strings used in each of the printf statements
msg1:	.asciiz "Welcome to Prime Tester\n\n"
msg2:	.asciiz "Enter a number between 0 and 100: "
msg3:	.asciiz "Error: Invalid input for Prime Tester\n"
msg4:	.asciiz "The entered number is prime\n"
msg5:	.asciiz "The entered number is not prime\n"
ec_msg:	.asciiz " is prime\n" 		# Reserved for use in extra credit

	.align 2	
	.text
	.globl main

	# The following macros are provided to simplify the program code
	# A macro can be thought of as a cross between a function and a constant
	# The assembler will copy the macro's code to each use in the program code
	
	# Display the %integer to the user
	# Reserved for extra credit
	.macro display_integer (%integer)
		li $v0, 1			# Prepare the system for output
		add $a0, $zero, %integer	# Set the integer to display
		syscall				# System displays the specified integer
	.end_macro
	
	# Display the %string to the user
	.macro display_string (%string)
		li $v0, 4		# Prepare the system for output
		la $a0, %string		# Set the string to display
		syscall			# System displays the specified string
	.end_macro
	
	# Compute the square root of the %value
	# Result stored in the floating-point register $f2
	.macro calc_sqrt (%value)
		mtc1.d %value, $f2	# Copy integer %value to floating-point processor
		cvt.d.w $f2, $f2	# Convert integer %value to double
		sqrt.d $f2, $f2		# Calculate the square root of the %value
	.end_macro 
	
	# Determine if the %value is less-than or equal-to the current square root value in register $f2
	# Result stored in the register $v1
	.macro slt_sqrt (%value)
		mtc1.d %value, $f4	# Copy integer %value to floating-point processor
		cvt.d.w $f4, $f4	# Convert integer %value to double
		c.lt.d $f4, $f2		# Test if %value is less-than square root
		bc1t less_than_or_equal	# If less-than, go to less_than_or_equal label
		c.eq.d $f4, $f2		# Test if %value is equal-to square root
		bc1t less_than_or_equal	# If equal-to, go to less_than_or_equal label
		li $v1, 0		# Store a 0 in register $v1 to indicate greater-than condition
		j end_macro		# Go to the end_macro label
less_than_or_equal: 	
		li $v1, 1		# Store a 1 in register $v1 to indicate less-than or equal-to condition
end_macro: 
	.end_macro

main:
	# This series of instructions
	# 1. Displays the welcome message
	# 2. Displays the input prompt
	# 3. Reads input from the user
	display_string msg1	# Display welcome message
	display_string msg2	# Display input prompt
	li $v0, 5		# Prepare the system for keyboard input
	syscall			# System reads user input from keyboard
	move $a1, $v0		# Store the user input in register $a0
	j student_code 		# Go to the student_code label

error:	
	display_string msg3	# Display error message
	j exit
isprime:
	display_string msg4	# Display is prime message
	j exit
notprime:
	display_string msg5	# Display not prime message
exit:
	li $v0, 10	# Prepare to terminate the program
	syscall		# Terminate the program
	
#################################################################
# The code above is provided by the professor.     		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

# Place all your code below the student_code label
student_code:
	# Note: If number is prime, end program --

	# 2.0 If input < 2, number is prime. 
	# 3.0 Check if input is not 2.
	# 3.1 Check if input % 2 = 0. If true, number is prime.
	# 4.0 

	# Is input less than 0 set $v0 to 1.
	slt $v0, $a1, $zero
	# If above is true, end program.
	beq $v0, 1, error
	# Is input greater than 100, set $v1 to 1.
	sgtu $v1, $a1, 100
	beq $v1, 1, error

	# If input < 2 set $v0 to 1.
	slti $v0, $a1, 2
	# If above was true, number is not prime.
	beq $v0, 1, notprime
	
	# Get input % 2 (remainder of input/2)
	div $t0,$a1,2
	mfhi $t0
	
	# If input % 2 == 0, set $t1 to 1
	seq $t1, $t0, 0 
	# If input != 2, set $t2 to 1
	sne $t2, $a1, 2
	# If both above are true, the number is not prime.
	beq $t1, $t2, notprime
	li $t0, 3
	calc_sqrt $a1
	j loop
loop:
	# If $t0 <= $f2 (square root of input), set $v0 to 1
	slt_sqrt $t0
	# If $v1 > 0, the number is prime
	beq $v1, $zero, done
	# Get input % $t0
	div $t1, $a1, $t0
	mfhi $t1
	# If input % t0 = 0, number is not prime.
	beq $t1, $zero, notprime
	# increment %t0 by 2
	addi $t0, $t0, 2
	# Loop back up
	j loop
done:
	j isprime





