# Jack DeGuglielmo
# ECE 331
# 12/2/19

 .data
N: .word 1 # number of input vectors x
M: .word 6 # number of features
P: .word 100 # weight vector is 1 dimensional
#learned_weight_vector: .word 1, 1, 1, 1, 1, 1 #**your learned weights here**
learned_weight_vector: .word 49, 15, 6, 641, -270, 1483 #**your learned weights here**
x_data: .word
125,256,6000,256,16,128
29,8000,32000,32,8,32
29,8000,32000,32,8,32
29,8000,32000,32,8,32
29,8000,16000,32,8,16
26,8000,32000,64,8,32
23,16000,32000,64,16,32
23,16000,32000,64,16,32
23,16000,64000,64,16,32
23,32000,64000,128,32,64
400,1000,3000,0,1,2
400,512,3500,4,1,6
60,2000,8000,65,1,8
50,4000,16000,65,1,8
350,64,64,0,1,4
200,512,16000,0,4,32
167,524,2000,8,4,15
143,512,5000,0,7,32
143,1000,2000,0,5,16
110,5000,5000,142,8,64
143,1500,6300,0,5,32
143,3100,6200,0,5,20
143,2300,6200,0,6,64
110,3100,6200,0,6,64
320,128,6000,0,1,12
320,512,2000,4,1,3
320,256,6000,0,1,6
320,256,3000,4,1,3
320,512,5000,4,1,5
320,256,5000,4,1,6
25,1310,2620,131,12,24
25,1310,2620,131,12,24
50,2620,10480,30,12,24
50,2620,10480,30,12,24
56,5240,20970,30,12,24
64,5240,20970,30,12,24
50,500,2000,8,1,4
50,1000,4000,8,1,5
50,2000,8000,8,1,5
50,1000,4000,8,3,5
50,1000,8000,8,3,5
50,2000,16000,8,3,5
50,2000,16000,8,3,6
50,2000,16000,8,3,6
133,1000,12000,9,3,12
133,1000,8000,9,3,12
810,512,512,8,1,1
810,1000,5000,0,1,1
320,512,8000,4,1,5
200,512,8000,8,1,8
700,384,8000,0,1,1
700,256,2000,0,1,1
140,1000,16000,16,1,3
200,1000,8000,0,1,2
110,1000,4000,16,1,2
110,1000,12000,16,1,2
220,1000,8000,16,1,2
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
800,256,8000,0,1,4
125,512,1000,0,8,20
75,2000,8000,64,1,38
75,2000,16000,64,1,38
75,2000,16000,128,1,38
90,256,1000,0,3,10
105,256,2000,0,3,10
105,1000,4000,0,3,24
105,2000,4000,8,3,19
75,2000,8000,8,3,24
75,3000,8000,8,3,48
175,256,2000,0,3,24
300,768,3000,0,6,24
300,768,3000,6,6,24
300,768,12000,6,6,24
300,768,4500,0,1,24
300,384,12000,6,1,24
300,192,768,6,6,24
180,768,12000,6,1,31
330,1000,3000,0,2,4
300,1000,4000,8,3,64
300,1000,16000,8,2,112
330,1000,2000,0,1,2
330,1000,4000,0,3,6
140,2000,4000,0,3,6
140,2000,4000,0,4,8
140,2000,4000,8,1,20
140,2000,32000,32,1,20
140,2000,8000,32,1,54
140,2000,32000,32,1,54
140,2000,32000,32,1,54
140,2000,4000,8,1,20
57,4000,16000,1,6,12
57,4000,24000,64,12,16
26,16000,32000,64,16,24
26,16000,32000,64,8,24
26,8000,32000,0,8,24
26,8000,16000,0,8,16
480,96,512,0,1,1
203,1000,2000,0,1,5
predictions: .space 400
 .text
main:
 # Store M, N, P in $a? registers
 lw $a0, N
 lw $a1, M
 lw $a2, P
 jal multiply
 ori $v0,$0,10 # end program gracefully
 syscall
multiply:
 # Register usage:
 # n is $s0, m is $s1, p is $s2,
 # r is $s3, c is $s4, i is $s5,
 # sum is $s6
 # Prologue
 sw $fp, -4($sp)
 la $fp, -4($sp)
 sw $ra, -4($fp)
 sw $s0, -8($fp)
 sw $s1, -12($fp)
 sw $s2, -16($fp)
 sw $s3, -20($fp)
 sw $s4, -24($fp)
 sw $s5, -28($fp)
 sw $s6, -32($fp)
 addi $sp, $sp, -36
 # Save arguments
 move $s0, $a0 # n
 move $s1, $a1 # m
 move $s2, $a2 # p
 li $s3, 0 # r = 0
 li $t0, 4 # sizeof(Int)
 ##############################
 # Your code here
 la $t8, learned_weight_vector
 la $t9, x_data
 la $s6, predictions
 add $t1, $zero, $zero		# c (in t1) equals zero
 outerFor:
	beq $t1, $s0, mult_end		#break first for loop if c = n
	add $t2, $zero, $zero		# d (in t2) equals zero
	midFor:
		beq $t2, $s2, midEnd		#break second for loop if d = p
		add $t3, $zero, $zero 		# k (in t3) equals zero
		add $t4, $zero, $zero 		# sum (in t4) equals zero
		innerFor:
			beq $t3, $s1, innerEnd		#break third for loop if k = m
			mult $t1, $s1				#------------------------------------
			mflo $t6					#
			add $t6, $t6, $t3			# matrix[ i ][ j ] = array[ i*m + j ]
			sll $t6, $t6, 2				#
			add $t6, $t6, $t8			# Calculation for index of weight vector value
			lw $t6, 0($t6)				#------------------------------------
			
			mult $t2, $s1				#------------------------------------
			mflo $t7					#
			add $t7, $t7, $t3			# matrix[ i ][ j ] = array[ i*m + j ]
			sll $t7, $t7, 2				#
			add $t7, $t7, $t9			# Calculation for index of x_data vector value
			lw $t7, 0($t7)				#------------------------------------
			
			mult $t6, $t7				#multiply loaded values
			mflo $t5
			
			add $t4, $t4, $t5		# sum equals sum plus calculated product
		addi $t3, $t3, 1		# increment k
		j innerFor
		innerEnd:
			li $s5, 1000			# load constant 1000
			div $t4, $s5			#divide by 1000 for floating point
			mflo $t4
			li $s5, 55				# load constant 55 to subtract from sum of products
			sub $t4, $t4, $s5
			sw $t4, 0($s6)				#store in predictions
			addi $s6, $s6, 4		# increment to next word (starting at base address)
	addi $t2, $t2, 1		# increment d
	j midFor			# jump back to second loop
	midEnd:
  addi $t1, $t1, 1 		# increment c
  j outerFor		#jump back to first loop
 
 
 
 ##############################
mult_end:
 # Epilogue
 lw $ra, -4($fp)
 lw $s0, -8($fp)
 lw $s1, -12($fp)
 lw $s2, -16($fp)
 lw $s3, -20($fp)
 lw $s4, -24($fp)
 lw $s5, -28($fp)
 lw $s6, -32($fp)
 la $sp, 4($fp)
 lw $fp, ($fp)
 jr $ra
