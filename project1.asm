#Name: Zhongwei Li
.data
frameBuffer:    .space 0x80000 # 512 wide X 256 high pixels
m:              .word 0x00000028
n:              .word 0x00000050
c1r:            .word 0x000000FF
c1g:            .word 0x000000FF
c1b:            .word 0x00000000
c2r:            .word 0x00000000
c2g:            .word 0x00000000
c2b:            .word 0x000000FF
c3r:            .word 0x000000FF
c3g:            .word 0x00000000
c3b:            .word 0x00000000

.text
drawLine:    la    $t1,frameBuffer
             #test if the parameters are realizable
             lw    $t3,m #t3 = m
             lw    $t4,n #t4 = n
             add   $t5,$t4,$t4 #t5 = 2n
             add   $t5,$t3,$t5 #t5 = t3 + t5
             addi  $t6,$t6,257 #t6 = 257
             slt   $t0,$t5,$t6 #set t0 to be 1 if t5 < 257, otherwise set it to 0
             beq   $t0,$zero,Exit #exit the program if 2n + m > 256
             addi  $t6,$zero,1 #t6 = 1
             slt   $t0,$t4,$t6 #set t0 to be 1 if n < 1, otherwise set it to 0
             bne   $t0,$zero,Exit #exit if n < 1
             addi  $t6,$zero,0 #t6 = 0
             slt   $t0,$t3,$t6 #set t0 to be 1 if m < 0, otherwise set it to 0
             bne   $t0,$zero,Exit #exit if m < 0
             #load colors into t2,t3,t4
             lw    $t2,c1r #t2 = c1r
             lw    $t3,c1g #t3 = c1g
             lw    $t4,c1b #t4 = c1b
             sll   $t2,$t2,16 #t2 = t2 << 16
             sll   $t3,$t3,8 #t3 = t3 << 8
             add   $t2,$t2,$t3 #t2 = t2 + t3
             add   $t2,$t2,$t4 #t2 = t2 + t4, t2 = color 1
             lw    $t3,c2r #t3 = c2r
             lw    $t4,c2g #t4 = c2g
             lw    $t5,c2b #t5 = c2b
             sll   $t3,$t3,16 #t3 = t3 << 16
             sll   $t4,$t4,8 #t4 = t4 << 8
             add   $t3,$t3,$t4 #t3 = t3 + t4
             add   $t3,$t3,$t5 #t3 = t3 + t5, t3 =  color 2
             lw    $t4,c3r #t4 = c3r
             lw    $t5,c3g #t5 = c3g
             lw    $t6,c3b #t6 = c3b
             sll   $t4,$t4,16 #t4 = t4 << 16
             sll   $t5,$t5,8 #t5 = t5 << 8
             add   $t4,$t4,$t5 #t4 = t4 + t5
             add   $t4,$t4,$t6 #t4 = t4 + t6
             #filling the background with color 1
             addi   $t5,$t1,524288 #t5 = one pixel after last pixel
        Loop:addi  $t5,$t5,-4 #t5 = t5 - 4
             sw    $t2,0($t5) #color the pixel
             bne   $t5,$t1,Loop #if t5 != t1, repeat
             #add one to n if n is odd
             lw    $t2,n #t2 = n
             lw    $t7,m #t7 = m
             andi  $t6,$t2,1 #t6 = t2 & 1
             beq   $t6,$zero,isEven #if t2 & 1 = 0(n is even), skip next line
             addi  $t2,$t2,1 #t2=n+1
             #draw rectangle 1
      isEven:srl   $t6,$t2,1 #t6 = n >> 1 (n / 2)
             add   $t8,$t6,$t7 #t8 = n/2 + m
             addi  $t8,$t8,128 #t8 = 128 + n/2 + m, (t8 = last row of desired rectangle)
             addi  $t9,$t6,256 #t9 = 256 + n/2 (t9 = last column of desired rectangle)
             add   $t5,$t1,$zero #t5 = first pixel
             addi  $t0,$zero,1 #t0 = 1
          L1:addi  $t5,$t5,2048 #use a loop to move t5 to cooresponding row pixel
             addi  $t0,$t0,1 #t0 = t0 + 1
             bne   $t0,$t8,L1
             sll   $t9,$t9,2 #t9 = t9 * 4
             add   $t5,$t5,$t9 #t5 = t5 + t9
             add   $t8,$t2,$zero #t8 = n(columns of rectangle)
             add   $t9,$t7,$t7 #t9 = 2m
             add   $t9,$t9,$t2 #t9 = 2m+n(row of rectangle)
          L2:addi  $t5,$t5,-4 #t5 = t5 - 4
             sw    $t3,0($t5) #color the pixel
             addi  $t8,$t8,-1 #t8 = t8 -1
             bne   $t8,$zero,L2 #if t8 is not 0, loop back(column loop)
             addi  $t5,$t5,-2048 #move t5 to the row above
             sll   $t0,$t2,2 #t0 = n * 4
             add   $t5,$t5,$t0 #adjust position by adding n
             addi  $t9,$t9,-1 #t9 = t9 - 1
             add   $t8,$t2,$zero #reset t8
             bne   $t9,$zero,L2 #if t9 is not zero, loop back(row loop)
             #draw rectangle 2
             add   $t5,$t6,$t7 #t5 = n/2 + m
             addi  $t0,$zero,256
             sub   $t9,$t0,$t5 #t9 = 256 - (n/2) - m,(t9 = first column of desired rectrangle)
             addi  $t0,$zero,128
             sub   $t8,$t0,$t6 #t8 = 128 - (n/2),(t8 = first row of desired rectangle)
             add   $t5,$t1,$zero #t5 = first pixel
             addi  $t0,$zero,0 #t0 = 1
          L3:addi   $t5,$t5,2048 #moving t5 to appropriate row
             addi  $t0,$t0,1 #t0 = t0 + 1
             bne   $t0,$t8,L3
             sll   $t9,$t9,2 #t9 = t9 * 4
             add   $t5,$t5,$t9 #t5 = t5 + t9,(moving t5 to appropriate column)
             add   $t0,$t7,$t7
             add   $t0,$t0,$t2 #t0 = 2m + n
             add   $t8,$zero,$zero #t8 = 0
             add   $t9,$zero,$zero #t9 = 0
          L4:sw    $t3,0($t5) #color the pixel
             addi  $t5,$t5,4 #t5 = t5 + 4
             addi  $t8,$t8,1 #t8 = t8 + 1
             bne   $t8,$t0,L4 #if t8 not equal to t0 move to L4 (repeat for 2m + n times)
             addi  $t5,$t5,2048 #t5 = t5 + 2048,(move t5 to next line)
             sll   $t6,$t0,2 #t6 = t0 * 4
             sub   $t5,$t5,$t6 #t5 = t5 - t6,(reset column position)
             add   $t8,$zero,$zero #t8 = 0,(reset t8)
             addi  $t9,$t9,1 #t9 = t9 + 1
             bne   $t9,$t2,L4 #if t9 not equal to t2, move to L4 (repeat for n times)
             #draw the square
             srl   $t6,$t2,1 #t6 = n >> 1 (n / 2)
             addi  $t0,$zero,256 #t0 = 256 (center column)
             sub   $t9,$t0,$t6 #t9 = 256 - (n/2), t9 = starting column
             addi  $t0,$zero,128 #t0 = 128 (center row)
             sub   $t8,$t0,$t6 #t8 = 128 - (n/2), t8 = starting row
             add   $t3,$t1,$zero #t3 = t1 (starting pixel)
             addi  $t5,$zero,0 #t5 = 0
          L5:addi  $t3,$t3,2048 #moving t3 to appropiate row
             addi  $t5,$t5,1
             bne   $t5,$t8,L5 #loop if t5 is not at starting row
             sll   $t9,$t9,2 #t9 = t9 * 4
             add   $t3,$t3,$t9 #t5 = t5 + t9,(moving t5 to appropiate column)
             add  $t0,$zero,$zero #t0 = 0
             add  $t5,$zero,$zero #t5 = 0
          L6:sw    $t4,0($t3) #color the pixel
             addi  $t3,$t3,4 #t3 = t3 + 4
             addi  $t0,$t0,1 #t0 = t0 + 1
             bne   $t0,$t2,L6 #repeat if t0 is not equal to n
             addi  $t3,$t3,2048 #move t3 to the next row
             sll   $t6,$t2,2 #t6 = n * 4
             sub   $t3,$t3,$t6 #t3 = t3 - t6,(adjust the position of t3)
             addi  $t5,$t5,1 #t5 = t5 + 1
             add   $t0,$zero,$zero #reset t0
             bne   $t5,$t2,L6 #repeat if t5 not equal to n
        Exit:li    $v0,10
             syscall
