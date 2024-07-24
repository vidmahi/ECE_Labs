.ORIG x3000

; Name: Vidmahi Sistla
; Date: Resubmission --> 03 / 28 / 2024
; Lab #3
;
;

; BLOCK 1
; Register R0 is loaded with x4000, which will serve as a pointer to the numbers.
;  

    LD R0, PTR1      ; Load pointer to the array

BIG_LOOP:   
    LDR R2, R0, #0
    LD R3, MASK1

    AND R2, R2, R3
    BRz STOP

    ADD R1, R0, #1

LOOPS:
   
    LDR R2, R1, #0
    LD R3, MASK1
    AND R2, R2, R3
    
    BRz ANOTHER
    JSR COMPARE
    
    ADD R6, R6, #0

    BRp SWAP
    ADD R1, R1, #1
    
    BR LOOPS

ANOTHER:
    
    ADD R0, R0, #1
    BR BIG_LOOP


SWAP:
    
    LDR R6, R0, #0
    LDR R5, R1, #0

    STR R5, R0, #0
    STR R6, R1, #0

    ADD R1, R1, #1
    BR LOOPS

COMPARE:
    ; Save registers
     ST R4, TEMP2       ; Save R4
     ST R2, TEMP3
     ST R6, TEMP4       ; Save R6
     ST R5, TEMP5       ; Save R5
    
    AND R4, R4, #0
    LDR R2, R1, #0
    
    LD R3, MASK2
    AND R2, R2, R3
    
    BR SUBTRACT
    
SUBTRACT:
    NOT R2, R2
    ADD R2, R2, #1   
    
    LDR R6, R0, #0 
    AND R6, R6, R3
    
    ADD R5, R6, R2
    
    BRn SOMEWHERE
    
    ADD R4, R4, #1
    
    BR SOMEWHERE

SOMEWHERE:
    ADD R4, R4, #0
    ADD R6, R4, #0      ; R2 = 1
    
    BR Greater
    
    ;RET

Greater:
  
    LD R2, TEMP3    
     RET

STOP:
    HALT



TEMP1 .BLKW 1         ; Temporary storage for R4
TEMP2 .BLKW 1         ; Temporary storage for R3
TEMP3 .BLKW 1         ; Temporary storage for R6
TEMP4 .BLKW 1         ; Temporary storage for R5
TEMP5 .BLKW 1         ; Shift ^^ comments down 1 :D
TEMPR3 .BLKW 1

PTR1	 .FILL x4000
MASK1   .FILL   xFF00
MASK2   .FILL   x00FF

.END
