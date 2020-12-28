#Zhongwei Li
.data
    a:	.word 0
    b:	.word 98
    
.text
Main:    #check if a and b are in range
         lw    $s0, a #s0 = a
         lw    $s1, b #s1 = b
         blt   $s1,$s0,Exit #exit if b < a
         blt   $s0,$zero,Exit #exit if a < 0
         addi  $t0,$zero,99 #t0 = 99
         blt   $t0,$s1,Exit #exit if b>99
         addi  $s1,$s1,1 #s1 = b + 1
         #breaking "a" into two digits inside t0 and t1
         add   $t1,$s0,$zero #t1 = a
         add   $t0,$zero,$zero #t0 = 0
subtract:blt   $t1,10,continue #break out of the loop if t1 is less than 10
         addi  $t1,$t1,-10 #t1 = t1 - 10
         addi  $t0,$t0,1 #t0 = t0 + 1
         j     subtract
         #call display()
continue:#t0 = digit1, t1 = digit2
         addi  $sp,$sp,-16 #$push $s0,$s1,$t0,and $t1
         sw    $s0,12($sp)
         sw    $s1,8($sp)
         sw    $t0,4($sp)
         sw    $t1,0($sp)
         beq   $t0,$zero,right #skip the left digit if the first digit is zero
         add   $a0,$zero,$zero #arg0 = 0
         add   $a1,$t0,$zero #arg1 = t0(first digit)
         jal   Display #call Display(0,first digit)
         lw    $s0,12($sp) #load $s0,$s1,$t0,and $t1 from stack
         lw    $s1,8($sp)
         lw    $t0,4($sp)
         lw    $t1,0($sp)
  right: addi  $a0,$zero,1 #arg0 = 1
         add   $a1,$t1,$zero #arg1 = t1(second digit)
         jal   Display #call Display(1,second digit)
         lw    $s0,12($sp) #load $s0,$s1,$t0,and $t1 from stack
         lw    $s1,8($sp)
         lw    $t0,4($sp)
         lw    $t1,0($sp)
         addi  $sp,$sp,16 #reclaim stack space
         addi  $t1,$1,1 #t1 = t1 + 1
         blt   $t1,10,notTen #if t1 is 10 turn t1 to 0 and increment t0,otherwise skip next two lines
         add   $t1,$zero,$zero #t1 = zero
         addi  $t0,$t0,1 #t0 = t0 + 1
  notTen:addi  $s0,$s0,1 #a = a + 1
         beq   $s0,$s1,Exit #exit the program if a is equal to b + 1
         #delay loop
         add  $t2,$zero,$zero #t2 = 0
  delay: addi  $t2,$t2,1 #t2 = $t2 + 1
         bne   $t2,200000,delay #breaking out of the delay loop
         j     continue
         #define Display()
 Display:la    $t1,0xFFFF0011 #t1 = left address
         beq   $a0,$zero,skip #skip next line if arg0 is 0
         la    $t1,0xFFFF0010 #t1 = right address
   skip: beq   $a1,0,zero #jump to the appropiate lable based on the value of arg1
         beq   $a1,1,one
         beq   $a1,2,two
         beq   $a1,3,three
         beq   $a1,4,four
         beq   $a1,5,five
         beq   $a1,6,six
         beq   $a1,7,seven
         beq   $a1,8,eight
         beq   $a1,9,nine
    zero:addi  $t0,$zero,0x3F #t0 = 0x3F
         sb    $t0,0($t1) #light the corresponding segments of 0
         jr    $ra #return to the caller
    one: addi  $t0,$zero,0x06 #t0 = 0x06
         sb    $t0,0($t1) #light the corresponding segments of 1
         jr    $ra #return to the caller
    two: addi  $t0,$zero,0x5B #t0 = 0x5B
         sb    $t0,0($t1) #light the corresponding segments of 2
         jr    $ra #return to the caller
   three:addi  $t0,$zero,0x4F #t0 = 0x4F
         sb    $t0,0($t1) #light the corresponding segments of 3
         jr    $ra #return to the caller
    four:addi  $t0,$zero,0x66 #t0 = 0x66
         sb    $t0,0($t1) #light the corresponding segments of 4
         jr    $ra #return to the caller
    five:addi  $t0,$zero,0x6D #t0 = 0x6D
         sb    $t0,0($t1) #light the corresponding segments of 5
         jr    $ra #return to the caller
    six: addi  $t0,$zero,0x7D #t0 = 0x7D
         sb    $t0,0($t1) #light the corresponding segments of 6
         jr    $ra #return to the caller
   seven:addi  $t0,$zero,0x07 #t0 = 0x07
         sb    $t0,0($t1) #light the corresponding segments of 7
         jr    $ra #return to the caller
   eight:addi  $t0,$zero,0x7F #t0 = 0x7F
         sb    $t0,0($t1) #light the corresponding segments of 8
         jr    $ra #return to the caller
    nine:addi  $t0,$zero,0x6F #t0 = 0x6F
         sb    $t0,0($t1) #light the corresponding segments of 9
         jr    $ra #return to the caller
   Exit: li    $v0,10
         syscall
