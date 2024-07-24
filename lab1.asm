    .ORIG x3000
    
; Name: Vidmahi Sistla
; Date: 02 / 27 / 2024
; Lab #1
;

; BLOCK 1
; Register R0 is loaded with x6000, which will serve as a pointer.
; The two data are read into registers R1 and R2. 

    LD  R0, PTR
    LDR R1, R0, #0
    LDR R2, R0, #1
    

; BLOCK 2
; In this block, the two 2's complement numbers in bits [15:8], are first isolated by clearing bits [7:0].
; The sum of these two numbers is performed, followed by the check for overflow, which will be done in BLOCK 3.
; Number 1 will be loaded in R1[15:8].
; Number 1 will be loaded in R2[15:8].
; The sum will be loaded in R3[15:8].
; 

    ; AND R1, R1, MASK1
    ; AND R2, R2, MASK1
    
    ; ADD R3, R1, R2
    
    LD R4, MASK1
    
    AND R1, R1, R4
    AND R2, R2, R4
    
    ADD R3, R1, R2
    





; BLOCK 3

; The first 2's complement number has been loaded into R1 - this was done in BLOCK 2.
; The second 2's complement number has been loaded into R2 - this was done in BLOCK 2.
; The sum of the two numbers has been loaded into R3 - this was done in BLOCK 2.
; All numbers are in bits [15:8] with zeros in [7:0].
; 
; In this block we will check for overflow of the 2's complement integer addition.
; The signs of the two numbers and the sign of the calculated sum will be checked. 
; A mismatch indicates an overflow.
; 
; 
; If there was no overflow, then store the sum in x6003[15:8].
; If there was overflow, then store xFFFF in x6003.





;check sign of first number, if pos, check next number, if neg, check next neg, else if zero, store the number

    LD R4, CHECKSIGN; load bit mask to check sign of operand 1
    AND R5, R4, R1
    BRZ CHECKNEXTPOS; if positive, then check the sign of operand 2
    BRN CHECKNEXTNEG;if negative, then check the sign of operand 2
    STR R3, R0, #3; if neither positive nor negative, then operand 1 must be 0, so store the sum
    BR DONE

CHECKNEXTPOS
    AND R5, R4, R2
    BRZ CHECKSUMPOS; if operand 2 is also positive, check if sum if also positive
    STR R3, R0, #3; if operand 2 is negative or 0, store the sum
    BR DONE

CHECKNEXTNEG
    AND R5, R4, R2
    BRN CHECKSUMNEG; if operand 2 is also negative, check if sum if also negative
    STR R3, R0, #3; if operand 2 is positive or 0, store the sum
    BR DONE

CHECKSUMPOS
    AND R5, R4, R3
    BRN OVERFLOW; if both the operands are positive but sum is negative, overflow has occurred
    STR R3, R0, #3; else if the sum is positive, store the sum
    BR DONE

CHECKSUMNEG
    AND R5, R4, R3
    BRZ OVERFLOW; if both the operands are negative but sum is positive, overflow has occurred
    STR R3, R0, #3; else if the sum is negative, store the sum
    BR DONE

OVERFLOW
    LD R4, OVERFLOWVAL
    STR R4, R0, #3; store xFFFF





    
; BLOCK 4
; In this block, the two unsigned numbers in bits [7:0], are first isolated by clearing bits [15:8].
; The sum of these two numbers is performed, followed by the check for overflow, which will be done in BLOCK 5.
; 

DONE
    LD R4, MASK2
    LD R0, PTR
    LDR R1, R0, #0
    LDR R2, R0, #1
    
    AND R1, R1, R4
    AND R2, R2, R4
    
    ADD R3, R1, R2
    
    ; And with r2 nd put back into r2
    ; load the numbers again
    ; Ready to isolate again - r1 and r2 contain 0s in 15:8
    ; After adding, now r3 will have 1 of 2 types of numbers, 15:9 with all 0s, 8 unknown, and 7:0 will have smth
    ; if bit 8 is 0, no overflow, but if it is a 1, that means that overflow has occurred, and bit 7:0 has the wrong sum
    ; how to isolate bit 8? we can and it with mask 0000000100000000
    ; some of these are provided in the labels below
    







; BLOCK 5
; In this block we will check for overflow of the unsigned integer addition.
; The final carry out is what indicates overflow for unsigned integers.
; Since the unsigned integers are in bits [7:0], the final carry out will be in bit position 8.
; If there was no overflow, then store the sum in x6002.
; If there was overflow, then store xFFFF in x6002.

    LD R4, MASK3
    AND R4, R3, R4
    
    BRZ NO_OVERFLOW
    
    LD R3, NEG_ONE
    
    STR R3, R0, #2 ; added lines
    BR END_PROGRAM
    
    
NO_OVERFLOW
    STI R3, PTR2
    
END_PROGRAM
    HALT
    
    
PTR .FILL x6000
PTR2    .FILL   x6002
CHECKSIGN .FILL x8000
OVERFLOWVAL .FILL XFFFF
MASK1   .FILL   XFF00
MASK2   .FILL   x00FF
MASK3   .FILL   x0100
NEG_ONE .FILL   xFFFF

    .END

