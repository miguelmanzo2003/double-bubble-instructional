# Miguel Manzo 
# CSC656, MIPS subroutine to print an an array
# September 4, 2025
#
# 1 sentence description here: Use subroutine to print the elements of an array, return number of elements printed. 
#My subroutine function is called print_array, I am sending the arguments in main using $a0 and $a1 then storing/moving them in 
#$t1 and $t2 in the function and returning the number of items printed in $v0

.data
arr:	.word	-2, -1, 0, 92, 52, 27, 86, 6, 52, 35    # this is the source data array, please fill with your own random numbers from https://www.calculator.net/random-number-generator.html
n:	.word	10     # hard-coded problem size n=10
msg:	.asciiz "The problem size is : "
temp: 	.asciiz "END OF INNER LOOP/SUBROUTINE \n\n"
entered_b_inner: .asciiz "Entered Inner Loop/Subroutine n: "
entered_b_outer: .asciiz "Entered Bubble Sort Outer Loop\n "
entered_b_sort: .asciiz "Entered Bubble sort\n "
printing_decrement: .asciiz "Printing Decrement (n-i-1):  "
printing_i : .asciiz "Printing i:  "
end_b_loop: .asciiz "End of Bubble Loop\n"
.text
.globl main
main:

	la $a0, arr #load the memory address of the array -> arr[0]   arg0 = starting index of iteration
	lw $a1, n # $t1 will act as our length of the array           arg1 = end index of iteration
	
	jal print_array
	la $a0, arr #upon return of the print_array function, our arr may be at arr[n] so now load arr at base arr[0]
	lw $a1, n #move n-1 to $a1 to send it as an arguement for call to bubble sort
	jal bubble_sort
	li $v0, 10
	syscall
	#move $a0, $v0  #the print_array function returns an int, and stored it in $v0, so now that we called and returned, move to $a0
	#li $v0, 1	#to print
	#syscall
	#li $v0, 10
	#syscall
	

print_array:
	
	move $t6, $a0  #a0 has starting index base (arr) move it into $t6
	move $t7, $a1  #a1 has ending index, n, move it into $t7
	li $t5, 0 # $t5 will act as out i, index counter, cant do $t0 because we dont want to change the $t0 value in the callee
	
	
	
	
	print_loop: # had to use print_loop becaue otherwise we would start at arr[0] everytime
		
		slt $t4, $t5, $t7 #compare i to n, is i < n, if yes --> $t4 = 1, else $t4 = 0
		
		beq $t4, $zero, end_of_print_loop # if $t4 is 0 it means i is greater than or eaual to n, so branch to end
		
		li	$v0, 1	# opcode to print an int to the console
		lw	$a0, 0($t6)  #load address of $t6 --> arr[0] ... arr[x] 
		syscall
	
		li	$v0, 11   # opcode to print an ascii character to the console
		li	$a0, 32   #ascii for space is 32
		syscall
	
		addi $t6, $t6, 4 #increment by 4 bytes because 4 bytes = 32 bits, so go to the next 32 bit value
		addi $t5, $t5, 1 #increment i by 1 
	
		j print_loop


	end_of_print_loop:
	li $v0, 11   # opcode to print a string to the console
	li $a0, 10 #ascii value for newline is 10
	syscall
	move $v0, $t5 #return number of items printed, put in $v0 return register (computed by counting how many times i was incremented)
	jr $ra





bubble_sort_inner:
	
	move $t8, $a0  #move base of array into $t6
	move $t7, $a1  #move n into $t7
	li $t0, 0 #i = 0 
	#li $t5, 0 #changed variable, changed = 0 
	
	addi $sp, $sp, -4  #store the return address to get back to the outer loop in bubble sort
	sw $ra, 0($sp)     #we have to store the $ra because we make a jal to print array and then $ra would get overwritten
	
	li $v0, 4   # opcode to print a string to the console
	la $a0, entered_b_inner #ascii value for newline is 10
	syscall
	
	move $a0, $t7
	li $v0, 1   # opcode to print a string to the console
	syscall
	
	li $v0, 11   # opcode to print a string to the console
	la $a0, 10 #ascii value for newline is 10
	syscall
	
	bubble_sort_inner_loop:
		
		#set less than, set register = 1 if i < n
		slt $t4, $t0, $t7
		
		#check if register = 0, if so branch to end of loop
		beq $t4, $zero, end_bubble_sort_inner_loop
		#prep args to send for printing
		move $a0, $t8
		move $a1, $t7
		jal print_array
		addi $t0, $t0, 1 #increment i 
		
		#compare the elements of the array j and j+1
		#if element at j > j+ 1 swap elements
		
		
		j bubble_sort_inner_loop
		
		
		end_bubble_sort_inner_loop:
			li $v0, 4
			la $a0, temp 
			syscall
			lw $ra, 0($sp)  #load the return address to get back to outer loop of b_sort
			addi $sp, $sp, 4	
			jr $ra 
		
		#return changed variable 
		#put it in $v0 and return it 
		
		




bubble_sort:
	#load arguments into their new registers and create i
	move $t1, $a0 #base of array arr[0]	WILL CHANGE
	move $t2, $a1 #end of array, n		WONT CHANGE
	li $t0, 0     # set i = 0		WILL CHANGE
	addi $t3, $t2, -1  #t3 will be our n-1, we will need to run our outer loop while i < n-1	WONT CHANGE
	
	addi $sp, $sp, -8
	sw $ra, 4($sp)  #for storing return address 
	sw $t0, 0($sp) #for storing i since we need to maintain i of outer loop bc we will be jumping and linking functions
	
	li $v0, 4
	la $a0, entered_b_sort
	syscall 	
	
	

		bubble_loop:
		
			lw $t0, 0($sp) #load i
 			addi $sp, $sp, 4 #pop i from the stack 

			slt $t4, $t0, $t3 #if i is less than n, set $t4 to 1, otherwise set $t4 to 0  
			
			#check if i is valid (i is less than n / $t3 does not equal zero)
			beq $t4, $zero, end_of_b_loop #if $t4 = 0 its because we"re n, we should terminate and go to the end of the loop
			
			
			
			addi $sp, $sp, -4 #store i
			sw $t0, 0($sp)  #push i into the stack 
			
			#prep args for printing 
			move $a0, $t1
			move $a1, $t2
			jal print_array
			lw $t0, 0($sp)  #load i
			addi $sp, $sp, 4 #pop i
			
			#set n-i-1 so that we can send it as arg N to our inner loop/subroutine
			sub $t8, $t3, $t0 #n-1-i this is the decrement arg being sent to bubble_sort_inner
			li $v0, 4
			la $a0, printing_decrement
			syscall 
			move $a0, $t8
			li $v0, 1
			syscall 
			li $v0, 11
			li $a0, 10 
			syscall
			#prep args to send to inner (base of arr and n-i-1)
			move $a0, $t1
			move $a1, $t8
			
			addi $sp, $sp, -4 #push i into the stack 
			sw $t0, 0($sp) #store it so we keep the same value of i/$t0 when we get back from inner loop
			jal bubble_sort_inner
			#move $a0, $t1
			#move $a1, $t2
			#jal print_array
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $t0, 1 #increment i TEMP ONLY HERE FOR TESTING 
			addi $sp, $sp, -4
			sw $t0, 0($sp)
	
			#print array 0-n
			
			#check return value of subroutine, if return value/changed  =1, terminate
			#addi $t0, $t0, 1 #increment i 
			
			
			j bubble_loop
		
		end_of_b_loop:
		
			move $a0, $t1  #move base of array into $a0 to send it as an argument in print array
			move $a1, $t2  #move n into $a1 to send it as an argument in print array
			#print array one last time
			jal print_array
			li $v0, 4
			la $a0, end_b_loop
			syscall 
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			
			jr $ra
			
			
			#li $v0, 10  #temp
			#syscall	    #temp check
			

