# Miguel Manzo 
# CSC656, Coding Project #1
# September 10, 2025
#
# 1 sentence description here: Use assembly language to create bubble sort that uses a subroutine as its inner loop, while checking
#if any changes were made, for early termination or not

.data
arr:	.word	-2, -1, 0, 92, 52, 27, 86, 6, 52, 35    # this is the source data array, please fill with your own random numbers from https://www.calculator.net/random-number-generator.html
n:	.word	10     # hard-coded problem size n=10
a_before_sort: .asciiz "a before sort: "
a_after_sort: .asciiz "a after sort: "
no_changes_were_made: .asciiz "No changes were made (early termination)\n"
.text
.globl main
main:
	li $v0, 4
	la $a0, a_before_sort
	syscall
	la $a0, arr #load the memory address of the array -> arr[0]   arg0 = starting index of iteration
	lw $a1, n # $t1 will act as our length of the array           arg1 = end index of iteration
	jal print_array
	la $a0, arr #upon return of the print_array function, our arr may be at arr[n] so now load arr at base arr[0]
	lw $a1, n #move n-1 to $a1 to send it as an arguement for call to bubble sort
	jal bubble_sort
	li $v0, 4
	la $a0, a_after_sort
	syscall
	la $a0, arr #load the memory address of the array -> arr[0]   arg0 = starting index of iteration
	lw $a1, n # $t1 will act as our length of the array           arg1 = end index of iteration
	jal print_array
	li $v0, 10
	syscall

	
		
				

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
	jr $ra









bubble_sort_inner:
	
	move $t8, $a0  #move base of array into $t6
	move $t7, $a1  #move n into $t7
	li $t0, 0 #i = 0 
	li $s4, 0 #changed variable, changed = 0 this is the return value fo the inner function 
	
	addi $sp, $sp, -4  #store the return address to get back to the outer loop in bubble sort
	sw $ra, 0($sp)     #we have to store the $ra because we make a jal to print array and then $ra would get overwritten
	
	
	bubble_sort_inner_loop:
	
		
		
		#set less than, set $t4 = 1 if i < n
		slt $t4, $t0, $t7
		
		#check if register = 0, if so branch to end of loop
		beq $t4, $zero, end_bubble_sort_inner_loop
		
		
		sll $s0, $t0, 2  #finds the location of arr[i] via i *4 so if i is 4 --> 4*4 will tell us how far to move the ptr
		addu $t6, $t8, $s0  # puts the pointer at the location of the i, so $t6 now has arr[i]
		
		lw $s1, 0($t6)  #since $t6 has the pointer to arr[i], load value into $s1
		lw $s2, 4($t6)  # since 4($t6) gives us the next element in the array, this is arr[i+1], load this val in $s2
		
		#we are going to swap by default, if arr[i] < arr[i+1] skip to the dont swap section 
		# if arr[i] is greater than arr[i+1] set $s3 = 1, otherwise $s3 = 0 which will prompt dont swap in next line
		sgt $s3, $s1, $s2  #if arr[i] is less than than arr[i+1], $s3 = 0, which prompts to jump to dont swap
		
		beq $s3, $zero, dont_swap  #we need to jump to dont swap to skip over the swap
		
		#swap 
		sw $s2, 0($t6)  #0($t6) is arr[i], as of right now $s2 has arr[i+1], so here we are storing arr[i+1] into arr[i]
		sw $s1, 4($t6)  #4($t6) is arr[i+1] as of right now $s1 has arr[i], so here we are storing arr[i] into arr[i+1]
		
		#changed is now 1, we will put this in the return value so our outer knows for early termination 
		li $s4, 1
		
		dont_swap:
		
		addi $t0, $t0, 1 #increment i 
		
	
		j bubble_sort_inner_loop
		
		
		end_bubble_sort_inner_loop:
			lw $ra, 0($sp)  #load the return address to get back to outer loop of b_sort
			addi $sp, $sp, 4
			
			move $v0, $s4	#put the value of changes in $v0 to return it to outer for check 
			jr $ra 
		
	
		
		




bubble_sort:
	#load arguments into their new registers and create i
	move $t1, $a0 #base of array arr[0]	WILL CHANGE
	move $t2, $a1 #end of array, n		WONT CHANGE
	li $t0, 0     # set i = 0		WILL CHANGE
	addi $t3, $t2, -1  #t3 will be our n-1, we will need to run our outer loop while i < n-1	WONT CHANGE
	
	addi $sp, $sp, -8
	sw $ra, 4($sp)  #for storing return address 
	sw $t0, 0($sp) #for storing i since we need to maintain i of outer loop bc we will be jumping and linking functions
	
	
	

		bubble_loop:
			
			#we do this before because theres a chance we jump to end of loop where we pop the stack to get $ra
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
			
			#prep args to send to inner (base of arr and n-i-1)
			move $a0, $t1
			move $a1, $t8
			
			addi $sp, $sp, -4 #push i into the stack 
			sw $t0, 0($sp) #store it so we keep the same value of i/$t0 when we get back from inner loop
			jal bubble_sort_inner
			move $s4, $v0  # put the return value from bubble_sort_inner in $s4
			
			#prep args for printing
			move $a0, $t1
			move $a1, $t2
			jal print_array
			lw $t0, 0($sp) #load i and pop it from the stack 
			addi $sp, $sp, 4
			addi $t0, $t0, 1 #increment i 
			beq $s4, $zero, no_change  #check $s4 for return value of bubble_sort_inner, if 0, terminate
			addi $sp, $sp, -4 #push and store i
			sw $t0, 0($sp)	
			
			
			j bubble_loop
			
	no_change:
		li $v0, 4
		la $a0, no_changes_were_made
		syscall
		j end_of_b_loop
			
	end_of_b_loop:
		
		lw $ra, 0($sp) #load register $ra from the stack so we could jump back to line after jal bubble_sort
		addi $sp, $sp, 4
		jr $ra
			
		

