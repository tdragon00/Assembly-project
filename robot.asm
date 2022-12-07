#
#	A proper program header goes here...
#
#
	.data
x:	.word	0:4	# x-coordinates of 4 robots
y:	.word	0:4	# y-coordinates of 4 robots

str1:	.asciiz	"Your coordinates: 25 25\n"
str2:	.asciiz	"Enter move (1 for +x, -1 for -x, 2 for + y, -2 for -y):"
str3:	.asciiz	"Your coordinates: "
sp:	.asciiz	" "
endl:	.asciiz	"\n"
str4:	.asciiz	"Robot at "
str5:	.asciiz	"AAAARRRRGHHHHH... Game over\n"

#i	$s0
#myX	$s1
#myY	$s2
#move	$s3
#status	$s4
#temp,pointers	$s5,$s6
	.text
#	.globl	inc
#	.globl	getNew

main:	li	$s1,25		#  myX = 25
	li	$s2,25		#  myY = 25
	li	$s4,1		#  status = 1

	la	$s5,x
	la	$s6,y

	sw	$0,($s5)	#  x[0] = 0; y[0] = 0;
	sw	$0,($s6)
	sw	$0,4($s5)	#  x[1] = 0; y[1] = 50;
	li	$s7,50
	sw	$s7,4($s6)
	sw	$s7,8($s5)	#  x[2] = 50; y[2] = 0;
	sw	$0,8($s6)
	sw	$s7,12($s5)	#  x[3] = 50; y[3] = 50;
	sw	$s7,12($s6)

	la	$a0,str1	#  cout << "Your coordinates: 25 25\n";
	li	$v0,4
	syscall

	bne	$s4,1,main_exitw	#  while (status == 1) {
main_while:
	la	$a0,str2	#    cout << "Enter move (1 for +x,
	li	$v0,4		#	-1 for -x, 2 for + y, -2 for -y):";
	syscall

	li	$v0,5		#    cin >> move;
	syscall
	move	$s3,$v0

	bne	$s3,1,main_else1#    if (move == 1)
	add	$s1,$s1,1	#      myX++;
	b	main_exitif
main_else1:
	bne	$s3,-1,main_else2	#    else if (move == -1)
	add	$s1,$s1,-1	#      myX--;
	b	main_exitif
main_else2:
	bne	$s3,2,main_else3	#    else if (move == 2)
	add	$s2,$s2,1	#      myY++;
	b	main_exitif
main_else3:	bne	$s3,-2,main_exitif	#    else if (move == -2)
	add	$s2,$s2,-1	#      myY--;

main_exitif:
    la	$a0,x		#    status = moveRobots(&x[0],&y[0],myX,myY); loads address of array
	la	$a1,y       #loading address of y
	move	$a2,$s1
	move	$a3,$s2
	jal	moveRobots  #saves address of move but we jump to back to the  move when we return
	move	$s4,$v0

	la	$a0,str3	#    cout << "Your coordinates: " << myX
	li	$v0,4		#      << " " << myY << endl;
	syscall
	move	$a0,$s1
	li	$v0,1
	syscall
	la	$a0,sp
	li	$v0,4
	syscall
	move	$a0,$s2
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall

	la	$s5,x
	la	$s6,y
	li	$s0,0		#    for (i=0;i<4;i++)
main_for:	la	$a0,str4	#      cout << "Robot at " << x[i] << " "
	li	$v0,4		#           << y[i] << endl;
	syscall
	lw	$a0,($s5)
	li	$v0,1
	syscall
	la	$a0,sp
	li	$v0,4
	syscall
	lw	$a0,($s6)
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall
	add	$s5,$s5,4
	add	$s6,$s6,4
	add	$s0,$s0,1
	blt	$s0,4,main_for

	beq	$s4,1,main_while
				#  }
main_exitw:	la	$a0,str5	#  cout << "AAAARRRRGHHHHH... Game over\n";
	li	$v0,4
	syscall
	li	$v0,10		#}
	syscall

	#	int moveRobots(int *arg0, int *arg1, int arg2, int arg3)
	#
	#	arg0	$a0	base address of array of x-coordinates
	#	arg1	$a1	base address of array of y-coordinates
	#	arg2	$a2	x-coordinate of human (copy in $s2)
	#	arg3	$a3	y-coordinate of human (copy in $s3)
	#	ptrX	$s0
	#	ptrY	$s1
	#	i	$s4
	#	alive	$s5
	#	temp	$s6
	#
	#	moveRobots() calls getNew() to obtain the new coordinates
	#	of each robot. The position of each robot is updated.

	moveRobots:
	           	addi $sp, $sp-4 # saving the register for the call
			sw $ra, 0($sp)
        #moving the address to the stack pointer









		li $s5,1			#  alive = 1;
		move $s2,$a2        # human x copy
		move $s3,$a3        # human y copy

		move $s0,$a0	        #  ptrX = arg0;
        move $s1,$a1			#  ptrY = arg1;


		li $s4,0			#  for (i=0;i<4;i++) {
	loop:
	               lw $a0,0($s0)  # placing robot x into the variable slot  arg $a0.
	               move $a1,$s2  #placing human x into the variabe slot arg $a1

	               jal getNew #    *ptrX = getNew(*ptrX,arg2); input we use $a0,$a1
		            sw $v0, 0($s0)                            #jal getNew  return value we use $v
			                    #the return value of getNew is saved in $v0






		             lw $a0,0($s1)  # placing robot y into the variable slot  arg $a0.
                     move $a1,$s3  #placing human y into the variabe slot arg $a1

                     jal getNew #    *ptry = getNew(*ptrX,arg2); input we use $a0,$a1
                     sw $v0, 0($s1)                            #jal getNew  return value we use $v
                                			                    #the return value of getNew is saved in $v0







			    bne $s0,$s2,inc        	# x check  check if robot caught user  if ((*ptrX == arg2) && (*ptrY == arg3)) {
		        bne $s1,$s3,inc           # y check

				li $s5,0          #      alive = 0;
		j endfor 			  #      breaking since we are no longer alive ;
						  #    }
	inc:
	            addi $s0, $s0, 4 		  #    ptrX++;
			    addi $s1, $s1, 4 	  #    ptrY++;

			    addi $s4,$s4,1        #increminting loop
			    bne $s4,4, loop

						  #  }


	endfor:					  #  return alive;
        				 	  #we are jumping back after we have saved the changes via $ra
			lw $ra, 0($sp)
			addi $sp, $sp 4 # saving the register for the call
			
     


		jr $ra			#}



	#	int getNew(int arg0, int arg1)
	#
	#	arg0	$a0	one coordinate of robot
	#	arg1	$a1	one coordinate of human
	#	temp	$t0
	#	result	$v0
	#
	#	Returns new coordinate of robot. If the absolute difference between
	#	the robot coordinate and human coordinate is >=10, the robot
	#	coordinate moves 10 units closer to the human coordinate.
	#	If the absolute difference is < 10, the robot coordinate
	#	moves 1 unit closer to the human coordinate.

	getNew:				#{
		sub	$t0,$a0,$a1	#  temp = arg0 - arg1;
		blt	$t0,10,gelse1	#  if (temp >= 10)
		sub	$v0,$a0,10	#    result = arg0 - 10;
		j	exitgelse
	gelse1:	blez	$t0,gelse2	#  else if (temp > 0)
		      sub	$v0,$a0,1	#    result = arg0 - 1;
		      j	exitgelse
	gelse2:	bne $v0, 0, gelse3	                #  else if (temp == 0) # not sure here
			 move $v0, $t0                #    result = arg0;
        j exitgelse
	gelse3:	   ble $t0, -10, gelse4              	#  else if (temp > -10)
			 add $v0, $a0, 1                     #    result = arg0 + 1;
            j exitgelse
	gelse4:	bgt	$t0,-10,exitgelse  #  else if (temp <= -10)
				  add	$v0,$a0,10	#    result = arg0 + 10;
	exitgelse:
		jr	$31		#} jumps back to where its called this is where the address is stored could also use ra
