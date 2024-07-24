    .ORIG x3000
    
; Name: Vidmahi Sistla
; Date: 03 / 04 / 2024
; Lab #2
;

; BLOCK 1
; Register R0 is loaded with x6000.
; Register R1 is loaded with the address of the location where the number is located.
; 

	LD R0,PTR
	LDR R1,R0, #0
; 
; The two 8-bit numbers are now loaded into R1.

    LDR R1, R1, #0

    
    
; BLOCK 2
; In this block, the two unsigned numbers in bits [15:8] and [7:0] on register R1, are first isolated by using masks.
; Mask1 is loaded into R4. The mask is then used to isolate Number 1, which is then loaded into R2.
; Mask2 is loaded into R4. The mask is then used to isolate Number 2, which is then loaded into R3.
; 
; 
	LD R4, MASK1
    AND R2, R1, R4

	LD R4, MASK2	
	LDR R5, R0, #0
	LDR R5, R5, #0
	
	AND R3, R5, R4


; BLOCK 3
; In this block Number 2 is rotated so that the bits are in R3[7:0].

    AND R1, R1, #0
	ADD R1, R1, #8
	
	SHIFTER
    ADD R3, R3, #0
    BRZP SHIFT_ZERO
    ADD R3, R3, R3
    ADD R3, R3, #1
    BR CHECK_FOR_DONE
    
    SHIFT_ZERO
    ADD R3, R3, R3

    CHECK_FOR_DONE
    ADD R1, R1, #-1
    BRZ DONE
    BR SHIFTER
    


; BLOCK 4
; The numbers are added. The result is stored at the location whose address is in x6001.

    DONE
	ADD R5, R2, R3
	LDI R6, STORE_ADDRESS
	STR R5, R6, #0

    HALT
    
    
PTR     .FILL   x6000
MASK1	.FILL	x00FF
MASK2	.FILL	xFF00
STORE_ADDRESS   .FILL   x6001

    .END

